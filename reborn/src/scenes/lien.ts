import { random } from '../engine/easing';
import { createPtsArray, getCube3dPoints } from '../engine/shapes3d';
import { Repere3d, type Vector3d } from '../engine/space3d';
import { Clip } from '../flash/clip';
import { TextField } from '../flash/text';
import type { Runtime } from '../runtime';

/** Chiffres des six plaques (symboles lien_bt_audio, _video, _web, _lieu, _savoir, _miscellanee). */
const CHIFFRES = ['I', 'II', 'III', 'IV', 'V', 'VI'];
/** Taille naturelle des symboles lien_bt (cadre invisible de 190 × 114,65), base de _width/_height. */
const BT_W = 190;
const BT_H = 114.65;

type Axes = [number | undefined, number | undefined, number | undefined];

/** Symbole lien_bt_* (sprites 90–100) : un chiffre romain de 20 px, centré dans un cadre invisible. */
function lienBt(chiffre: string): Clip {
  const mc = new Clip('lien_bt');
  const txt = mc.addChildAt(new TextField('chiffre', { text: chiffre, size: 20, color: 0x333333, align: 'center', width: 40 }), 1);
  txt.x = 9.5 - 20;
  txt.y = -11.35 + 18 - 2 - 20 * 0.9;
  return mc;
}

/**
 * Section III « lien » (sprite 79) : six plaques alignées, qui tournent selon la souris.
 * Indices : plaque k = points 8k à 8k+7 ; la face arrière (4–7) porte le chiffre de la plaque.
 *
 * Retiré : le panneau de contenu ouvert sur la plaque choisie (`lien_lic` : nom du menu, vide,
 * et une ligne de séparation) ; les temps d'animation sont conservés.
 * Particularité conservée : l'intro est lancée deux fois (fin des blocs DoAction_2 et DoAction_4),
 * d'où des nappes doublées et une vrille d'arrivée cumulée.
 */
export class Lien {
  readonly lien: Clip;
  readonly univers = new Repere3d(500);
  private readonly cubes: Clip[] = [];
  private mcBtLien: Clip = new Clip();
  private bts: Clip[] = [];
  /** saveRepere(univers, "save_lien"). */
  private save: Vector3d[] = [];
  /** `_global.idLienActuel` : plaque choisie, -1 sinon. */
  private idLienActuel = -1;

  constructor(
    private readonly rt: Runtime,
    private readonly onExit: () => void,
  ) {
    this.lien = rt.level10.createEmptyMovieClip('lien', 13);
    this.lien.x = 490;
    this.lien.y = 365;
    let x = -(110 * 2 + 110 / 2);
    for (let i = 0; i <= 5; i++) {
      getCube3dPoints(this.lien, this.univers, x, 0, 0, 100, 200, 10, { taille: 0, couleur: 0x000000, alpha: 0 });
      const mc = this.lien.createEmptyMovieClip(`cube${i}`, 10000 + i);
      rt.api.createApi(mc, this.univers, createPtsArray(i * 8, 8), `cube${i}`, 1, 'cube', false, 'global');
      this.cubes.push(mc);
      x += 110;
    }
    this.univers.render(500);
    this.save = this.univers.savePositions();
    this.introLien();
    this.introLien();
  }

  private get tween() {
    return this.rt.tween;
  }

  private snd(name: string) {
    return this.rt.sounds.get(name);
  }

  private move(id: number, dest: Axes, delai: number, duree: number, ease: 'easeOutExpo' = 'easeOutExpo'): void {
    this.tween.rMouvement(this, this.univers, id, undefined, dest, delai, duree, ease);
  }

  private styleToggle(k: number): void {
    const obj = this.rt.api.apiOn.get(`cube${k}`);
    if (obj) obj.styleId = obj.styleId !== 0 ? 0 : 1;
  }

  /** Hauteur de la plaque (points 0,1,4,5 en haut, 2,3,6,7 en bas). */
  private etireLienCubeY(i: number, posY: number, taille: number, temps: number): void {
    const h = taille / 2;
    for (const k of [0, 1, 4, 5]) this.move(i + k, [undefined, posY + h, undefined], 0, temps);
    for (const k of [2, 3, 6, 7]) this.move(i + k, [undefined, posY - h, undefined], 0, temps);
  }

  /** Épaisseur de la plaque (points 0–3 devant, 4–7 derrière). */
  private etireLienCubeZ(i: number, taille: number, temps: number): void {
    const h = taille / 2;
    for (let k = 0; k <= 3; k++) this.move(i + k, [undefined, undefined, h], 0, temps);
    for (let k = 4; k <= 7; k++) this.move(i + k, [undefined, undefined, -h], 0, temps);
  }

  /** La plaque choisie s'élargit à ±300. */
  private placeLienCube(i: number): void {
    for (const k of [0, 3, 4, 7]) this.move(i + k, [-300, undefined, undefined], 0, 10);
    for (const k of [1, 2, 6, 5]) this.move(i + k, [300, undefined, undefined], 0, 10);
  }

  /** Décale verticalement les 8 points d'une plaque (dest calculée au moment de l'appel). */
  private decaleY(k: number, dy: number): void {
    for (let i = k * 8; i <= k * 8 + 7; i++) this.move(i, [undefined, this.univers.array[i].position.y + dy, undefined], 0, 20);
  }

  private retourX(k: number): void {
    for (let i = k * 8; i <= k * 8 + 7; i++) this.move(i, [this.save[i].x, undefined, undefined], 0, 20);
  }

  /** affichBtLien : les chiffres, recalés à chaque image sur la face arrière de leur plaque. */
  private affichBtLien(): void {
    this.mcBtLien = this.lien.createEmptyMovieClip('mcBtLien', 558778);
    this.bts = CHIFFRES.map((c, k) => this.mcBtLien.addChildAt(lienBt(c), 10 + k, `lien_bt_${k}`));
    this.attachBtLien();
    this.mcBtLien.onEnterFrame = () => this.attachBtLien();
  }

  private attachBtLien(): void {
    const a = this.univers.array;
    this.bts.forEach((bt, k) => {
      const [p4, p5, p6, p7] = [4, 5, 6, 7].map((n) => a[8 * k + n].screenPos);
      const dx = (p5.x - p4.x + (p6.x - p7.x)) / 2;
      const dy = (p4.y - p7.y + (p5.y - p6.y)) / 2;
      bt.x = (p5.x + p4.x) / 2;
      bt.y = -(p4.y + p7.y) / 2;
      bt.xscale = (Math.abs(dx) / BT_W) * 100;
      bt.yscale = (Math.abs(dy) / BT_H) * 100;
    });
  }

  private introLien(): void {
    const { tween } = this;
    const u = this.univers;
    const pos1 = this.snd('snd_lien_pos_1');
    pos1.start(0, 99999999);
    pos1.setVolume(0);
    pos1.setPan(-100);
    tween.soundVolume(pos1, 0, 55, 0, 50, 'easeInOutSine');
    const pos2 = this.snd('snd_lien_pos_2');
    pos2.start(0, 99999999);
    pos2.setVolume(0);
    pos2.setPan(100);
    tween.soundVolume(pos2, 0, 55, 0, 50, 'easeInOutSine');
    const rot1 = this.snd('snd_lien_rot_1');
    const rot2 = this.snd('snd_lien_rot_2');
    rot1.start(0, 99999999);
    rot1.setVolume(0);
    tween.soundVolume(rot2, 0, 30, 0, 30, 'easeInOutSine');
    rot2.start(0, 99999999);
    rot2.setVolume(0);
    tween.soundVolume(rot2, 0, 30, 0, 30, 'easeInOutSine');

    // Chaque plaque fait un ou deux tours en X ; les deux moitiés partent à ±600.
    for (let o = 0; o <= 5; o++) {
      const angle = random(20) - 10;
      const nbTours = (random(2) + 1) * 360 - 90;
      u.rotateObjectX(o * 8, o * 8 + 7, angle - nbTours);
    }
    for (let p = 0; p < u.array.length / 2; p++) {
      u.array[p].position.x -= 600;
      u.array[p].render(u.pers);
    }
    for (let q = u.array.length / 2; q < u.array.length; q++) {
      u.array[q].position.x += 600;
      u.array[q].render(u.pers);
    }

    // Arrivée symétrique : les plaques du centre d'abord (délais 21, 11, 1, 1, 11, 21).
    let delai = 20;
    let sens = 0;
    this.affichBtLien();
    for (let k = 0; k <= 5; k++) {
      this.bts[k].alpha = 0;
      this.rt.api.activeEtat(`cube${k}`);
      for (let n = 0; n <= 7; n++) this.move(k * 8 + n, [this.save[k * 8 + n].x, undefined, undefined], delai + 1, 20);
      if (delai !== 0 || sens === 1) delai = sens !== 0 ? delai + 10 : delai - 10;
      else sens = 1;
    }

    tween.retardateur(
      this, 22, 41,
      () => {
        for (let k = 0; k <= 5; k++) {
          const d = (random(4) + 1) * 10;
          for (let n = 0; n <= 7; n++) tween.rRotation(this, u, k * 8 + n, undefined, { x: 0 }, 0, d, 'easeInOutCubic');
          tween.mouvement(this.bts[k], 'alpha', 0, 100, d / 2, 30, 'easeInSine');
        }
      },
      () => {
        this.soundAmbient();
        this.startLienEnterFrame();
        this.activeLienBt();
      },
    );
  }

  /**
   * Ambiance (sprite 199, soundAmbient_lien) : deux nappes suivent les plaques I et VI (volume selon z,
   * panoramique selon x) ; deux autres se répartissent selon la souris (repère du clip sample).
   */
  private soundAmbient(): void {
    const { sample } = this.rt;
    const a = this.univers.array;
    sample.onEnterFrame = () => {
      const p1 = a[4].position;
      this.snd('snd_lien_pos_1').setVolume(Math.round((-15 * (p1.z / 3 + 110)) / 22 + 150));
      this.snd('snd_lien_pos_1').setPan(p1.x / 3);
      const p2 = a[45].position;
      this.snd('snd_lien_pos_2').setVolume(Math.round((-15 * (p2.z / 3 + 110)) / 22 + 150));
      this.snd('snd_lien_pos_2').setPan(p2.x / 3);
      const xm = sample.xmouse;
      this.snd('snd_lien_rot_1').setVolume(Math.max((-xm / 3 + 50) / 2, 0));
      this.snd('snd_lien_rot_2').setVolume(Math.max((xm / 3 + 50) / 2, 0));
    };
  }

  private startLienEnterFrame(): void {
    this.lien.onEnterFrame = () => this.univers.rotateY(this.lien.xmouse / 100);
  }

  private bind(over: (k: number) => void, out: (k: number) => void, release: (k: number) => void, sauf = -1): void {
    this.rt.btRetour.onRelease = () => (sauf < 0 ? this.sortieLien() : this.retourLienAccueil());
    this.cubes.forEach((mc, k) => {
      if (k === sauf) return;
      mc.onRollOver = () => over(k);
      mc.onRollOut = mc.onReleaseOutside = () => out(k);
      mc.onRelease = () => release(k);
    });
  }

  private activeLienBt(): void {
    this.bind(
      (k) => {
        const s = this.snd(`snd_lien_evt_${k + 1}`);
        s.stop();
        s.start();
        this.styleToggle(k);
        this.etireLienCubeY(k * 8, 0, 360, 20);
      },
      (k) => {
        this.styleToggle(k);
        this.etireLienCubeY(k * 8, 0, 200, 10);
      },
      (k) => this.eventBtLienRelease(k),
    );
  }

  private activeLienAutreBt(): void {
    this.bind(
      (k) => {
        const s = this.snd(`snd_lien_evt_${k + 1}`);
        s.stop();
        s.start();
        this.styleToggle(k);
        this.etireLienCubeZ(k * 8, 100, 20);
      },
      (k) => {
        this.styleToggle(k);
        this.etireLienCubeZ(k * 8, 10, 10);
      },
      (k) => this.eventAutreBtLienRelease(k),
      this.idLienActuel,
    );
  }

  private deactiveLienBt(): void {
    delete this.rt.btRetour.onRelease;
    for (const mc of this.cubes) {
      delete mc.onRollOver;
      delete mc.onRollOut;
      delete mc.onRelease;
      delete mc.onReleaseOutside;
    }
  }

  /**
   * Remet toutes les plaques face à l'écran : la rotation Y courante est ramenée dans ]-360, 0[
   * ou ]0, 360], puis annulée en 20 images (d'où un grand tour plutôt qu'un petit).
   */
  private faceEcran(): void {
    const u = this.univers;
    const r = u.array[0].rotation.y;
    const rotCourant = r < 0 ? (r % 360) + 360 : (r % 360) - 360;
    for (const o of u.array) {
      o.rotation.y = rotCourant;
    }
    for (let s = 0; s < u.array.length; s++) this.tween.rRotation(this, u, s, undefined, { y: 0 }, 0, 20, 'easeInOutSine');
  }

  /** Le chiffre de la plaque choisie se resserre puis disparaît. */
  private cacheChiffre(k: number): void {
    const bt = this.bts[k];
    this.tween.mouvement(bt, 'xscale', undefined, 0, 0, 10, 'easeInSine', undefined, () => (bt.visible = false));
  }

  private montreChiffre(k: number): void {
    const bt = this.bts[k];
    this.tween.mouvement(bt, 'xscale', 0, 100, 10, 10, 'easeInSine', () => (bt.visible = true));
  }

  /** Choix d'une plaque : face à l'écran, les autres descendent, elle s'élargit. */
  private eventBtLienRelease(idC: number): void {
    const obj = this.rt.api.apiOn.get(`cube${idC}`);
    if (obj) obj.styleId = 0;
    this.idLienActuel = idC;
    delete this.lien.onEnterFrame;
    this.deactiveLienBt();
    this.faceEcran();
    for (let a = 0; a <= 5; a++) if (a !== idC) this.etireLienCubeY(a * 8, 0, 50, 20);
    this.tween.retardateur(
      this, 15, 16,
      () => {
        for (let k = 0; k <= 5; k++) if (k !== idC) this.decaleY(k, -240);
      },
      () => this.placeLienCube(idC * 8),
    );
    this.tween.retardateur(this, 36, 37, () => {
      this.activeLienAutreBt();
      this.cacheChiffre(idC);
    });
  }

  /** Passage à une autre plaque : l'ancienne reprend sa place en bas, la nouvelle monte et s'élargit. */
  private eventAutreBtLienRelease(idC: number): void {
    const idPt = idC * 8;
    this.deactiveLienBt();
    this.montreChiffre(this.idLienActuel);
    this.etireLienCubeZ(idPt, 10, 10);
    this.tween.retardateur(
      this, 11, 16,
      () => {
        this.retourX(this.idLienActuel);
        this.decaleY(idC, 240);
      },
      () => {
        this.etireLienCubeY(idPt, 0, 360, 20);
        this.etireLienCubeY(this.idLienActuel * 8, 0, 50, 20);
      },
    );
    this.tween.retardateur(
      this, 50, 16,
      () => {
        this.placeLienCube(idPt);
        this.decaleY(this.idLienActuel, -240);
        this.idLienActuel = idC;
      },
      () => {
        this.activeLienAutreBt();
        this.cacheChiffre(idC);
      },
    );
  }

  /** Retour à la rangée de plaques. */
  private retourLienAccueil(): void {
    this.deactiveLienBt();
    this.montreChiffre(this.idLienActuel);
    this.tween.retardateur(
      this, 12, 16,
      () => {
        const sel = this.idLienActuel;
        for (let i = 0; i < this.univers.array.length; i++) {
          if (i >= sel * 8 && i <= sel * 8 + 7) this.move(i, [this.save[i].x, undefined, undefined], 0, 20);
          else this.move(i, [undefined, this.univers.array[i].position.y + 240, undefined], 0, 20);
        }
      },
      () => {
        for (let k = 0; k <= 5; k++) this.etireLienCubeY(k * 8, 0, 200, 20);
      },
    );
    this.tween.retardateur(this, 50, 16, () => {
      this.activeLienBt();
      this.idLienActuel = -1;
      this.startLienEnterFrame();
    });
  }

  /** Sortie : face à l'écran, chaque plaque pivote sur elle-même et bascule, puis tout part au fond. */
  private sortieLien(): void {
    const { tween, rt } = this;
    const u = this.univers;
    delete rt.sample.onEnterFrame;
    // L'original fond deux fois la nappe rot_2 (et jamais rot_1), puis coupe tout à la fin.
    tween.soundVolume(this.snd('snd_lien_pos_1'), undefined, 0, 0, 60, 'easeInOutSine');
    tween.soundVolume(this.snd('snd_lien_pos_2'), undefined, 0, 0, 60, 'easeInOutSine');
    tween.soundVolume(this.snd('snd_lien_rot_2'), undefined, 0, 0, 60, 'easeInOutSine');
    this.idLienActuel = -1;
    delete this.lien.onEnterFrame;
    this.deactiveLienBt();
    this.faceEcran();
    tween.retardateur(
      this, 21, 20,
      () => {
        let posCtrl = -275;
        for (let k = 0; k <= 5; k++) {
          for (let n = 0; n <= 7; n++) {
            const id = k * 8 + n;
            tween.rRotationRelative(this, u, id, { x: posCtrl, y: 0, z: 0 }, { y: 0 }, { y: -90 }, k, 10, 'easeOutExpo');
            tween.rRotation(this, u, id, { x: 0 }, { x: -90 }, k + 10, 10, 'easeOutExpo');
          }
          posCtrl += 110;
        }
      },
      () => {
        for (let k = 0; k <= 5; k++) {
          for (let n = 0; n <= 7; n++) this.move(k * 8 + n, [undefined, undefined, -500], k, 20);
        }
      },
    );
    tween.retardateur(this, 65, 2, () => {
      rt.api.removeAllOn();
      for (const n of ['snd_lien_rot_2', 'snd_lien_rot_1', 'snd_lien_pos_2', 'snd_lien_pos_1']) this.snd(n).stop();
      this.lien.removeMovieClip();
      this.onExit();
    });
  }
}
