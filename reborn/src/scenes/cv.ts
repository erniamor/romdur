import { random } from '../engine/easing';
import { createPtsArray, getCube3dPoints } from '../engine/shapes3d';
import { Repere3d } from '../engine/space3d';
import type { Clip } from '../flash/clip';
import type { Runtime } from '../runtime';

const ROT_0 = { x: 0, y: 0, z: 0 };

/**
 * Section I « cv » (sprite 80) : trois plaques (cubes aplatis) qui arrivent de la gauche,
 * se déplient, pivotent, puis tournent selon la souris. Indices : plaque k = points 8k à 8k+7.
 *
 * Retirés : les trois panneaux de contenu étirés sur les plaques (`cv_qui`, `cv_competence`,
 * `cv_qualification`), qui ne contenaient plus que le mot « romdur ».
 */
export class Cv {
  readonly cv: Clip;
  readonly univers = new Repere3d(500);
  private readonly cubes: Clip[] = [];

  constructor(
    private readonly rt: Runtime,
    private readonly onExit: () => void,
  ) {
    this.cv = rt.level10.createEmptyMovieClip('cv', 11);
    this.cv.x = 490;
    this.cv.y = 365;
    // Trois plaques superposées de 150 × 10 × 10, hors champ à gauche ; points invisibles.
    for (let i = 0; i <= 2; i++) {
      getCube3dPoints(this.cv, this.univers, -1000, 0, 150, 150, 10, 10, { taille: 0, couleur: 0x000000, alpha: 0 });
      const mc = this.cv.createEmptyMovieClip(`cube${i}`, 10000 + i);
      rt.api.createApi(mc, this.univers, createPtsArray(i * 8, 8), `cube${i}`, 0, 'cube', true, 'global');
      this.cubes.push(mc);
    }
    this.introCv();
  }

  private snd(name: string) {
    return this.rt.sounds.get(name);
  }

  private move(id: number, dest: [number | undefined, number | undefined, number | undefined], duree: number,
    ease: 'easeOutSine' | 'easeInSine' | 'easeOutExpo'): void {
    this.rt.tween.rMouvement(this, this.univers, id, undefined, dest, 0, duree, ease);
  }

  private introCv(): void {
    const { tween } = this.rt;
    const u = this.univers;
    for (let i = 0; i < u.array.length; i++) this.move(i, [u.array[i].position.x + 1000, undefined, undefined], 30, 'easeInSine');
    tween.retardateur(
      this, 31, 38,
      () => {
        this.snd('snd_cv_transition').start();
        this.etireCvCubeY(0);
        this.etireCvCubeY(8);
        this.etireCvCubeY(16);
      },
      () => {
        this.snd('snd_cv_transition').start();
        for (let i = 0; i < u.array.length; i++) tween.rRotation(this, u, i, ROT_0, { y: 180 }, 0, 20, 'easeOutSine');
      },
    );
    tween.retardateur(
      this, 53, 60,
      () => {
        this.snd('snd_cv_transition').start();
        for (let i = 8; i <= 15; i++) tween.rRotation(this, u, i, ROT_0, { x: 120 }, 0, 10, 'easeOutSine');
        for (let i = 16; i <= 23; i++) tween.rRotation(this, u, i, ROT_0, { x: -120 }, 0, 10, 'easeOutSine');
      },
      () => {
        this.startCvEnterFrame();
        this.snd('snd_cv_rot_1').start(0, 9999999);
        this.snd('snd_cv_rot_2').start(0, 9999999);
        this.soundAmbient();
        this.activeCvBt();
      },
    );
  }

  private startCvEnterFrame(): void {
    this.cv.onEnterFrame = () => this.univers.rotateX(this.cv.ymouse / 60);
  }

  /**
   * Ambiance (sprite 199, soundAmbient_cv) : souris au-dessus de y = 229 (repère du clip sample),
   * la seconde nappe monte ; en dessous, la première.
   */
  private soundAmbient(): void {
    const sample = this.rt.sample;
    sample.onEnterFrame = () => {
      const v = sample.ymouse / 2;
      this.snd('snd_cv_rot_2').setVolume(v < 0 ? Math.abs(v) : 0);
      this.snd('snd_cv_rot_1').setVolume(v < 0 ? 0 : v);
    };
  }

  /** La plaque s'étire en hauteur : ±100 en Y. */
  private etireCvCubeY(i: number): void {
    for (const k of [0, 1, 4, 5]) this.move(i + k, [undefined, 100, undefined], 10, 'easeOutSine');
    for (const k of [2, 3, 6, 7]) this.move(i + k, [undefined, -100, undefined], 10, 'easeOutSine');
  }

  /** Au survol, la plaque s'élargit (±250 en X) ; elle revient à ±75 quand la souris la quitte. */
  private largeurCvCube(i: number, demi: number): void {
    for (const k of [0, 3, 4, 7]) this.move(i + k, [-demi, undefined, undefined], 30, 'easeOutExpo');
    for (const k of [1, 2, 5, 6]) this.move(i + k, [demi, undefined, undefined], 30, 'easeOutExpo');
  }

  private activeCvBt(): void {
    const { api } = this.rt;
    this.cubes.forEach((mc, k) => {
      mc.onRollOver = () => {
        this.snd(`snd_cv_over_${k + 1}`).start();
        const obj = api.apiOn.get(`cube${k}`);
        if (obj) obj.styleId = 1;
        this.largeurCvCube(8 * k, 250);
      };
      mc.onRollOut = () => {
        const obj = api.apiOn.get(`cube${k}`);
        if (obj) obj.styleId = 0;
        this.snd(`snd_cv_out_${k + 1}`).start();
        this.largeurCvCube(8 * k, 75);
      };
    });
    this.rt.btRetour.onRelease = () => this.cvSortie();
  }

  private deactiveCvBt(): void {
    for (const mc of this.cubes) {
      delete mc.onRollOver;
      delete mc.onRollOut;
      delete mc.onPress;
    }
    delete this.rt.btRetour.onRelease;
  }

  /**
   * Sortie : les plaques se replient sur l'axe, puis chacune file vers le haut ou le bas.
   * Comme dans l'original, les survols restent actifs jusqu'à la fin de la sortie.
   */
  private cvSortie(): void {
    const { tween, api, sample } = this.rt;
    const u = this.univers;
    delete this.rt.btRetour.onRelease;
    delete this.cv.onEnterFrame;
    this.snd('snd_cv_transition').start();
    for (let i = 0; i < u.array.length; i++) this.move(i, [0, undefined, undefined], 10, 'easeOutSine');
    tween.retardateur(
      this, 23, 33,
      () => {
        this.snd('snd_cv_transition').start();
        for (let k = 0; k <= 2; k++) {
          const y = random(2) !== 0 ? 500 : -500;
          for (let i = 8 * k; i <= 8 * k + 7; i++) this.move(i, [undefined, y, undefined], 20, 'easeOutExpo');
        }
      },
      () => {
        api.removeAllOn();
        delete sample.onEnterFrame;
        this.snd('snd_cv_rot_1').stop();
        this.snd('snd_cv_rot_2').stop();
        this.deactiveCvBt();
        this.onExit();
        this.cv.removeMovieClip();
      },
    );
  }
}
