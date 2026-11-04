import { type FlashColor, rgba } from './color';

/**
 * Matrice de dégradé Flash.
 * - `box` : forme `{matrixType: 'box', x, y, w, h, r}` de beginGradientFill ;
 * - `matrix` : matrice brute d'une forme SWF, en pixels, appliquée au carré de dégradé de ±819,2 px.
 */
export type GradientMatrix =
  | { matrixType: 'box'; x: number; y: number; w: number; h: number; r: number }
  | { matrixType: 'matrix'; a: number; b: number; c: number; d: number; tx: number; ty: number };

interface StrokeStyle {
  thickness: number;
  color: FlashColor;
  alpha: number;
}

type FillStyle =
  | { kind: 'solid'; color: FlashColor; alpha: number }
  | {
      kind: 'gradient';
      type: 'linear' | 'radial';
      colors: FlashColor[];
      alphas: number[];
      ratios: number[];
      matrix: GradientMatrix;
    };

type Item =
  | { kind: 'fill'; path: Path2D; style: FillStyle }
  | { kind: 'stroke'; path: Path2D; style: StrokeStyle };

const GRADIENT_HALF = 819.2;

/**
 * API de dessin de MovieClip (lineStyle, beginFill, moveTo, lineTo, curveTo…).
 *
 * Comme dans Flash : chaque bloc beginFill/endFill forme une couche (le remplissage puis ses traits),
 * dessinée par-dessus la précédente ; les remplissages suivent la règle pair-impair ; les traits ont
 * des extrémités et jointures arrondies et suivent l'échelle du clip.
 */
export class Graphics {
  private items: Item[] = [];
  private stroke: StrokeStyle | null = null;
  private strokePath: Path2D | null = null;
  private fill: FillStyle | null = null;
  private fillPath: Path2D | null = null;
  private fillStart = { x: 0, y: 0 };
  /** Traits émis pendant le bloc de remplissage en cours : ils passent au-dessus du remplissage. */
  private pendingStrokes: Item[] = [];
  private penX = 0;
  private penY = 0;
  /** Boîte englobante locale (traits compris), utile pour la détection de survol. */
  bounds: { x1: number; y1: number; x2: number; y2: number } | null = null;

  get isEmpty(): boolean {
    return this.items.length === 0 && !this.strokePath && !this.fillPath;
  }

  clear(): void {
    this.items = [];
    this.stroke = null;
    this.strokePath = null;
    this.fill = null;
    this.fillPath = null;
    this.pendingStrokes = [];
    this.penX = this.penY = 0;
    this.bounds = null;
  }

  /** Sans argument (ou épaisseur undefined) : plus de trait, comme Flash. */
  lineStyle(thickness?: number, color: FlashColor = 0, alpha = 100): void {
    this.flushStroke();
    this.stroke = thickness === undefined ? null : { thickness, color, alpha };
  }

  beginFill(color: FlashColor, alpha = 100): void {
    this.startFill({ kind: 'solid', color, alpha });
  }

  beginGradientFill(
    type: 'linear' | 'radial',
    colors: FlashColor[],
    alphas: number[],
    ratios: number[],
    matrix: GradientMatrix,
  ): void {
    this.startFill({ kind: 'gradient', type, colors, alphas, ratios, matrix });
  }

  endFill(): void {
    if (!this.fill || !this.fillPath) return;
    // Flash referme automatiquement le contour au point de départ du remplissage.
    if (this.penX !== this.fillStart.x || this.penY !== this.fillStart.y) {
      this.lineTo(this.fillStart.x, this.fillStart.y);
    }
    this.flushStroke();
    this.items.push({ kind: 'fill', path: this.fillPath, style: this.fill });
    this.items.push(...this.pendingStrokes);
    this.pendingStrokes = [];
    this.fill = null;
    this.fillPath = null;
  }

  moveTo(x: number, y: number): void {
    this.penX = x;
    this.penY = y;
    this.fillPath?.moveTo(x, y);
    this.strokePath?.moveTo(x, y);
    if (this.fillPath) this.fillStart = { x, y };
  }

  lineTo(x: number, y: number): void {
    this.ensurePaths();
    this.fillPath?.lineTo(x, y);
    this.strokePath?.lineTo(x, y);
    this.grow(this.penX, this.penY);
    this.grow(x, y);
    this.penX = x;
    this.penY = y;
  }

  curveTo(cx: number, cy: number, x: number, y: number): void {
    this.ensurePaths();
    this.fillPath?.quadraticCurveTo(cx, cy, x, y);
    this.strokePath?.quadraticCurveTo(cx, cy, x, y);
    this.grow(this.penX, this.penY);
    this.grow(cx, cy);
    this.grow(x, y);
    this.penX = x;
    this.penY = y;
  }

  render(ctx: CanvasRenderingContext2D, alpha: number): void {
    for (const item of this.allItems()) {
      if (item.kind === 'fill') {
        ctx.fillStyle = this.fillStyleFor(ctx, item.style, alpha);
        ctx.fill(item.path, 'evenodd');
      } else {
        const s = item.style;
        ctx.strokeStyle = rgba(s.color, s.alpha * alpha);
        ctx.lineWidth = this.lineWidth(ctx, s.thickness);
        ctx.stroke(item.path);
      }
    }
  }

  /** Applique les remplissages comme zone de découpe (usage : masques). */
  clipTo(ctx: CanvasRenderingContext2D): void {
    const path = new Path2D();
    for (const item of this.allItems()) if (item.kind === 'fill') path.addPath(item.path);
    ctx.clip(path, 'evenodd');
  }

  /** Test de contact en coordonnées locales : remplissages et traits, comme le hitTest Flash. */
  hitTest(ctx: CanvasRenderingContext2D, x: number, y: number): boolean {
    const b = this.bounds;
    if (!b || x < b.x1 - 4 || x > b.x2 + 4 || y < b.y1 - 4 || y > b.y2 + 4) return false;
    for (const item of this.allItems()) {
      if (item.kind === 'fill') {
        if (ctx.isPointInPath(item.path, x, y, 'evenodd')) return true;
      } else {
        ctx.lineWidth = Math.max(item.style.thickness, 1);
        if (ctx.isPointInStroke(item.path, x, y)) return true;
      }
    }
    return false;
  }

  private allItems(): Item[] {
    const extra: Item[] = [];
    if (this.fill && this.fillPath) extra.push({ kind: 'fill', path: this.fillPath, style: this.fill });
    extra.push(...this.pendingStrokes);
    if (this.stroke && this.strokePath) extra.push({ kind: 'stroke', path: this.strokePath, style: this.stroke });
    return extra.length ? [...this.items, ...extra] : this.items;
  }

  private startFill(style: FillStyle): void {
    this.endFill();
    this.flushStroke();
    this.fill = style;
    this.fillPath = new Path2D();
    this.fillPath.moveTo(this.penX, this.penY);
    this.fillStart = { x: this.penX, y: this.penY };
  }

  private ensurePaths(): void {
    if (this.stroke && !this.strokePath) {
      this.strokePath = new Path2D();
      this.strokePath.moveTo(this.penX, this.penY);
    }
  }

  private flushStroke(): void {
    if (this.stroke && this.strokePath) {
      const item: Item = { kind: 'stroke', path: this.strokePath, style: this.stroke };
      if (this.fill) this.pendingStrokes.push(item);
      else this.items.push(item);
    }
    this.strokePath = null;
  }

  private grow(x: number, y: number): void {
    const b = this.bounds;
    if (!b) this.bounds = { x1: x, y1: y, x2: x, y2: y };
    else {
      if (x < b.x1) b.x1 = x;
      if (x > b.x2) b.x2 = x;
      if (y < b.y1) b.y1 = y;
      if (y > b.y2) b.y2 = y;
    }
  }

  /** Épaisseur 0 = trait « hairline » d'un pixel écran, quelle que soit l'échelle. */
  private lineWidth(ctx: CanvasRenderingContext2D, thickness: number): number {
    if (thickness > 0) return thickness;
    const m = ctx.getTransform();
    return 1 / Math.max(Math.hypot(m.a, m.b), 1e-6);
  }

  private fillStyleFor(ctx: CanvasRenderingContext2D, style: FillStyle, alpha: number): string | CanvasGradient {
    if (style.kind === 'solid') return rgba(style.color, style.alpha * alpha);
    const m = style.matrix;
    let gradient: CanvasGradient;
    if (m.matrixType === 'box') {
      const cx = m.x + m.w / 2;
      const cy = m.y + m.h / 2;
      gradient =
        style.type === 'radial'
          ? ctx.createRadialGradient(cx, cy, 0, cx, cy, Math.max(m.w, m.h) / 2)
          : ctx.createLinearGradient(m.x, cy, m.x + m.w, cy);
    } else if (style.type === 'linear') {
      gradient = ctx.createLinearGradient(
        m.tx - m.a * GRADIENT_HALF,
        m.ty - m.b * GRADIENT_HALF,
        m.tx + m.a * GRADIENT_HALF,
        m.ty + m.b * GRADIENT_HALF,
      );
    } else {
      gradient = ctx.createRadialGradient(m.tx, m.ty, 0, m.tx, m.ty, Math.hypot(m.a, m.b) * GRADIENT_HALF);
    }
    style.ratios.forEach((ratio, i) => {
      gradient.addColorStop(ratio / 255, rgba(style.colors[i], (style.alphas[i] ?? 100) * alpha));
    });
    return gradient;
  }
}
