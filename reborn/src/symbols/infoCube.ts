import { createPtsArray, getCube3dPoints } from '../engine/shapes3d';
import { Repere3d } from '../engine/space3d';
import { Clip, timelineDepth } from '../flash/clip';
import { editText, type TextField } from '../flash/text';
import type { Runtime } from '../runtime';

/**
 * Symbole « info_cube » (sprite 130) : cube filaire de 50 px avec son numéro.
 * Il tourne selon la position de la souris par rapport à lui ; au survol il change de style
 * et coupe sa nappe sonore, qui repart quand la souris le quitte.
 */
export class InfoCube extends Clip {
  etat: 'blanc' | 'noir' = 'blanc';
  readonly nom: TextField;
  private readonly univers = new Repere3d(500);

  constructor(
    private readonly rt: Runtime,
    readonly id: number,
  ) {
    super('info_cube');
    // info_nom (sprite 129) : numéro en 8 px, centré.
    const infoNom = this.createEmptyMovieClip('info_nom', timelineDepth(1));
    this.nom = infoNom.addChildAt(
      editText('txt', { size: 8, color: 0x333333, align: 'center' }, [-21.7, -5.05], [-2, -2, 45.4, 12.05]), 1);

    // Points invisibles (taille 0, alpha 0) : seul le dessin du cube se voit.
    getCube3dPoints(this, this.univers, 0, 0, 0, 50, 50, 50, { taille: 0, couleur: 0x000000, alpha: 0 });
    const mc = this.createEmptyMovieClip(`cube${id}`, 10000);
    rt.api.createApi(mc, this.univers, createPtsArray(0, 8), `cube${id}`, 1, 'cube', true, 'global');

    this.onEnterFrame = () => this.univers.rotateXY(this.ymouse / 50, -this.xmouse / 50);
  }

  changeEtatCubeInfo(): void {
    const amb = this.rt.sounds.get(`snd_info_amb_${this.id + 1}`);
    const obj = this.rt.api.apiOn.get(`cube${this.id}`);
    if (this.etat === 'blanc') {
      amb.stop();
      if (obj) obj.styleId = 0;
      this.etat = 'noir';
    } else {
      amb.start(0, 9999999999999);
      if (obj) obj.styleId = 1;
      this.etat = 'blanc';
    }
  }
}
