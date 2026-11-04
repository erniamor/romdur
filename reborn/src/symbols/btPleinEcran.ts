import type { SoundBank } from '../audio/sound';
import { Clip } from '../flash/clip';

/**
 * Bouton plein écran, à la place de l'ancien « quitter » (sprite 179) : même carré blanc translucide,
 * même bordure, même opacité (80 %), même grossissement et même son au survol.
 * Masqué si le navigateur ne permet pas le plein écran (iPhone notamment).
 */
export class BtPleinEcran extends Clip {
  private readonly icon: Clip;

  constructor(
    private readonly sounds: SoundBank,
    private readonly toggle: () => void,
  ) {
    super('bt_pleinEcran');
    this.alpha = 80;

    const g = this.graphics;
    g.lineStyle(1, 0x333333, 100);
    g.beginFill(0xffffff, 50);
    g.moveTo(9.55, 8.4);
    g.lineTo(-7.2, 8.4);
    g.lineTo(-7.2, -6.95);
    g.lineTo(9.55, -6.95);
    g.lineTo(9.55, 8.4);
    g.endFill();

    this.icon = this.createEmptyMovieClip('icone', 1);
    this.icon.x = 1.175;
    this.icon.y = 0.725;
    this.drawIcon();

    this.hitArea = { x: -7.2, y: -6.95, w: 16.75, h: 15.35 };
    this.visible = document.fullscreenEnabled;

    this.onRollOver = () => {
      const fin = this.sounds.get('snd_glob_fin');
      fin.stop();
      fin.start();
      this.xscale = this.yscale = 120;
    };
    this.onRollOut = () => {
      this.xscale = this.yscale = 100;
    };
    this.onRelease = () => this.toggle();
    document.addEventListener('fullscreenchange', () => this.drawIcon());
  }

  /** Quatre coins tournés vers l'extérieur (entrer) ou vers l'intérieur (sortir). */
  private drawIcon(): void {
    const g = this.icon.graphics;
    const out = !document.fullscreenElement;
    const r = 4.6;
    const l = 2.6;
    g.clear();
    g.lineStyle(1.75, 0x333333, 100);
    for (const [sx, sy] of [[-1, -1], [1, -1], [1, 1], [-1, 1]]) {
      const cx = sx * r;
      const cy = sy * r;
      const d = out ? -l : l;
      g.moveTo(cx + sx * d, cy);
      g.lineTo(cx, cy);
      g.lineTo(cx, cy + sy * d);
    }
  }
}
