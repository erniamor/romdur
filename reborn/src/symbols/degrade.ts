import { Clip } from '../flash/clip';
import type { FlashColor } from '../flash/color';

/** Couleurs d'origine du dégradé de fond (`_global.colorDegrade`) : centre, bord. */
export const DEFAULT_DEGRADE: [FlashColor, FlashColor] = [0xcccccc, 0xafafaf];

/** Marge peinte au-delà de la scène 980×730, pour couvrir tout l'écran en plein écran. */
const BLEED = 4000;

/**
 * Fond : dégradé radial de 500 px de diamètre centré sur la scène (sprites 10 et 172).
 * L'original ne peignait que 980×730 ; ici la couleur du bord s'étend à tout l'écran.
 */
export class Degrade extends Clip {
  colors: [FlashColor, FlashColor] = [...DEFAULT_DEGRADE];

  constructor(name = 'degrade') {
    super(name);
    this.update();
  }

  update(): void {
    const g = this.graphics;
    g.clear();
    g.lineStyle(1, 0x000000, 0);
    g.beginGradientFill('radial', this.colors, [100, 100], [0, 255], {
      matrixType: 'box', x: -250, y: -250, w: 500, h: 500, r: 1,
    });
    g.moveTo(-490 - BLEED, -365 - BLEED);
    g.lineTo(490 + BLEED, -365 - BLEED);
    g.lineTo(490 + BLEED, 365 + BLEED);
    g.lineTo(-490 - BLEED, 365 + BLEED);
    g.lineTo(-490 - BLEED, -365 - BLEED);
    g.endFill();
  }
}
