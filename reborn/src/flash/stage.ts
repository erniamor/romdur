import { Clip } from './clip';

export const STAGE_WIDTH = 980;
export const STAGE_HEIGHT = 730;
export const FPS = 25;

/** Tâche exécutée à chaque image après les onEnterFrame des clips (moteurs d'animation et de dessin). */
export type FrameSystem = () => void;

/**
 * Scène Flash 980×730 à 25 i/s, dessinée sur un canvas plein écran.
 *
 * - Mise à l'échelle « showAll » : la scène entière est visible, centrée, et le contenu qui
 *   déborde reste visible (comme le lecteur Flash dans une page).
 * - Rendu en résolution native (devicePixelRatio) : traits nets en haute définition.
 * - La logique avance par images fixes de 40 ms : les durées du code d'origine sont en images.
 */
export class Stage {
  readonly root = new Clip('_level0');
  readonly canvas: HTMLCanvasElement;
  private readonly ctx: CanvasRenderingContext2D;
  private readonly hitCtx: CanvasRenderingContext2D;
  private readonly systems: FrameSystem[] = [];
  private readonly mouseDownListeners = new Set<() => void>();
  private readonly mouseUpListeners = new Set<() => void>();
  private readonly emptyClickListeners = new Set<() => void>();
  /** Début d'un clic qui n'a touché aucun bouton (coordonnées de scène), sinon null. */
  private emptyPress: { x: number; y: number } | null = null;

  private scale = 1;
  private offsetX = 0;
  private offsetY = 0;
  private dpr = 1;

  private hovered: Clip | null = null;
  private pressed: Clip | null = null;
  private lastTime = 0;
  private accumulator = 0;
  private dirty = true;
  /** Nombre d'images logiques écoulées depuis le démarrage. */
  frame = 0;

  constructor(canvas: HTMLCanvasElement) {
    this.canvas = canvas;
    this.ctx = canvas.getContext('2d')!;
    this.hitCtx = document.createElement('canvas').getContext('2d')!;
    this.resize();
    window.addEventListener('resize', () => this.resize());
    this.bindInput();
  }

  addSystem(system: FrameSystem): void {
    this.systems.push(system);
  }

  /** Équivalent de `onMouseDown` / `Mouse.addListener` : clic n'importe où sur la scène. */
  onMouseDown(listener: () => void): () => void {
    this.mouseDownListeners.add(listener);
    return () => this.mouseDownListeners.delete(listener);
  }

  onMouseUp(listener: () => void): () => void {
    this.mouseUpListeners.add(listener);
    return () => this.mouseUpListeners.delete(listener);
  }

  /** Clic (ou toucher) dans le vide : appuyé et relâché sans toucher de bouton, sans glisser. */
  onEmptyClick(listener: () => void): () => void {
    this.emptyClickListeners.add(listener);
    return () => this.emptyClickListeners.delete(listener);
  }

  start(): void {
    requestAnimationFrame((t) => {
      this.lastTime = t;
      this.loop(t);
    });
  }

  toggleFullscreen(): void {
    if (document.fullscreenElement) void document.exitFullscreen();
    else void document.documentElement.requestFullscreen?.().catch(() => {});
  }

  /** Une image logique : onEnterFrame des clips, puis les systèmes (animations, dessin 3D). */
  step(): void {
    this.frame++;
    for (const clip of [...this.root.walk()]) {
      if (clip.onEnterFrame && this.isAttached(clip)) clip.onEnterFrame.call(clip);
    }
    for (const system of this.systems) system();
    this.updateHover();
    this.dirty = true;
  }

  private loop(time: number): void {
    const frameMs = 1000 / FPS;
    this.accumulator += Math.min(time - this.lastTime, 250);
    this.lastTime = time;
    let steps = 0;
    while (this.accumulator >= frameMs && steps < 5) {
      this.step();
      this.accumulator -= frameMs;
      steps++;
    }
    if (steps === 5) this.accumulator = 0;
    if (this.dirty) this.render();
    requestAnimationFrame((t) => this.loop(t));
  }

  private render(): void {
    const { ctx } = this;
    ctx.setTransform(1, 0, 0, 1, 0, 0);
    ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
    ctx.lineCap = 'round';
    ctx.lineJoin = 'round';
    const s = this.scale * this.dpr;
    ctx.setTransform(s, 0, 0, s, this.offsetX * this.dpr, this.offsetY * this.dpr);
    this.root.render(ctx, 1);
    this.dirty = false;
  }

  private resize(): void {
    const w = window.innerWidth;
    const h = window.innerHeight;
    this.dpr = Math.min(window.devicePixelRatio || 1, 3);
    this.canvas.width = Math.round(w * this.dpr);
    this.canvas.height = Math.round(h * this.dpr);
    this.scale = Math.min(w / STAGE_WIDTH, h / STAGE_HEIGHT);
    this.offsetX = (w - STAGE_WIDTH * this.scale) / 2;
    this.offsetY = (h - STAGE_HEIGHT * this.scale) / 2;
    this.dirty = true;
  }

  private bindInput(): void {
    const c = this.canvas;
    c.addEventListener('pointermove', (e) => {
      this.setMouse(e);
      this.updateHover();
    });
    c.addEventListener('pointerdown', (e) => {
      this.setMouse(e);
      // Au toucher, il n'y a pas de survol préalable : on le simule avant le clic.
      this.updateHover();
      this.mouseDownListeners.forEach((l) => l());
      const target = this.hovered;
      if (target?.onPress) target.onPress.call(target);
      this.pressed = target;
      this.emptyPress = target ? null : { ...Clip.mouse };
    });
    window.addEventListener('pointerup', (e) => {
      this.setMouse(e);
      this.mouseUpListeners.forEach((l) => l());
      const empty = this.emptyPress;
      this.emptyPress = null;
      if (empty && Math.hypot(Clip.mouse.x - empty.x, Clip.mouse.y - empty.y) < 12) {
        this.updateHover();
        if (!this.hovered) this.emptyClickListeners.forEach((l) => l());
        if (e.pointerType !== 'mouse') this.clearHover();
      }
      const pressed = this.pressed;
      this.pressed = null;
      if (!pressed) return;
      this.updateHover();
      if (this.hovered === pressed) pressed.onRelease?.call(pressed);
      else pressed.onReleaseOutside?.call(pressed);
      if (e.pointerType !== 'mouse') this.clearHover();
    });
    c.addEventListener('pointerleave', (e) => {
      if (e.pointerType === 'mouse') this.clearHover();
    });
    window.addEventListener('keydown', (e) => {
      if (isTyping(e)) return;
      if (e.key === 'f' || e.key === 'F') this.toggleFullscreen();
    });
  }

  /** Rectangle écran (pixels CSS) d'une zone de la scène : pour poser des éléments HTML sur le canvas. */
  stageToClient(x: number, y: number, w: number, h: number): { left: number; top: number; width: number; height: number; scale: number } {
    return {
      left: this.offsetX + x * this.scale,
      top: this.offsetY + y * this.scale,
      width: w * this.scale,
      height: h * this.scale,
      scale: this.scale,
    };
  }

  private setMouse(e: PointerEvent): void {
    Clip.mouse.x = (e.clientX - this.offsetX) / this.scale;
    Clip.mouse.y = (e.clientY - this.offsetY) / this.scale;
  }

  private updateHover(): void {
    const target = this.findButton();
    if (target === this.hovered) return;
    const previous = this.hovered;
    this.hovered = target;
    previous?.onRollOut?.call(previous);
    target?.onRollOver?.call(target);
    this.canvas.style.cursor = target?.useHandCursor ? 'pointer' : '';
  }

  private clearHover(): void {
    const previous = this.hovered;
    this.hovered = null;
    previous?.onRollOut?.call(previous);
    this.canvas.style.cursor = '';
  }

  /** Bouton le plus haut sous la souris. Comme en AS2, un parent bouton capte les événements de ses enfants. */
  private findButton(): Clip | null {
    const { x, y } = Clip.mouse;
    const visit = (clip: Clip): Clip | null => {
      if (!clip.visible || clip.isMask) return null;
      if (clip.isButton && clip.enabled) return clip.hitTestPoint(this.hitCtx, x, y) ? clip : null;
      const kids = clip.children;
      for (let i = kids.length - 1; i >= 0; i--) {
        const hit = visit(kids[i]);
        if (hit) return hit;
      }
      return null;
    };
    return visit(this.root);
  }

  private isAttached(clip: Clip): boolean {
    let c: Clip | null = clip;
    while (c && c !== this.root) c = c.parent;
    return c === this.root;
  }
}

/** Vrai si la touche est tapée dans un champ de saisie (les raccourcis clavier l'ignorent alors). */
export function isTyping(e: KeyboardEvent): boolean {
  const t = e.target;
  return t instanceof HTMLInputElement || t instanceof HTMLTextAreaElement;
}
