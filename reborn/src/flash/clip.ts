import { Graphics } from './graphics';

export type ClipHandler = (this: Clip) => void;

/**
 * Profondeur réelle d'un élément posé dans la timeline Flash (calque `layer`) : ces éléments vivent
 * sous zéro, à l'abri des clips créés par le code (createEmptyMovieClip, attachMovie) aux profondeurs ≥ 0.
 */
export const timelineDepth = (layer: number): number => layer - 16384;

/**
 * Équivalent d'un MovieClip Flash : position, échelle en %, alpha en %, enfants rangés par profondeur.
 *
 * La sémantique des profondeurs est celle de Flash, car le code d'origine en dépend
 * (les points 3D se trient par `swapDepths(100000 - z * 100)`) :
 * - créer un clip à une profondeur occupée remplace l'occupant ;
 * - `swapDepths` vers une profondeur occupée échange les deux clips.
 */
export class Clip {
  name: string;
  parent: Clip | null = null;
  depth = 0;

  x = 0;
  y = 0;
  xscale = 100;
  yscale = 100;
  rotation = 0;
  alpha = 100;
  visible = true;

  readonly graphics = new Graphics();
  /** Clip utilisé comme masque de celui-ci (setMask). */
  mask: Clip | null = null;
  /** Vrai si ce clip sert de masque : il n'est alors pas dessiné. */
  isMask = false;

  onEnterFrame?: ClipHandler;
  onRollOver?: ClipHandler;
  onRollOut?: ClipHandler;
  onPress?: ClipHandler;
  onRelease?: ClipHandler;
  onReleaseOutside?: ClipHandler;
  /** Zone de survol explicite (coordonnées locales) ; sinon le contenu dessiné. */
  hitArea: { x: number; y: number; w: number; h: number } | null = null;
  /** Désactive le survol et les clics (équivalent de `enabled = false`). */
  enabled = true;
  /** Curseur « main » au survol (comme `useHandCursor` en AS2). */
  useHandCursor = true;

  /** Champs libres : le code d'origine accroche des propriétés arbitraires aux clips. */
  readonly vars: Record<string, unknown> = {};

  private kids: Clip[] = [];
  private named = new Map<string, Clip>();
  private static nextUid = 1;
  readonly uid = Clip.nextUid++;

  constructor(name = '') {
    this.name = name;
  }

  get children(): readonly Clip[] {
    return this.kids;
  }

  get isButton(): boolean {
    return !!(this.onRollOver || this.onRollOut || this.onPress || this.onRelease || this.onReleaseOutside);
  }

  /** Chemin lisible, comme `_level10.E.api0` ; sert aussi de clé dans le moteur d'animation. */
  get path(): string {
    return this.parent ? `${this.parent.path}.${this.name}` : this.name;
  }

  child<T extends Clip = Clip>(name: string): T | undefined {
    return this.named.get(name) as T | undefined;
  }

  createEmptyMovieClip(name: string, depth: number): Clip {
    return this.addChildAt(new Clip(name), depth, name);
  }

  /** attachMovie : place une instance de « symbole » (un clip déjà construit). */
  addChildAt<T extends Clip>(clip: T, depth: number, name = clip.name): T {
    clip.parent?.detach(clip);
    clip.name = name;
    const occupant = this.atDepth(depth);
    if (occupant) occupant.removeMovieClip();
    const sameName = this.named.get(name);
    if (sameName && sameName !== clip) this.named.delete(name);
    clip.parent = this;
    clip.depth = depth;
    this.insertSorted(clip);
    this.named.set(name, clip);
    return clip;
  }

  removeMovieClip(): void {
    this.parent?.detach(this);
  }

  swapDepths(target: number | Clip): void {
    const parent = this.parent;
    if (!parent) return;
    const depth = typeof target === 'number' ? Math.trunc(target) : target.depth;
    if (depth === this.depth) return;
    const other = parent.atDepth(depth);
    parent.kids.splice(parent.kids.indexOf(this), 1);
    if (other) {
      parent.kids.splice(parent.kids.indexOf(other), 1);
      other.depth = this.depth;
      parent.insertSorted(other);
    }
    this.depth = depth;
    parent.insertSorted(this);
  }

  setMask(mask: Clip | null): void {
    if (this.mask) this.mask.isMask = false;
    this.mask = mask;
    if (mask) mask.isMask = true;
  }

  /** Matrice locale → parent. */
  localMatrix(): DOMMatrix {
    const m = new DOMMatrix();
    m.translateSelf(this.x, this.y);
    if (this.rotation) m.rotateSelf(this.rotation);
    m.scaleSelf(this.xscale / 100, this.yscale / 100);
    return m;
  }

  /** Matrice locale → scène (coordonnées Flash 980×730). */
  globalMatrix(): DOMMatrix {
    const local = this.localMatrix();
    return this.parent ? this.parent.globalMatrix().multiply(local) : local;
  }

  globalToLocal(x: number, y: number): { x: number; y: number } {
    const p = this.globalMatrix().inverse().transformPoint(new DOMPoint(x, y));
    return { x: p.x, y: p.y };
  }

  /** `_xmouse` / `_ymouse` : position de la souris dans le repère du clip. */
  get xmouse(): number {
    return this.globalToLocal(Clip.mouse.x, Clip.mouse.y).x;
  }

  get ymouse(): number {
    return this.globalToLocal(Clip.mouse.x, Clip.mouse.y).y;
  }

  /** Position de la souris en coordonnées de scène, tenue à jour par Stage. */
  static mouse = { x: 0, y: 0 };

  /** Dessin propre au clip, après ses graphismes et avant ses enfants (texte, etc.). */
  protected drawContent(_ctx: CanvasRenderingContext2D, _alpha: number): void {}

  /** Test de contact propre au clip, en coordonnées locales (texte, etc.). */
  protected hitContent(_ctx: CanvasRenderingContext2D, _x: number, _y: number): boolean {
    return false;
  }

  render(ctx: CanvasRenderingContext2D, parentAlpha: number): void {
    if (!this.visible || this.isMask) return;
    const alpha = parentAlpha * (this.alpha / 100);
    if (alpha <= 0) return;
    ctx.save();
    const m = this.localMatrix();
    ctx.transform(m.a, m.b, m.c, m.d, m.e, m.f);
    if (this.mask) this.applyMask(ctx);
    this.graphics.render(ctx, alpha);
    this.drawContent(ctx, alpha);
    for (const kid of this.kids) kid.render(ctx, alpha);
    ctx.restore();
  }

  /**
   * Teste si le point (coordonnées de scène) touche ce clip ou un descendant visible.
   * `ctx` est un contexte hors écran utilisé pour isPointInPath.
   */
  hitTestPoint(ctx: CanvasRenderingContext2D, gx: number, gy: number): boolean {
    if (!this.visible || this.isMask) return false;
    const p = this.globalToLocal(gx, gy);
    if (this.hitArea) {
      const h = this.hitArea;
      return p.x >= h.x && p.x <= h.x + h.w && p.y >= h.y && p.y <= h.y + h.h;
    }
    if (!this.graphics.isEmpty && this.graphics.hitTest(ctx, p.x, p.y)) return true;
    if (this.hitContent(ctx, p.x, p.y)) return true;
    return this.kids.some((kid) => kid.hitTestPoint(ctx, gx, gy));
  }

  /** Parcours en profondeur, parent d'abord. */
  *walk(): Generator<Clip> {
    yield this;
    for (const kid of [...this.kids]) yield* kid.walk();
  }

  private applyMask(ctx: CanvasRenderingContext2D): void {
    const mask = this.mask!;
    // Le masque est positionné dans le repère du parent commun (cas du code d'origine : clips frères).
    const m = this.localMatrix().inverse().multiply(mask.localMatrix());
    ctx.transform(m.a, m.b, m.c, m.d, m.e, m.f);
    mask.graphics.clipTo(ctx);
    for (const kid of mask.kids) {
      const km = kid.localMatrix();
      ctx.transform(km.a, km.b, km.c, km.d, km.e, km.f);
      kid.graphics.clipTo(ctx);
      ctx.transform(...invertArgs(km));
    }
    ctx.transform(...invertArgs(m));
  }

  private atDepth(depth: number): Clip | undefined {
    return this.kids.find((k) => k.depth === depth);
  }

  private detach(clip: Clip): void {
    const i = this.kids.indexOf(clip);
    if (i >= 0) this.kids.splice(i, 1);
    if (this.named.get(clip.name) === clip) this.named.delete(clip.name);
    clip.parent = null;
  }

  private insertSorted(clip: Clip): void {
    let i = this.kids.length;
    while (i > 0 && this.kids[i - 1].depth > clip.depth) i--;
    this.kids.splice(i, 0, clip);
  }
}

function invertArgs(m: DOMMatrix): [number, number, number, number, number, number] {
  const i = m.inverse();
  return [i.a, i.b, i.c, i.d, i.e, i.f];
}
