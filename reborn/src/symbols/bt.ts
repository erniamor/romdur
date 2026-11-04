import { Clip } from '../flash/clip';
import { TextField } from '../flash/text';

/**
 * Symbole « BT » (sprite 10) : bouton du menu d'accueil.
 * Cadre 71×14, libellé centré, et un reflet en dégradé masqué qui balaie le bouton au survol.
 */
export class BT extends Clip {
  id = 0;
  readonly degrade: Clip;
  readonly txt: TextField;

  constructor() {
    super('BT');
    const mask = this.createEmptyMovieClip('mask', 1);
    mask.y = -8;
    mask.graphics.beginFill(0xffffff, 20);
    mask.graphics.moveTo(71, 0);
    mask.graphics.lineTo(71, 14);
    mask.graphics.lineTo(0, 14);
    mask.graphics.lineTo(0, 0);
    mask.graphics.lineTo(71, 0);
    mask.graphics.endFill();

    this.degrade = this.createEmptyMovieClip('degrade', 3);
    this.degrade.x = -89.55;
    this.degrade.y = -16.6;
    const g = this.degrade.graphics;
    g.beginGradientFill('linear', [0xbcbcbc, 0xcecece, 0xbcbcbc], [0, 80, 0], [60, 120, 148], {
      matrixType: 'matrix', a: 0.03986, b: 0.03326, c: -0.01195, d: 0.01433, tx: 42.6, ty: 15.35,
    });
    g.moveTo(0, 30.65);
    g.lineTo(0, 0.05);
    g.lineTo(85.2, 0);
    g.lineTo(85.25, 30.6);
    g.lineTo(0, 30.65);
    g.endFill();
    this.degrade.setMask(mask);

    const frame = this.createEmptyMovieClip('cadre', 5);
    frame.graphics.lineStyle(1, 0x607377, 100);
    frame.graphics.moveTo(71, -8);
    frame.graphics.lineTo(71, 6);
    frame.graphics.lineTo(0, 6);
    frame.graphics.lineTo(0, -8);
    frame.graphics.lineTo(71, -8);

    this.txt = this.addChildAt(new TextField('BT_txt', { size: 12, color: 0x37425e, align: 'center', width: 70 }), 6);
    this.txt.y = -11;

    // Le cadre n'est qu'un trait : on rend toute sa surface cliquable (plus confortable, surtout au doigt).
    this.hitArea = { x: 0, y: -8, w: 71, h: 14 };
  }
}
