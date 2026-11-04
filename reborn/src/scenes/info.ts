import { random } from '../engine/easing';
import { createPtsArray, getCercle3dPoints } from '../engine/shapes3d';
import { Particle3d, Repere3d, type Vector3d } from '../engine/space3d';
import type { Clip } from '../flash/clip';
import type { Runtime } from '../runtime';
import { InfoCube } from '../symbols/infoCube';

/** Libellés des cubes (`_global.data_info_nom`). */
const DATA_INFO_NOM = ['I', 'II', 'III', 'IV', 'V'];

const Z_72 = { z: -72 };

/**
 * Section IV « info » (sprite 126) : cinq cubes en pentagone autour d'un cercle.
 * Indices du repère : cubes 0–4, cercle 5–22.
 *
 * Retiré : la fiche affichée au centre quand on choisit un cube (`info_mc`, réduite au mot
 * « romdur ») et son masque circulaire ; les temps d'animation sont conservés.
 * Sans effet dans l'original, donc absents ici : `colorCercleInfo` (jamais défini) et le fondu
 * du cercle à la sortie (`_level0.setApiLocal` n'existe pas).
 */
export class Info {
  readonly info: Clip;
  readonly univers = new Repere3d(500);
  private readonly cubes: InfoCube[] = [];
  /** saveRepere(univers, "saveInfoRepere"). */
  private save: Vector3d[] = [];

  constructor(
    private readonly rt: Runtime,
    private readonly onExit: () => void,
  ) {
    this.info = rt.level10.createEmptyMovieClip('info', 14);
    this.info.x = 490;
    this.info.y = 365;
    this.build();
    this.introInfo();
  }

  private get tween() {
    return this.rt.tween;
  }

  /** DoAction_3 : cubes à (-200, 0, 0) tournés de 72° chacun, puis le cercle. */
  private build(): void {
    const { info, univers: u, rt } = this;
    for (let i = 0; i <= 4; i++) {
      const p = new Particle3d(-200, 0, 0, info, () => new InfoCube(rt, i), 'info_cube', i);
      u.array.push(p);
      u.rotateObjectZ(i, i + 7, 72 * i);
      p.mc.nom.text = DATA_INFO_NOM[i];
      this.cubes.push(p.mc);
    }
    getCercle3dPoints(info, u, 0, 0, 0, 100, 100, { taille: 2, couleur: 0x496172, alpha: 0 });
    const cercle = info.createEmptyMovieClip('cercle', 66666);
    rt.api.createApi(cercle, u, createPtsArray(5, 17), 'cercle', 0, 'cercle', true, 'global');
    this.save = u.savePositions();
  }

  private amb(n: number) {
    return this.rt.sounds.get(`snd_info_amb_${n}`);
  }

  /** Points du cercle : vers leur position de référence multipliée par k (ou vers le centre si k = 0). */
  private cercleVers(k: number, duree: number, ease: 'easeOutCubic' | 'easeInCubic', inclusive = false): void {
    const u = this.univers;
    const end = inclusive ? u.array.length : u.array.length - 1;
    for (let i = 5; i <= end; i++) {
      const s = this.save[i];
      this.tween.rMouvement(this, u, i, undefined, [s ? s.x * k : 0, s ? s.y * k : 0, undefined], 0, duree, ease);
    }
  }

  private introInfo(): void {
    const { tween } = this;
    const u = this.univers;
    for (let n = 1; n <= 5; n++) {
      const amb = this.amb(n);
      amb.setVolume(0);
      amb.start(0, 99999999);
      tween.soundVolume(amb, 0, 50, 0, 60, 'easeInOutSine');
    }
    // Le cercle arrive de loin (×7) avec un rebond.
    for (let i = 5; i < u.array.length; i++) {
      const s = this.save[i];
      u.array[i].position.reset(s.x * 7, s.y * 7, s.z);
      u.array[i].render(500);
      tween.rMouvement(this, u, i, undefined, [s.x, s.y, undefined], 0, 40, 'easeOutBack');
    }
    // Les cubes arrivent un à un depuis la gauche…
    for (let i = 0; i <= 4; i++) {
      u.array[i].position.reset(-700, 0, 0);
      u.array[i].render(500);
      tween.rMouvement(this, u, i, [-700, undefined, undefined], [-200, undefined, undefined], i * 12 + 10, 10, 'easeOutCubic');
    }
    // …et ceux déjà arrivés tournent d'un cran (-72°) à chaque arrivée.
    const tourne = (...ids: number[]) => {
      for (const id of ids) tween.rRotation(this, u, id, { z: 0 }, Z_72, 0, 10, 'easeOutCubic');
    };
    tween.retardateur(this, 22, 12, () => tourne(0), () => tourne(0, 1));
    tween.retardateur(this, 34, 12, () => tourne(0, 1), () => tourne(0, 1, 2));
    tween.retardateur(this, 58, 20, () => tourne(0, 1, 2, 3), () => {
      this.rt.btRetour.onRelease = () => this.sortieInfoVizu();
      this.soundAmbient();
      this.activeAllInfoBtInit();
      this.infoEnterFrameInit();
    });
  }

  /** Ambiance (sprite 199, soundAmbient_info) : une nappe par cube, volume selon z, panoramique selon x. */
  private soundAmbient(): void {
    this.rt.sample.onEnterFrame = () => {
      for (let i = 0; i <= 4; i++) {
        const pos = this.univers.array[i].position;
        const amb = this.amb(i + 1);
        amb.setVolume(Math.round((-pos.z / 2 + 100) / 2));
        amb.setPan(pos.x / 2);
      }
    };
  }

  private infoEnterFrameInit(): void {
    const { info, univers: u } = this;
    info.onEnterFrame = () => u.rotateXY(info.ymouse / 50, info.xmouse / 50);
  }

  private infoEnterFrame(): void {
    const { info, univers: u } = this;
    info.onEnterFrame = () => {
      u.rotateObjectZ(0, 4, -info.xmouse / 150);
      u.rotateObjectZ(5, 22, -info.ymouse / 150);
    };
  }

  private bindCubes(onPress: (cube: InfoCube) => void): void {
    for (const cube of this.cubes) {
      cube.onRollOver = () => cube.changeEtatCubeInfo();
      cube.onRollOut = () => cube.changeEtatCubeInfo();
      cube.onPress = () => onPress(cube);
    }
  }

  private activeAllInfoBtInit(): void {
    this.bindCubes((cube) => {
      delete this.info.onEnterFrame;
      this.selectInfoCube(cube.id);
    });
  }

  private activeAllInfoAutreBt(): void {
    this.bindCubes((cube) => this.selectInfoAutreCube(cube.id));
  }

  private deactiveAllInfoBt(): void {
    for (const cube of this.cubes) {
      delete cube.onRollOver;
      delete cube.onRollOut;
      delete cube.onPress;
    }
    delete this.rt.btRetour.onRelease;
  }

  /** Choix d'un cube : retour à la pose de référence, les cubes s'écartent, le cercle s'agrandit. */
  private selectInfoCube(_id: number): void {
    const { tween } = this;
    const u = this.univers;
    this.deactiveAllInfoBt();
    for (let l = 0; l < u.array.length; l++) {
      const s = this.save[l];
      tween.rMouvement(this, u, l, undefined, [s.x, s.y, s.z], 0, 15, 'easeInOutCubic');
    }
    tween.retardateur(
      this, 15, 6,
      () => {
        for (let i = 0; i <= u.array.length; i++) {
          const s = this.save[i];
          if (i <= 4) tween.rMouvement(this, u, i, undefined, [s.x * 1.5, s.y * 1.5, undefined], 0, 20, 'easeInOutBack');
          else tween.rMouvement(this, u, i, undefined, [0, 0, undefined], 0, 5, 'easeInCubic');
        }
      },
      () => this.cercleVers(2.1, 10, 'easeOutCubic'),
    );
    tween.retardateur(this, 26, 2, () => {
      this.rt.btRetour.onRelease = () => this.retourMenuInfo();
      this.activeAllInfoAutreBt();
      this.infoEnterFrame();
    });
  }

  /** Passage à un autre cube : les cubes font un demi-tour (en X ou en Y), le cercle se replie puis se rouvre. */
  private selectInfoAutreCube(_id: number): void {
    const { tween } = this;
    const u = this.univers;
    delete this.info.onEnterFrame;
    this.deactiveAllInfoBt();
    const boolxy = random(2);
    const endRot = random(2) !== 0 ? -180 : 180;
    for (let m = 0; m <= u.array.length; m++) {
      if (m <= 4) {
        if (boolxy === 0) tween.rRotation(this, u, m, { x: 0 }, { x: endRot }, 0, 20, 'easeInOutSine');
        else tween.rRotation(this, u, m, { x: 0, y: 0 }, { y: endRot }, 0, 20, 'easeInOutSine');
      } else {
        tween.rMouvement(this, u, m, undefined, [0, 0, undefined], 0, 10, 'easeInCubic');
      }
    }
    tween.retardateur(
      this, 11, 10,
      () => this.cercleVers(2.1, 10, 'easeOutCubic'),
      () => {
        // L'original appelle retourMenuInfo()() : la fonction s'exécute, puis l'appel du résultat échoue sans effet.
        this.rt.btRetour.onRelease = () => this.retourMenuInfo();
        this.infoEnterFrame();
        this.activeAllInfoAutreBt();
      },
    );
  }

  /** Retour à l'anneau de cubes. */
  private retourMenuInfo(): void {
    const { tween } = this;
    const u = this.univers;
    delete this.info.onEnterFrame;
    this.deactiveAllInfoBt();
    this.cercleVers(0, 10, 'easeInCubic', true);
    tween.retardateur(
      this, 11, 10,
      () => {
        for (let i = 0; i < u.array.length; i++) {
          const s = this.save[i];
          tween.rMouvement(this, u, i, undefined, [s.x, s.y, undefined], 0, 10, 'easeOutCubic');
        }
      },
      () => {
        this.rt.btRetour.onRelease = () => this.sortieInfoVizu();
        this.infoEnterFrameInit();
        this.activeAllInfoBtInit();
      },
    );
  }

  /** Sortie vers le menu : les cubes filent sur les côtés, le cercle se replie puis explose. */
  private sortieInfoVizu(): void {
    const { tween, rt } = this;
    const u = this.univers;
    delete rt.sample.onEnterFrame;
    for (let n = 1; n <= 5; n++) tween.soundVolume(this.amb(n), undefined, 0, 0, 30, 'easeInOutSine');
    delete this.info.onEnterFrame;
    this.deactiveAllInfoBt();
    for (let i = 0; i <= 4; i++) {
      const fuite = u.array[i].position.x < 0 ? -800 : 800;
      tween.rMouvement(this, u, i, undefined, [fuite, undefined, undefined], i * 3, 12, 'easeInCubic');
    }
    this.cercleVers(0, 10, 'easeInCubic');
    tween.retardateur(
      this, 14, 21,
      () => this.cercleVers(10, 20, 'easeOutCubic'),
      () => {
        rt.api.removeAllOn();
        for (let n = 1; n <= 5; n++) this.amb(n).stop();
        this.info.removeMovieClip();
        this.onExit();
      },
    );
  }
}
