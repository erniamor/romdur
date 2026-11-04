import type { SoundBank } from '../audio/sound';
import { Clip } from '../flash/clip';

/**
 * Bouton « retour » (sprite 182) : flèche dans un carré blanc translucide.
 * C'est le seul moyen de sortir d'une section : chaque scène y branche son `onRelease`.
 */
export class BtRetour extends Clip {
  constructor(private readonly sounds: SoundBank) {
    super('bt_retour');
    const g = this.graphics;
    g.lineStyle(1, 0x333333, 100);
    g.beginFill(0xffffff, 50);
    g.moveTo(11.4, 7.7);
    g.lineTo(-11.45, 7.7);
    g.lineTo(-11.45, -7.65);
    g.lineTo(11.4, -7.65);
    g.lineTo(11.4, 7.7);
    g.endFill();
    g.lineStyle(3.25, 0x333333, 100);
    g.moveTo(8.35, -0.1);
    g.lineTo(-8.1, -0.2);
    g.moveTo(-3.4, 4.65);
    g.lineTo(-8.25, -0.2);
    g.lineTo(-3.4, -5.25);

    this.hitArea = { x: -11.45, y: -7.65, w: 22.85, h: 15.35 };
    this.onRollOver = () => {
      const s = this.sounds.get('snd_glob_retour');
      s.stop();
      s.start();
      this.xscale = this.yscale = 120;
    };
    this.onRollOut = () => {
      this.xscale = this.yscale = 100;
    };
  }
}
