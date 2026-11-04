import { Clip } from './clip';
import { type FlashColor, rgba } from './color';

export const FONT_FAMILY = '"Libre Franklin", "Franklin Gothic Medium", "Franklin Gothic", Arial, sans-serif';

export interface TextOptions {
  text?: string;
  size: number;
  color: FlashColor;
  align?: 'left' | 'center' | 'right';
  /** Largeur du champ (alignement centre/droite) ; 0 = taille automatique. */
  width?: number;
  bold?: boolean;
  /** Largeur maximale du texte : au-delà, il est condensé horizontalement. */
  fitWidth?: number;
}

/**
 * Champ texte Flash simplifié, sur une ligne. Comme dans Flash, (x, y) est le coin
 * haut-gauche du champ et le texte commence 2 px plus loin (la « gouttière »).
 */
export class TextField extends Clip {
  text: string;
  size: number;
  color: FlashColor;
  align: 'left' | 'center' | 'right';
  width: number;
  bold: boolean;
  fitWidth: number;

  constructor(name: string, opts: TextOptions) {
    super(name);
    this.text = opts.text ?? '';
    this.size = opts.size;
    this.color = opts.color;
    this.align = opts.align ?? 'left';
    this.width = opts.width ?? 0;
    this.bold = opts.bold ?? false;
    this.fitWidth = opts.fitWidth ?? 0;
  }

  get font(): string {
    return `${this.bold ? 600 : 500} ${this.size}px ${FONT_FAMILY}`;
  }

  protected override drawContent(ctx: CanvasRenderingContext2D, alpha: number): void {
    if (!this.text) return;
    ctx.font = this.font;
    ctx.fillStyle = rgba(this.color, 100 * alpha);
    ctx.textBaseline = 'alphabetic';
    ctx.textAlign = this.align;
    const ascent = this.size * ASCENT;
    const k = this.condense(ctx);
    if (k < 1) {
      ctx.save();
      ctx.translate(this.anchorX(), 0);
      ctx.scale(k, 1);
      ctx.fillText(this.text, 0, 2 + ascent);
      ctx.restore();
    } else ctx.fillText(this.text, this.anchorX(), 2 + ascent);
  }

  /**
   * Libre Franklin est un peu plus large que Franklin Gothic Medium : un texte qui dépasserait
   * la largeur qu'il avait dans l'original est légèrement condensé, pour garder la mise en page.
   */
  private condense(ctx: CanvasRenderingContext2D): number {
    if (!this.fitWidth) return 1;
    const w = ctx.measureText(this.text).width;
    return w > this.fitWidth ? this.fitWidth / w : 1;
  }

  protected override hitContent(ctx: CanvasRenderingContext2D, x: number, y: number): boolean {
    if (!this.text) return false;
    ctx.font = this.font;
    const w = ctx.measureText(this.text).width * this.condense(ctx);
    const left = this.anchorX() - (this.align === 'center' ? w / 2 : this.align === 'right' ? w : 0);
    return x >= left && x <= left + w && y >= 0 && y <= this.size * 1.3 + 4;
  }

  private anchorX(): number {
    if (this.align === 'center') return this.width / 2;
    if (this.align === 'right') return this.width - 2;
    return 2;
  }
}

/** Hauteur de la partie haute des lettres, en proportion de la taille (la même que dans drawContent). */
const ASCENT = 0.9;

/**
 * Champ texte dynamique placé comme dans le SWF : `place` est la position du placement,
 * `bounds` les bornes du champ (x1, y1, x2, y2) relatives à ce placement.
 */
export function editText(
  name: string,
  opts: Omit<TextOptions, 'width'>,
  place: [number, number],
  bounds: [number, number, number, number],
): TextField {
  const field = new TextField(name, { ...opts, width: bounds[2] - bounds[0] });
  field.x = place[0] + bounds[0];
  field.y = place[1] + bounds[1];
  return field;
}

/**
 * Texte statique placé par sa ligne de base (x, y) dans le repère du parent.
 * `width` : largeur du texte dans l'original (bornes du DefineText), qu'il ne dépassera pas.
 */
export function staticText(
  name: string, text: string, size: number, color: FlashColor, x: number, baseline: number, width?: number,
): TextField {
  const field = new TextField(name, { text, size, color, fitWidth: width });
  field.x = x - 2;
  field.y = baseline - 2 - size * ASCENT;
  return field;
}
