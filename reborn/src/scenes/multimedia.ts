import type { ApiType } from '../engine/api';
import type { EasingName } from '../engine/easing';
import { createPtsArray, getCube3dPoints } from '../engine/shapes3d';
import { Point3d, Repere3d, type Vec3, type Vector3d } from '../engine/space3d';
import { Clip } from '../flash/clip';
import { TextField } from '../flash/text';
import type { Runtime } from '../runtime';

type Axes = [number | undefined, number | undefined, number | undefined];
type Rot = { x?: number; y?: number; z?: number };
type Cb = () => void;

/** Taille naturelle du symbole bt_multi (cadre invisible 137 × 25), base de _width/_height. */
const FACE_W = 138;
const FACE_H = 26;

/**
 * Chiffre plaqué sur une face (clips BT_0…BT_3 + symbole bt_multi, sprite 16) : recalé à chaque
 * image sur les points id, id+1 (largeur) et id+3 (hauteur), visible une fois `valid`.
 */
class TextFace extends Clip {
  valid = false;
  readonly mc: Clip;

  constructor(name: string, texte: string, private readonly repere: Repere3d, public id: number) {
    super(name);
    this.mc = this.createEmptyMovieClip('mc', 1);
    const txt = this.mc.addChildAt(
      new TextField('txt', { text: texte, size: 14, color: 0x23293d, align: 'center', width: 78, bold: true }), 2);
    txt.x = 30;
    txt.y = 4;
    this.visible = false;
    this.onEnterFrame = () => {
      if (!this.valid) {
        this.visible = false;
        return;
      }
      this.visible = true;
      const a = this.repere.array;
      const p = a[this.id], p1 = a[this.id + 1], p3 = a[this.id + 3];
      if (!p || !p1 || !p3) return;
      this.mc.x = p.screenPos.x;
      this.mc.y = p.position.z >= 0 ? -p3.screenPos.y : -p.screenPos.y;
      this.mc.xscale = (Math.abs(p1.screenPos.x - p.screenPos.x) / FACE_W) * 100;
      this.mc.yscale = (Math.abs(p3.screenPos.y - p.screenPos.y) / FACE_H) * 100;
    };
  }
}

/** Coins d'une plaque autour de (0, 0, 0) : setPosPointCube. */
const COINS: Vec3[] = [
  { x: -50, y: 5, z: 110 }, { x: 50, y: 5, z: 110 }, { x: 50, y: -5, z: 110 }, { x: -50, y: -5, z: 110 },
  { x: -50, y: 5, z: -110 }, { x: 50, y: 5, z: -110 }, { x: 50, y: -5, z: -110 }, { x: -50, y: -5, z: -110 },
];

/**
 * Section II « multimédia » (sprite 12) : quatre plaques couchées (I à IV) sur une ligne tendue
 * entre deux points. I ouvre la partie audio (la plaque éclate en six faces), III la partie flash
 * (les plaques se replient), IV la partie web (la plaque se dédouble en deux volets) ; II ne fait
 * rien au clic, comme dans l'original.
 *
 * Indices : plaque k = points 8k à 8k+7 ; extrémités de la ligne 32 et 33 ; points ajoutés
 * temporairement à partir de 34 (faces audio, volets web).
 *
 * Retirés : les panneaux de contenu (listes, lecteur et indicateur audio, fiches web), et le
 * dialogue `flash_quest_mc`. Le panneau flash n'apparaissait déjà pas : l'original attache
 * « mc_flash » alors que le symbole s'appelle « mc_flash_bis ».
 */
export class Multimedia {
  readonly mm: Clip;
  readonly univers = new Repere3d(500);
  private readonly cubes: Clip[] = [];
  private readonly faces: TextFace[] = [];
  /** saveRepere(univers, "multi_accueil"). */
  private acc: Vector3d[] = [];
  /** Variables du scénario `multimedia` (t, rot). */
  private t = 0;
  private rot = 0;

  constructor(
    private readonly rt: Runtime,
    private readonly onExit: () => void,
  ) {
    this.mm = rt.level10.createEmptyMovieClip('multimedia', 12);
    this.mm.x = 490;
    this.mm.y = 365;
    this.build();
    this.introMultimedia();
  }

  // ———————————————————————————— outils

  private get tween() {
    return this.rt.tween;
  }

  private get api() {
    return this.rt.api;
  }

  private snd(name: string) {
    return this.rt.sounds.get(name);
  }

  private pos(i: number): Vector3d {
    return this.univers.array[i].position;
  }

  private move(id: number, dest: Axes, delai: number, duree: number, ease: EasingName,
    onStart?: Cb, onStop?: Cb, dep?: Axes): void {
    this.tween.rMouvement(this, this.univers, id, dep, dest, delai, duree, ease, onStart, onStop);
  }

  private rotate(id: number, dest: Rot, delai: number, duree: number, ease: EasingName,
    onStart?: Cb, onStop?: Cb, dep?: Rot): void {
    this.tween.rRotation(this, this.univers, id, dep, dest, delai, duree, ease, onStart, onStop);
  }

  private rotateRel(id: number, pivot: number | Vec3, dest: Rot, delai: number, duree: number, ease: EasingName,
    onStart?: Cb, onStop?: Cb, dep?: Rot): void {
    this.tween.rRotationRelative(this, this.univers, id, pivot, dep, dest, delai, duree, ease, onStart, onStop);
  }

  private timer(delai: number, duree: number, onStart?: Cb, onStop?: Cb): void {
    this.tween.retardateur(this, delai, duree, onStart, onStop);
  }

  /** `rotation.x %= 360` (l'original normalise avant de viser une rotation absolue). */
  private normRot(i: number, axis: 'x' | 'y' = 'x'): void {
    const r = this.univers.array[i].rotation;
    r[axis] %= 360;
  }

  private createApi(nom: string, depth: number, pts: number[], styleId: number, type: ApiType, etat: boolean): Clip {
    const mc = this.mm.createEmptyMovieClip(nom, depth);
    this.api.createApi(mc, this.univers, pts, nom, styleId, type, etat, 'global');
    return mc;
  }

  private ambiances(): string[] {
    return ['snd_multi_amb_1', 'snd_multi_amb_2', 'snd_multi_amb_3', 'snd_multi_amb_4'];
  }

  /** Les quatre nappes descendent à 0 puis s'arrêtent. */
  private coupeAmbiances(duree: number): void {
    const names = this.ambiances();
    names.forEach((n, i) => {
      const last = i === names.length - 1;
      this.tween.soundVolume(this.snd(n), undefined, 0, 0, duree, 'easeInOutSine', undefined,
        last ? () => names.forEach((m) => this.snd(m).stop()) : undefined);
    });
  }

  /** Les quatre nappes repartent et montent à 100, puis l'ambiance suit à nouveau les plaques. */
  private relanceAmbiances(duree: number, ease: EasingName, loops = 99999999): void {
    const names = this.ambiances();
    names.forEach((n, i) => {
      this.snd(n).start(0, loops);
      this.tween.soundVolume(this.snd(n), undefined, 100, 0, duree, ease, undefined,
        i === names.length - 1 ? () => this.soundAmbientMulti() : undefined);
    });
  }

  // ———————————————————————————— construction et accueil

  /** DoAction_6 et DoAction_7. */
  private build(): void {
    const { mm, univers: u } = this;
    const pt = { taille: 1, couleur: 0x000000, alpha: 0 };
    [-159, -53, 53, 159].forEach((x, k) => {
      getCube3dPoints(mm, u, x, 0, -80, 100, 10, 220, pt);
      this.cubes.push(this.createApi(`cube${k}`, 10000 + k, createPtsArray(u.idObjet[k], 8), 0, 'cube', false));
    });
    u.array.push(new Point3d(0, 0, 0, mm, 2, 0x000000, 100, u.array.length));
    u.array.push(new Point3d(0, 0, 0, mm, 2, 0x000000, 100, u.array.length));
    this.createApi('ligne', 20004, [32, 33], 1, 'standardLine', false);
    u.rotateX(-6);
    ['I', 'II', 'III', 'IV'].forEach((txt, k) => {
      this.faces.push(mm.addChildAt(new TextFace(`BT_${k}`, txt, u, 4 + 8 * k), 20005 + k));
    });
    this.acc = u.savePositions();
  }

  private introMultimedia(): void {
    const { api } = this;
    api.activeEtat('ligne');
    const names = this.ambiances();
    names.forEach((n) => this.snd(n).start(0, 900000));
    names.forEach((n, i) => {
      this.tween.soundVolume(this.snd(n), 0, 100, 0, 80, 'easeInOutSine', undefined,
        i === names.length - 1 ? () => this.soundAmbientMulti() : undefined);
    });
    // Style des plaques pendant l'arrivée : celui du style 0, sans remplissage (tableau partagé).
    const s0 = api.style[0];
    const dep = [s0[0], s0[1], s0[2], s0[3], 0] as number[];

    // Les plaques tombent du haut l'une après l'autre (délai 10), légèrement décalées en X.
    let initX = 45;
    let delai = 0;
    let id = 0;
    for (let j = 0; j <= 3; j++) {
      for (let k = 0; k <= 7; k++) {
        const c = COINS[k];
        const init: Axes = [initX + c.x, 800 + c.y, -80 + c.z];
        const end: Axes = [initX + c.x, this.acc[id].y, -80 + c.z];
        // Décalage d'un cran conservé : la plaque II s'allume quand la III commence sa chute,
        // les plaques III et IV quand la IV commence la sienne.
        let onStart: Cb | undefined;
        if (id === 0) {
          api.activeEtat('cube0');
          api.setLocal('cube0', dep);
        } else if (id === 8) onStart = () => (this.faces[1].valid = true);
        else if (id === 16) {
          onStart = () => {
            api.activeEtat('cube1');
            this.faces[2].valid = true;
            api.setLocal('cube1', dep);
          };
        } else if (id === 24) {
          onStart = () => {
            api.activeEtat('cube2');
            api.activeEtat('cube3');
            this.faces[3].valid = true;
            api.setLocal('cube2', dep);
            api.setLocal('cube3', dep);
          };
        }
        this.move(id, end, delai, 60, 'easeOutBack', onStart, undefined, init);
        id++;
      }
      initX -= 30;
      delai += 10;
    }
    // La ligne se tend, puis les plaques se répartissent.
    this.move(32, [300, undefined, undefined], 0, 90, 'easeOutBack');
    this.move(33, [-300, undefined, undefined], 0, 90, 'easeOutBack', undefined, () => this.decaleCubeIntro());
    const patch = this.mm.createEmptyMovieClip('patchCube0', -4);
    patch.onEnterFrame = () => {
      this.t++;
      if (this.t >= 3) {
        this.faces[0].valid = true;
        patch.removeMovieClip();
      }
    };
  }

  private decaleCubeIntro(): void {
    const { api } = this;
    for (let k = 0; k <= 3; k++) {
      const obj = api.apiOn.get(`cube${k}`);
      if (!obj) continue;
      this.tween.arrayValue(`mvtApicube${k}.4`, obj.styleLocal, 4, 0, api.style[0][4] as number, 0, 30, 'linearTween',
        undefined, () => api.setGlobal(`cube${k}`));
    }
    for (let i = 0; i <= 31; i++) this.move(i, [this.acc[i].x, undefined, undefined], 2, 40, 'easeInOutBack');
    this.multimediaEnterFrame();
    this.timer(40, 1, () => this.activeAllBtEvent());
  }

  /** Chaque plaque tourne autour de son axe : selon x hors de la plaque, selon y quand la souris est dessus. */
  private multimediaEnterFrame(): void {
    const { mm, univers: u } = this;
    mm.onEnterFrame = () => {
      const xm = mm.xmouse, ym = mm.ymouse;
      const da = !(xm > -319 && xm < -109) ? (xm + 159) / 200 : ym / 50;
      const db = !(xm > -103 && xm < -3) ? (xm + 53) / 200 : ym / 50;
      const dc = !(xm > 3 && xm < 103) ? (xm - 53) / 200 : ym / 50;
      const dd = !(xm > 109 && xm < 319) ? (xm - 159) / 200 : ym / 50;
      u.rotateObjectX(0, 7, da);
      u.rotateObjectX(8, 15, db);
      u.rotateObjectX(16, 23, dc);
      u.rotateObjectX(24, 31, dd);
    };
  }

  /** Ambiance (sprite 199, soundAmbient_multi) : une nappe par plaque, selon sa profondeur. */
  private soundAmbientMulti(): void {
    this.rt.sample.onEnterFrame = () => {
      const a = this.univers.array;
      this.snd('snd_multi_amb_1').setVolume((-a[4].position.z / 2 + 100) / 2);
      this.snd('snd_multi_amb_2').setVolume((-a[12].position.z / 2 + 100) / 2);
      this.snd('snd_multi_amb_3').setVolume((-a[20].position.z / 2 + 100) / 2);
      this.snd('snd_multi_amb_4').setVolume(-a[28].position.z / 2 + 100);
    };
  }

  private activeAllBtEvent(): void {
    const { api } = this;
    this.rt.btRetour.onRelease = () => this.multimediaSortie();
    this.cubes.forEach((mc, k) => {
      const nom = `cube${k}`;
      // Survol : le fond de la plaque s'opacifie (alpha 80) puis revient au style global en 15 images.
      mc.onRollOver = () => {
        const s = this.snd(`snd_multi_evt_${k + 1}`);
        s.stop();
        s.start();
        const obj = api.apiOn.get(nom);
        if (!obj) return;
        const style = [...api.style[obj.styleId]] as number[];
        api.setLocal(nom, style);
        this.tween.arrayValue(`mvtApi${nom}.4`, style, 4, 80, api.style[obj.styleId][4] as number, 0, 15, 'linearTween',
          undefined, () => api.setGlobal(nom));
      };
    });
    this.cubes[0].onPress = () => {
      delete this.mm.onEnterFrame;
      this.selectAudio();
      this.deleteAllBtEvent();
    };
    this.cubes[2].onPress = () => {
      delete this.mm.onEnterFrame;
      this.selectFlash();
      this.deleteAllBtEvent();
    };
    this.cubes[3].onPress = () => {
      this.selectWeb();
      this.deleteAllBtEvent();
    };
    // Les extrémités de la ligne bourdonnent tant que la souris les survole.
    ([[32, 'snd_multi_evt_point_1'], [33, 'snd_multi_evt_point_2']] as const).forEach(([i, son]) => {
      const point = (this.univers.array[i] as Point3d).point;
      point.onRollOver = () => this.snd(son).start(0, 9999999);
      point.onRollOut = () => this.snd(son).stop();
    });
  }

  private deleteAllBtEvent(): void {
    for (const mc of this.cubes) {
      delete mc.onRollOver;
      delete mc.onRollOut;
      delete mc.onPress;
    }
  }

  private multimediaSortie(): void {
    const { api } = this;
    delete this.rt.sample.onEnterFrame;
    this.coupeAmbiances(70);
    for (const f of this.faces) f.removeMovieClip();
    delete this.rt.btRetour.onRelease;
    const s0 = api.style[0];
    const dep = [s0[0], s0[1], s0[2], s0[3], 0] as number[];
    for (let k = 0; k <= 3; k++) api.setLocal(`cube${k}`, dep);
    // Les plaques se resserrent au centre…
    let id = 0;
    for (const dx of [159, 53, -53, -159]) {
      for (let n = 0; n <= 7; n++) {
        this.move(id, [this.pos(id).x + dx, undefined, undefined], 1, 20, 'easeInOutSine');
        id++;
      }
    }
    this.move(32, [0, 0, 0], 1, 22, 'easeInOutSine');
    this.move(33, [0, 0, 0], 1, 22, 'easeInOutSine', undefined, () => {
      // …les extrémités s'effacent, les plaques pivotent de 90° et s'enfoncent.
      for (const i of [32, 33]) {
        const g = (this.univers.array[i] as Point3d).point.graphics;
        g.clear();
        g.lineStyle(2, 0x000000, 0);
        g.lineTo(1, 0);
      }
      for (let i = 0; i <= 31; i++) {
        this.rotate(i, { z: 90 }, 1, 20, 'easeInOutSine', undefined, i === 31 ? () => this.finMulti() : undefined);
      }
      this.move(32, [0, 0, 500], 1, 20, 'easeInBack');
      this.move(33, [0, 0, 500], 1, 20, 'easeInBack');
    });
  }

  /** Les plaques reculent de 10 par image et disparaissent une à une, puis retour au menu. */
  private finMulti(): void {
    let t = 0;
    const scale = this.mm.createEmptyMovieClip('scale_time', 989671);
    scale.onEnterFrame = () => {
      this.univers.translateObject(0, 31, { z: -10 });
      const fin: Record<number, number> = { 6: 0, 12: 1, 18: 2, 22: 3 };
      if (t in fin) {
        const k = fin[t];
        this.cubes[k].removeMovieClip();
        this.api.remove(`cube${k}`);
      } else if (t === 24) {
        this.mm.removeMovieClip();
        this.onExit();
      }
      t++;
    };
  }

  // ———————————————————————————— I : audio (DoAction_3)

  private selectAudio(): void {
    delete this.rt.sample.onEnterFrame;
    this.coupeAmbiances(70);
    delete this.rt.btRetour.onRelease;
    for (let i = 0; i <= 33; i++) {
      if (i <= 7) {
        this.normRot(i);
        this.rotate(i, { x: -6 }, 0, 15, 'easeInOutSine');
      } else if (i <= 31) {
        this.normRot(i);
        // Une fois les plaques II–IV remises à plat, elles basculent de 90° autour de l'extrémité 33.
        const onStop = i === 31
          ? () => {
              for (let n = 8; n <= 31; n++) {
                this.rotateRel(n, 33, { z: 90 }, 2, 10, 'easeInOutSine', undefined,
                  n === 31 ? () => this.autreCubeAudioRotRel() : undefined);
              }
            }
          : undefined;
        this.rotate(i, { x: 0 }, 0, 15, 'easeInOutSine', undefined, onStop);
      } else {
        this.move(i, [53, undefined, undefined], 0, 15, 'easeInOutSine');
      }
    }
  }

  /** Les plaques II–IV filent au fond ; la ligne fait un aller-retour, puis la plaque I boucle autour. */
  private autreCubeAudioRotRel(): void {
    this.move(32, [-159, undefined, undefined], 0, 10, 'easeInOutSine');
    this.move(33, [-159, undefined, undefined], 0, 10, 'easeInOutSine', undefined, () => {
      this.move(32, [0, undefined, undefined], 2, 20, 'easeInOutSine');
      this.move(33, [0, undefined, undefined], 2, 20, 'easeInOutSine', () => this.loopingAudio());
    });
    for (let i = 8; i <= 31; i++) this.move(i, [undefined, undefined, -490], 4, 15, 'easeInOutSine');
  }

  private loopingAudio(): void {
    for (let i = 0; i <= 7; i++) {
      this.rotateRel(i, 33, { z: -360 }, 0, 20, 'easeInOutSine', undefined, i === 0 ? () => this.transformCube() : undefined);
    }
  }

  /** La plaque I se dédouble en six faces (points 34–57), qui s'écartent. */
  private transformCube(): void {
    const { api, univers: u, mm } = this;
    for (let k = 0; k <= 3; k++) api.desactiveEtat(`cube${k}`);
    for (let j = 0; j <= 2; j++) {
      for (let i = 0; i <= 7; i++) {
        const p = this.pos(i);
        const pt = new Point3d(p.x, p.y, p.z, mm, 1, 0x000000, 0, u.array.length);
        u.array.push(pt);
        pt.render(u.pers);
      }
    }
    const faces: number[][] = [
      [34, 35, 36, 37], [38, 39, 40, 41], [42, 43, 47, 46], [44, 45, 49, 48], [50, 54, 57, 53], [51, 52, 56, 55],
    ];
    faces.forEach((pts, n) => this.createApi(`faceCube${n + 1}`, 10004 + n, pts, 0, 'standardFillLine', true));
    this.eclateCubeAudio();
    // Point ajouté après l'éclatement : son mouvement, prévu avant qu'il existe, ne part jamais.
    u.array.push(new Point3d(0, -180, -150, mm, 0, 0x000000, 0, u.array.length));
  }

  private eclateCubeAudio(): void {
    this.timer(4, 5, () => this.snd('snd_multi_transition').start());
    this.faces[0].id = 38;
    for (let i = 34; i <= 58; i++) {
      const e: EasingName = 'easeOutQuad';
      if (i <= 37) this.move(i, [undefined, undefined, 400], 4, 50, e);
      else if (i <= 41) this.move(i, [undefined, undefined, -400], 4, 50, e);
      else if ([42, 43, 47, 46].includes(i)) this.move(i, [undefined, 60, undefined], 4, 50, e);
      else if ([44, 45, 49, 48].includes(i)) this.move(i, [undefined, -60, undefined], 4, 50, e);
      else if ([50, 54, 57, 53].includes(i)) this.move(i, [-200, undefined, undefined], 4, 50, e);
      else if ([51, 52, 56].includes(i)) this.move(i, [200, undefined, undefined], 4, 50, e);
      else this.move(i, [200, undefined, undefined], 4, 50, e, undefined, () => this.placeCubeAudioEclat());
    }
  }

  /** Les six faces prennent leur place : deux panneaux latéraux pivotent de ±60°. */
  private placeCubeAudioEclat(): void {
    const ic: EasingName = 'easeInCubic', is: EasingName = 'easeInSine';
    this.move(32, [250, 150, 0], 1, 40, ic);
    this.move(33, [250, -150, 0], 1, 40, ic, undefined, () => this.affichMcAudio());
    const quad = (ids: number[], pts: Axes[], duree: number, ease: EasingName, onStop?: Cb) =>
      ids.forEach((id, n) => this.move(id, pts[n], 1, duree, ease, undefined, n === ids.length - 1 ? onStop : undefined));
    let v = { x: -50, y: 120, z: -300 };
    quad([38, 39, 40, 41], [[v.x, v.y, v.z], [v.x + 100, v.y, v.z], [v.x + 100, v.y - 10, v.z], [v.x, v.y - 10, v.z]], 40, ic);
    v = { x: 0, y: 60, z: -200 };
    quad([34, 35, 36, 37], [[v.x + 50, v.y + 15, v.z], [v.x - 50, v.y + 15, v.z], [v.x - 50, v.y - 15, v.z], [v.x + 50, v.y - 15, v.z]], 40, ic);
    v = { x: -200, y: 110, z: 50 };
    quad([42, 43, 47, 46], [[v.x, v.y, v.z], [v.x, v.y, v.z - 100], [v.x, v.y - 220, v.z - 100], [v.x, v.y - 220, v.z]], 20, is, () => {
      [42, 43, 47, 46].forEach((id, n) =>
        this.rotate(id, { y: -60 }, 1, 20, is, n === 3 ? () => this.snd('snd_multi_transition').start() : undefined));
    });
    v = { x: 200, y: 110, z: -50 };
    quad([44, 45, 49, 48], [[v.x, v.y, v.z], [v.x, v.y, v.z + 100], [v.x, v.y - 220, v.z + 100], [v.x, v.y - 220, v.z]], 20, is, () => {
      [44, 45, 49, 48].forEach((id) => this.rotate(id, { y: 60 }, 1, 20, is));
    });
    v = { x: 0, y: 0, z: -200 };
    quad([50, 54, 57, 53], [[v.x - 50, v.y - 12, v.z], [v.x + 50, v.y - 12, v.z], [v.x + 50, v.y + 12, v.z], [v.x - 50, v.y + 12, v.z]], 40, is);
    v = { x: 0, y: -60, z: -200 };
    quad([51, 52, 56, 55], [[v.x - 50, v.y + 15, v.z], [v.x + 50, v.y + 15, v.z], [v.x + 50, v.y - 15, v.z], [v.x - 50, v.y - 15, v.z]], 40, is);
  }

  /** La « boîte » audio en place : on la fait pivoter à la souris, avec une butée sonore à ±30°. */
  private affichMcAudio(): void {
    this.snd('snd_multi_transition').start();
    this.rt.btRetour.onRelease = () => this.deselectAudio();
    for (let i = 34; i <= 37; i++) this.univers.array[i].rotation.reset(0, 0, 0);
    const { mm, univers: u } = this;
    this.rot = 0;
    let firstEnter = true;
    mm.onEnterFrame = () => {
      const xm = mm.xmouse;
      const d = xm / 180;
      const libre = xm < 10 ? this.rot > -30 : xm > 10 ? this.rot < 30 : false;
      if (xm !== 10) {
        if (libre) {
          u.rotateObjectY(34, 37, d);
          u.rotateObjectY(42, 57, d);
          this.rot += d;
          firstEnter = true;
        } else if (firstEnter) {
          this.snd('snd_multi_evt_bloc').start();
          firstEnter = false;
        }
      }
      u.rotateObjectY(32, 33, xm / 100);
    };
  }

  private deselectAudio(): void {
    this.relanceAmbiances(60, 'easeInOutSine');
    this.replaceAudioCube();
  }

  /** Les six faces se referment sur la plaque I ; les plaques II–IV reviennent de la droite. */
  private replaceAudioCube(): void {
    const { api, univers: u } = this;
    api.activeEtat('cube1');
    api.activeEtat('cube2');
    api.activeEtat('cube3');
    for (const k of [32, 33]) this.move(k, [this.acc[k].x, this.acc[k].y, this.acc[k].z], 0, 30, 'easeInOutSine');
    const vers: [number, number][] = [
      [34, 0], [35, 1], [36, 2], [37, 3], [38, 4], [39, 5], [40, 6], [41, 7], [42, 0], [43, 1], [47, 5], [46, 4],
      [44, 3], [45, 2], [49, 6], [48, 7], [50, 0], [54, 3], [57, 7], [53, 4], [51, 1], [52, 2], [56, 6], [55, 5],
    ];
    vers.forEach(([id, a], n) => {
      const c = this.acc[a];
      const onStop = n === vers.length - 1
        ? () => {
            this.supprFaceBoite();
            this.move(32, [300, 0, 0], 10, 60, 'easeOutBack');
            this.move(33, [-300, 0, 0], 10, 60, 'easeOutBack');
          }
        : undefined;
      this.move(id, [c.x, c.y, c.z], 0, 30, 'easeInOutSine', undefined, onStop);
    });
    for (let s = 0; s <= 7; s++) {
      this.pos(s).reset(this.acc[s].x, this.acc[s].y, this.acc[s].z);
      u.array[s].render(u.pers);
    }
    for (let w = 0; w <= 33; w++) {
      u.array[w].rotation.x = -6;
      u.array[w].rotation.z = 0;
    }
    let delai = 30;
    for (let j = 8; j <= 31; j++) {
      const c = this.acc[j];
      this.move(j, [c.x, c.y, c.z], delai, 20, 'easeOutSine', undefined, undefined, [500, c.y, c.z]);
      if (j === 15 || j === 23) delai += 10;
    }
  }

  private supprFaceBoite(): void {
    const { api, mm } = this;
    api.activeEtat('cube0');
    for (let n = 1; n <= 6; n++) {
      mm.child(`faceCube${n}`)?.removeMovieClip();
      api.desactiveEtat(`faceCube${n}`);
    }
    this.univers.array.length = 34;
    this.faces[0].id = 4;
    this.timer(40, 42, () => {
      this.activeAllBtEvent();
      this.multimediaEnterFrame();
    });
    this.rt.btRetour.onRelease = () => this.multimediaSortie();
  }

  // ———————————————————————————— III : flash (DoAction_5)

  private selectFlash(): void {
    delete this.rt.sample.onEnterFrame;
    this.coupeAmbiances(100);
    const amb = this.snd('snd_multi_flash_amb');
    amb.start(0, 99999999);
    this.tween.soundVolume(amb, undefined, 75, 0, 100, 'easeInOutSine');
    delete this.mm.onEnterFrame;
    delete this.rt.btRetour.onRelease;
    this.decalageFlash();
  }

  /** Les plaques se dressent, s'écartent, puis I, II et IV pivotent comme des pages vers les côtés. */
  private decalageFlash(): void {
    for (let i = 0; i <= 31; i++) {
      this.normRot(i);
      this.rotate(i, { x: i >= 16 && i <= 23 ? 90 : -90 }, 0, 20, 'easeOutSine');
    }
    for (const l of [32, 33]) this.move(l, [-320, undefined, undefined], 0, 20, 'easeOutSine');
    this.timer(
      21, 21,
      () => {
        this.snd('snd_multi_transition').start();
        for (let i = 0; i <= 31; i++) {
          const dy = i >= 16 && i <= 23 ? -80 : 80;
          this.move(i, [undefined, this.pos(i).y + dy, undefined], 0, 20, 'easeOutExpo');
        }
      },
      () => {
        const gauche = { x: -400, y: 0, z: 0 }, droite = { x: 400, y: 0, z: 0 };
        for (let i = 0; i <= 7; i++) this.rotateRel(i, gauche, { y: 90 }, 0, 20, 'easeInOutSine', undefined, undefined, { y: 0 });
        for (let i = 8; i <= 15; i++) this.rotateRel(i, gauche, { y: 90 }, 5, 15, 'easeInOutSine', undefined, undefined, { y: 0 });
        for (let i = 24; i <= 31; i++) this.rotateRel(i, droite, { y: -90 }, 0, 20, 'easeInOutSine', undefined, undefined, { y: 0 });
        this.miseEnPlaceFlash();
      },
    );
  }

  /** La plaque III s'ouvre en grand cadre (±300 × ±200). */
  private miseEnPlaceFlash(): void {
    const e: EasingName = 'easeOutExpo';
    for (const i of [16, 19, 20, 23]) this.move(i, [-300, undefined, undefined], 13, 10, e);
    for (const i of [17, 18, 21]) this.move(i, [300, undefined, undefined], 13, 10, e);
    this.move(22, [300, undefined, undefined], 13, 10, e, () => this.snd('snd_multi_transition').start());
    this.timer(
      24, 6,
      () => {
        this.snd('snd_multi_transition').start();
        this.move(32, [undefined, 120, undefined], 0, 15, e);
        this.move(33, [undefined, 70, undefined], 0, 15, e);
        for (let i = 16; i <= 19; i++) this.move(i, [undefined, -200, undefined], 0, 15, e);
        for (let i = 20; i <= 23; i++) this.move(i, [undefined, 200, undefined], 0, 15, e);
      },
      () => this.affichMcFlash(),
    );
  }

  private affichMcFlash(): void {
    const { api } = this;
    api.desactiveEtat('cube0');
    api.desactiveEtat('cube1');
    api.desactiveEtat('cube3');
    this.soundAmbientSeule('snd_multi_flash_amb');
    this.rt.btRetour.onRelease = () => this.deselectFlash();
    for (let i = 32; i <= 49; i++) this.univers.array[i]?.rotation.reset(0, 0, 0);
    const t = this.mm.createEmptyMovieClip('tFlashAnim', -23498);
    t.onEnterFrame = () => this.univers.rotateObjectY(32, 33, this.mm.xmouse / 200);
  }

  /** Ambiance flash (sprite 199, soundAmbient_flash) : volume selon la profondeur de l'extrémité 32. */
  private soundAmbientSeule(son: string): void {
    this.rt.sample.onEnterFrame = () => {
      const p = -this.pos(32).z / 3;
      this.snd(son).setVolume(Math.round((p + 150) / 2));
    };
  }

  private deselectFlash(): void {
    const { api } = this;
    this.mm.child('tFlashAnim')?.removeMovieClip();
    delete this.rt.sample.onEnterFrame;
    const amb = this.snd('snd_multi_flash_amb');
    this.tween.soundVolume(amb, undefined, 0, 0, 50, 'easeInSine', undefined, () => amb.stop());
    this.relanceAmbiances(50, 'easeInOutSine', 999999999);
    api.activeEtat('cube0');
    api.activeEtat('cube1');
    api.activeEtat('cube3');
    for (let t = 16; t <= 23; t++) {
      this.rotate(t, { x: -360 }, 0, 40, 'easeInOutSine', undefined, undefined, { x: 0 });
      this.move(t, [this.acc[t].x, undefined, undefined], 10, 20, 'easeInOutSine');
    }
    const gauche = { x: -400, y: 0, z: 0 }, droite = { x: 400, y: 0, z: 0 };
    for (let n = 0; n <= 7; n++) this.rotateRel(n, gauche, { y: -90 }, 20, 20, 'easeInOutSine');
    for (let p = 8; p <= 15; p++) this.rotateRel(p, gauche, { y: -90 }, 25, 15, 'easeInOutSine');
    for (let o = 24; o <= 31; o++) this.rotateRel(o, droite, { y: 90 }, 20, 20, 'easeInOutSine');
    for (const i of [32, 33]) {
      this.normRot(i, 'y');
      this.rotate(i, { y: 0 }, 0, 40, 'easeInOutSine');
      this.move(i, [undefined, 0, undefined], 0, 40, 'easeInOutSine');
    }
    this.timer(
      51, 21,
      () => {
        for (let i = 0; i <= 31; i++) {
          const y = i >= 16 && i <= 23 ? (this.pos(i).y <= 0 ? -30 : 190) : this.pos(i).y - 80;
          this.move(i, [undefined, y, undefined], 0, 20, 'easeOutExpo');
        }
        // Les extrémités reviennent inversées par rapport à l'intro (32 à gauche, 33 à droite).
        this.move(32, [-300, undefined, undefined], 0, 40, 'easeInOutSine');
        this.move(33, [300, undefined, undefined], 0, 40, 'easeInOutSine');
      },
      () => {
        this.activeAllBtEvent();
        this.univers.array.forEach((o, i) => o.rotation.reset(i >= 16 && i <= 23 ? 90 : -90, 0, 0));
        this.multimediaEnterFrame();
        this.rt.btRetour.onRelease = () => this.multimediaSortie();
      },
    );
  }

  // ———————————————————————————— IV : web (DoAction_4)

  /**
   * Particularité conservée : l'ambiance web devait suivre la profondeur via l'onStart de son
   * fondu, mais un mouvement sans délai n'appelle jamais onStart ; elle reste donc à 75.
   * Les plaques continuent aussi de suivre la souris jusqu'au début de la bascule.
   */
  private selectWeb(): void {
    delete this.rt.sample.onEnterFrame;
    this.coupeAmbiances(50);
    const amb = this.snd('snd_multi_web_amb');
    amb.start(0, 99999999);
    this.tween.soundVolume(amb, undefined, 75, 0, 60, 'easeInOutSine', () => this.soundAmbientSeule('snd_multi_web_amb'));
    delete this.rt.btRetour.onRelease;
    this.transformCubeTige(0, -270, 5, 10, 'easeOutSine');
    this.transformCubeTige(8, -255, 5, 10, 'easeOutSine');
    this.transformCubeTige(16, -240, 5, 10, 'easeOutSine');
    this.transformCubeTige(24, 0, 150, 10, 'easeOutCubic');
    this.timer(11, 2, () => this.rotationWeb());
  }

  /** Une plaque devient une tige (largeur ±xTaille autour de xCentre). */
  private transformCubeTige(i: number, xCentre: number, xTaille: number, duree: number, ease: EasingName): void {
    [-1, 1, 1, -1, -1, 1, 1, -1].forEach((s, k) => this.move(i + k, [xCentre + s * xTaille, undefined, undefined], 0, duree, ease));
  }

  private rotationWeb(): void {
    delete this.mm.onEnterFrame;
    for (let i = 0; i <= 31; i++) {
      this.normRot(i);
      this.rotate(i, { x: i <= 23 ? 90 : 0 }, 0, 10, 'easeOutSine');
    }
    for (const i of [32, 33]) this.move(i, [-300, undefined, undefined], 0, 10, 'easeOutSine');
    this.timer(11, 2, () => {
      this.cloneCubeWeb();
      this.fuiteAutreCubeWeb(0, 600);
      this.fuiteAutreCubeWeb(8, -600);
      this.fuiteAutreCubeWeb(16, 600);
      this.move(32, [undefined, 100, undefined], 0, 30, 'easeOutExpo');
      this.move(33, [undefined, -100, undefined], 0, 30, 'easeOutExpo');
    });
  }

  private fuiteAutreCubeWeb(iInit: number, posEnd: number): void {
    for (let i = iInit; i <= iInit + 7; i++) this.move(i, [undefined, posEnd, undefined], 10, 30, 'easeInSine');
  }

  /** La plaque IV se dédouble (points 34–41 et 42–49) ; les deux copies deviendront des volets. */
  private cloneCubeWeb(): void {
    const { univers: u, mm } = this;
    for (let c = 0; c <= 1; c++) {
      const first = u.array.length;
      for (let i = 24; i <= 31; i++) {
        const p = this.pos(i);
        const pt = new Point3d(p.x, p.y, p.z, mm, 0, 0x000000, 0, u.array.length);
        u.array.push(pt);
        pt.render(u.pers);
      }
      this.createApi(`facecube${c + 4}`, c + 4 + 10001, createPtsArray(first, 8), 0, 'cube', true);
    }
    this.snd('snd_multi_transition').start();
    this.decaleCubeClone(34, 100, 20);
    this.decaleCubeClone(42, -100, 20);
    this.timer(
      21, 16,
      () => {
        this.snd('snd_multi_transition').start();
        this.transformCubeTige(24, 0, 40, 15, 'easeOutSine');
        this.rotationCubeClone(34, 'z', 90, 15);
        this.rotationCubeClone(42, 'y', 90, 15);
      },
      () => {
        this.api.desactiveEtat('cube0');
        this.api.desactiveEtat('cube1');
        this.api.desactiveEtat('cube2');
        this.miseEnPlaceWeb();
        for (let i = 24; i <= 31; i++) {
          const p = this.pos(i);
          this.move(i, [p.x, p.y + 120, -300], 0, 15, 'easeOutSine');
        }
      },
    );
  }

  private decaleCubeClone(iInit: number, decalage: number, duree: number): void {
    for (let i = iInit; i <= iInit + 7; i++) this.move(i, [undefined, this.pos(i).y + decalage, undefined], 0, duree, 'easeOutSine');
  }

  private rotationCubeClone(iInit: number, axis: 'x' | 'y' | 'z', angle: number, duree: number): void {
    for (let i = iInit; i <= iInit + 7; i++) this.rotate(i, { [axis]: angle }, 0, duree, 'easeOutSine');
  }

  private miseEnPlaceWeb(): void {
    this.snd('snd_multi_transition').start();
    this.rotationCubeClone(34, 'y', -180, 15);
    this.rotationCubeClone(42, 'x', 90, 15);
    this.timer(16, 2, () => {
      this.activeWebAnim();
      this.snd('snd_multi_transition').start();
    });
  }

  /** Les deux volets s'ouvrent selon la souris, entre 0 et 90°, avec une butée sonore. */
  private activeWebAnim(): void {
    const { univers: u, mm } = this;
    this.rt.btRetour.onRelease = () => this.deselectWeb();
    for (let i = 32; i <= 49; i++) u.array[i]?.rotation.reset(0, 0, 0);
    const anim = mm.createEmptyMovieClip('tWebAnim', -23454);
    let firstEnterA = true;
    let firstEnterB = true;
    const bloc = () => {
      const s = this.snd('snd_multi_evt_bloc');
      s.stop();
      s.start();
    };
    anim.onEnterFrame = () => {
      const xm = mm.xmouse;
      const ra = u.array[42].rotation.y, rb = u.array[34].rotation.y;
      const negatif = xm <= 0;
      if (negatif ? ra > 0 : ra < 90) {
        u.rotateObjectY(42, 49, xm / (negatif ? 60 : 100));
        firstEnterA = true;
      } else if (firstEnterA) {
        bloc();
        firstEnterA = false;
      }
      if (negatif ? rb > 0 : rb < 90) {
        u.rotateObjectY(34, 41, xm / (negatif ? 100 : 60));
        firstEnterB = true;
      } else if (firstEnterB) {
        bloc();
        firstEnterB = false;
      }
      u.rotateObjectY(32, 33, xm / 200);
    };
  }

  private deselectWeb(): void {
    delete this.rt.sample.onEnterFrame;
    this.mm.child('tWebAnim')?.removeMovieClip();
    for (let i = 34; i <= 41; i++) this.rotate(i, { y: 90 }, 0, 10, 'easeOutSine');
    for (let i = 42; i <= 49; i++) this.rotate(i, { y: 0 }, 0, 10, 'easeOutSine');
    for (const i of [32, 33]) {
      this.normRot(i, 'y');
      this.rotate(i, { y: 0 }, 0, 60, 'easeInOutSine');
      this.move(i, [undefined, 0, undefined], 0, 80, 'easeInOutSine');
    }
    this.timer(11, 2, () => {
      for (let i = 34; i <= 49; i++) {
        this.move(i, [i >= 38 && i <= 45 ? 100 : -100, undefined, undefined], 0, 10, 'easeOutSine');
        this.rotate(i, { x: 90 }, 0, 10, 'easeOutSine');
      }
      const amb = this.snd('snd_multi_web_amb');
      this.tween.soundVolume(amb, undefined, 0, 0, 60, 'easeInSine', undefined, () => amb.stop());
      this.relanceAmbiances(60, 'easeOutSine', 999999999);
      this.collageWebClone();
    });
  }

  /** La plaque IV se recolle sur ses deux copies, qui disparaissent. */
  private collageWebClone(): void {
    this.timer(11, 2, () => {
      const p = (i: number) => this.pos(i);
      const vers: [number, Axes][] = [
        [28, [p(34).x, p(34).y, p(34).z]], [31, [p(37).x, p(37).y, p(37).z]],
        [24, [p(35).x, p(35).y, p(35).z]], [27, [p(36).x, p(36).y, p(36).z]],
        [29, [p(38).x, p(34).y, p(34).z]], [30, [p(41).x, p(37).y, p(37).z]],
        [25, [p(39).x, p(35).y, p(35).z]], [26, [p(40).x, p(36).y, p(36).z]],
      ];
      vers.forEach(([id, dest], n) =>
        this.move(id, dest, 2, 10, 'easeInSine', undefined, n === vers.length - 1 ? () => this.suppCubeWebClone() : undefined));
    });
  }

  /** L'original retire deux fois facecube4 (et jamais facecube5, désactivé donc vide). */
  private suppCubeWebClone(): void {
    const { api, mm } = this;
    api.activeEtat('cube0');
    api.activeEtat('cube1');
    api.activeEtat('cube2');
    api.desactiveEtat('facecube4');
    api.desactiveEtat('facecube5');
    mm.child('facecube4')?.removeMovieClip();
    this.univers.array.length = 34;
    for (let i = 24; i <= 31; i++) this.move(i, [undefined, this.acc[i].y, this.acc[i].z], 1, 10, 'easeOutSine');
    this.timer(12, 2, () => this.placeCubeWebSurLigne());
  }

  /** Les plaques I–III reviennent de la gauche (III d'abord), la IV reprend sa largeur. */
  private placeCubeWebSurLigne(): void {
    let delai = 20;
    for (let i = 0; i <= 23; i++) {
      const c = this.acc[i];
      this.move(i, [c.x, c.y, c.z], delai, 20, 'easeOutSine', undefined, undefined, [-500, c.y, c.z]);
      if (i === 7 || i === 15) delai -= 10;
    }
    for (let i = 24; i <= 31; i++) this.move(i, [this.acc[i].x, undefined, undefined], 0, 20, 'easeOutSine');
    this.move(32, [-300, undefined, undefined], 30, 40, 'easeInOutSine');
    this.move(33, [300, undefined, undefined], 30, 40, 'easeInOutSine');
    this.timer(41, 42, () => {
      this.activeAllBtEvent();
      for (const o of this.univers.array) o.rotation.reset(-6, 0, 0);
      this.multimediaEnterFrame();
      this.rt.btRetour.onRelease = () => this.multimediaSortie();
    });
  }
}
