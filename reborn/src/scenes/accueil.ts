import type { FlashSound } from '../audio/sound';
import type { ApiType } from '../engine/api';
import { random } from '../engine/easing';
import {
  createPtsArray, getCarre3dPoints, getCercle3dPoints, getCube3dPoints, getEtoile3dPoints, type PointStyle,
} from '../engine/shapes3d';
import { Particle3d, Point3d, Repere3d, type Vector3d } from '../engine/space3d';
import { Clip } from '../flash/clip';
import type { Runtime } from '../runtime';
import { BT } from '../symbols/bt';

/** Libellés des boutons (`_global.Data`). */
const DATA = ['I', 'II', 'III', 'IV'];

/** Indices des boutons dans le repère, et section ouverte par chacun (BT.onPress). */
export type Section = 'cv' | 'multimedia' | 'lien' | 'info';
const SECTION_BY_BT: Record<number, Section> = { 19: 'cv', 20: 'multimedia', 21: 'lien', 22: 'info' };

/**
 * Accueil : sprite « E » d'interface.swf (frame 2), à l'échelle 70 % au centre de la scène.
 * Le code suit l'original instruction par instruction ; les indices de points sont ceux d'origine.
 */
export class Accueil {
  readonly E: Clip;
  readonly univers = new Repere3d();
  /** Pose de référence (saveRepere(univers, "accueil")). */
  accueil: Vector3d[] = [];
  /** `tShake` : variable du scénario de E (voir shakeXCercle3d). */
  private tShake = 0;
  private bts: BT[] = [];

  constructor(
    private readonly rt: Runtime,
    private readonly onSection: (section: Section) => void,
  ) {
    this.E = rt.level10.createEmptyMovieClip('E', 10);
    this.E.x = 490;
    this.E.y = 365;
    this.E.xscale = 70;
    this.E.yscale = 70;
    this.build();
    this.bindRollOvers();
    this.start();
  }

  private snd(name: string): FlashSound {
    return this.rt.sounds.get(name);
  }

  private api(depth: number, pts: number[] | number[][], nom: string, styleId: number, type: ApiType): Clip {
    const mc = this.E.createEmptyMovieClip(nom, depth);
    this.rt.api.createApi(mc, this.univers, pts, nom, styleId, type, false, 'global');
    return mc;
  }

  /** Frame 2, DoAction_2 et DoAction_3 : construction de la géométrie (186 points). */
  private build(): void {
    const { E, univers: u } = this;
    const pt: PointStyle = { taille: 2, couleur: 0x475656, alpha: 100 };
    const point = (x: number, y: number, z: number) =>
      u.array.push(new Point3d(x, y, z, E, pt.taille!, pt.couleur, pt.alpha, u.array.length));

    // Barre horizontale (0–7) et ses quatre faces longues.
    getCube3dPoints(E, u, 0, 0, 0, 900, 20, 20, pt);
    this.api(1000, [0, 1, 2, 3], 'api0', 0, 'standardFillLine');
    this.api(1001, [4, 5, 6, 7], 'api1', 0, 'standardFillLine');
    this.api(1002, [0, 4, 7, 3], 'api2', 0, 'standardFillLine');
    this.api(1003, [1, 5, 6, 2], 'api3', 0, 'standardFillLine');

    // Extrémité gauche : carré (8–11), point de contrôle (13) et étoile courbe (14–18).
    getEtoile3dPoints(E, u, 0, 0, 0, 80, 80, 0, pt);
    u.rotateObjectY(8, 12, 90);
    u.translateObject(8, 12, { x: -370 });
    this.api(10001, [8, 9, 10, 11], 'api4', 0, 'standardFillLine');
    point(-290, 0, 0);
    getEtoile3dPoints(E, u, 0, 0, 0, 320, 320, 0, pt);
    u.rotateObjectY(14, 18, 90);
    u.translateObject(14, 18, { x: -380 });
    this.api(10002, createPtsArray(13, 5), 'api5', 0, 'etoile');

    // Les quatre boutons (19–22), répartis sur un anneau autour de l'axe X.
    const theta = 360 / DATA.length;
    for (let i = 0; i < DATA.length; i++) {
      const id = u.array.length;
      const p = new Particle3d(-380, 0, 230, E, () => new BT(), 'BT', id);
      u.array.push(p);
      u.rotateObjectX(id, id, 45 + theta * i);
      p.mc.id = id;
      p.mc.txt.text = DATA[i];
      this.bts.push(p.mc);
    }

    // Extrémité droite : carré (23–26), cercle (27–44), point de contrôle (45), étoile (46–50).
    getCarre3dPoints(E, u, 0, 0, 0, 80, 80, 0, pt);
    u.rotateObjectY(23, 26, 90);
    u.translateObject(23, 26, { x: 400 });
    this.api(10003, [23, 24, 25, 26], 'api6', 0, 'standardFillLine');
    getCercle3dPoints(E, u, 0, 0, 0, 200, 200, pt);
    u.rotateObjectY(27, 44, 90);
    u.translateObject(27, 44, { x: 400 });
    this.api(10004, createPtsArray(u.idObjet[4], 17), 'api7', 0, 'standardCurve');
    point(330, 0, 0);
    getEtoile3dPoints(E, u, 0, 0, 0, 280, 280, 0, pt);
    u.rotateObjectY(46, 50, 90);
    u.translateObject(46, 50, { x: 400 });
    this.api(10005, createPtsArray(45, 5), 'api8', 0, 'etoile');

    // Cylindre central : deux cercles (51–68, 69–86) reliés.
    getCercle3dPoints(E, u, 0, 0, -300, 150, 150, pt);
    u.rotateObjectY(51, 68, 90);
    getCercle3dPoints(E, u, 0, 0, -260, 150, 150, pt);
    u.rotateObjectY(69, 86, 90);
    this.api(10501, createPtsArray(u.idObjet[6], 17), 'api9', 1, 'cercleCutted');
    this.api(10502, createPtsArray(u.idObjet[7], 17), 'api10', 1, 'cercleCutted');
    this.api(10503, [createPtsArray(u.idObjet[6], 17), createPtsArray(u.idObjet[7], 17)], 'api11', 1, 'liaisonCylindre');

    // Cercle central incliné (87–104) et ses quatre pics (105–108).
    getCercle3dPoints(E, u, 0, 0, -280, 50, 50, pt);
    u.rotateObjectY(87, 104, 90);
    u.rotateObjectX(87, 104, 22);
    this.api(10504, createPtsArray(u.idObjet[8], 17), 'api12', 1, 'cercle');
    point(-280, 250, 0);
    point(-280, 0, 250);
    point(-280, -250, 0);
    point(-280, 0, -250);
    u.rotateObjectX(105, 108, -68);
    this.api(10506, [u.idObjet[8], 105], 'api14', 1, 'liaisonCerclePic');

    // Quatre petits cercles à droite (109–180), leurs centres (181–184) et le point de fuite (185).
    [0, 90, 180, 270].forEach((angle, k) => {
      const first = u.array.length;
      getCercle3dPoints(E, u, 0, 0, 200, 30, 30, pt);
      if (angle) u.rotateObjectX(first, first + 17, angle);
      u.translateObject(first, first + 17, { x: 370 });
      this.api(10507 + k, createPtsArray(u.idObjet[9 + k], 17), `api${15 + k}`, 1, 'cercle');
    });
    point(370, 0, 200);
    point(370, 0, -200);
    point(370, 200, 0);
    point(370, -200, 0);
    u.rotateObjectX(109, 184, 22);
    point(400, 0, 0);
    this.api(10511, [105, 185, 182], 'api19', 1, 'standardCurve');
    this.api(10512, [108, 185, 184], 'api20', 1, 'standardCurve');
    this.api(10513, [106, 185, 183], 'api21', 1, 'standardCurve');
    this.api(10514, [107, 185, 181], 'api22', 1, 'standardCurve');

    this.accueil = u.savePositions();
  }

  /** Frame 2, DoAction_5 : tout est replié en (0, 0, 900), puis intro ou retour. */
  private start(): void {
    for (const o of this.univers.array) {
      o.position.reset(0, 0, 900);
      o.render();
    }
    this.activeBT(false);
    if (this.rt.firstEnter) {
      this.introAccueil();
      this.rt.firstEnter = false;
    } else if (random(100) >= 96) this.retourAccueil_v0();
    else this.retourAccueil_v1();
  }

  private startEnterFrame(): void {
    const amb1 = this.snd('snd_menu_amb_1');
    const amb2 = this.snd('snd_menu_amb_2');
    amb1.start(0, 900000);
    this.rt.tween.soundVolume(amb1, 0, 150, 0, 30, 'easeInOutSine', undefined, () => this.soundAmbient());
    amb2.start(0, 900000);
    amb2.setVolume(0);

    const { E, univers: u } = this;
    E.onEnterFrame = () => {
      u.rotateObjectX(0, 50, E.ymouse / 60);
      u.rotateObjectX(51, 185, E.xmouse / 120);
      const x87 = u.array[87].position.x;
      const xm = E.xmouse;
      let d: number;
      if (xm < -300 || xm > 300) d = xm <= 0 ? (-300 - x87) / 10 : (300 - x87) / 6;
      else d = (xm - x87) / 10;
      u.translateObject(69, 108, { x: d });
    };
  }

  /**
   * Ambiance de l'accueil (sprite 199, soundAmbient_accueil) : la position X du cercle central
   * règle le panoramique de la première nappe et le volume de la seconde.
   */
  private soundAmbient(): void {
    this.rt.sample.onEnterFrame = () => {
      const x = this.univers.array[87].position.x;
      this.snd('snd_menu_amb_1').setPan(x / 3);
      this.snd('snd_menu_amb_2').setVolume((x + 300) / 6);
    };
  }

  private introAccueil(): void {
    const { tween } = this.rt;
    tween.retardateur(this, 15, 16, () => this.snd('snd_menu_intro_1').start());
    let delai = 0;
    const n = this.univers.array.length;
    for (let i = 0; i < n; i++) {
      const a = this.accueil[i];
      const onStop = i === n - 1
        ? () => {
            this.desactivePointsInTime();
            this.activeLignesInTime(23);
            this.activeBT(true);
            this.snd('snd_menu_intro_3').start();
            this.startEnterFrame();
          }
        : undefined;
      tween.rMouvement(this, this.univers, i, [0, 0, 600], [a.x, a.y, a.z], Math.round(delai), 30, 'easeOutSine', undefined, onStop);
      delai += 0.3;
    }
  }

  /** Retour rare (4 %) : les deux moitiés arrivent des côtés, décalées. */
  private retourAccueil_v0(): void {
    const { tween } = this.rt;
    const u = this.univers;
    this.desactivePoints();
    this.activeLignes(23);
    let delaiA = 0;
    for (let i = 0; i <= 22; i++) {
      const a = this.accueil[i];
      u.array[i].position.reset(a.x - 1500, a.y, a.z);
      u.array[i].render();
      tween.rMouvement(this, u, i, undefined, [a.x, undefined, undefined], Math.floor(delaiA), 30, 'easeOutSine');
      delaiA += 1;
    }
    let delaiB = 0;
    // `<=` d'origine : le dernier tour vise un point inexistant.
    for (let i = 23; i <= u.array.length; i++) {
      const a = this.accueil[i];
      if (u.array[i] && a) {
        u.array[i].position.reset(a.x + 1500, a.y, a.z);
        u.array[i].render();
      }
      tween.rMouvement(this, u, i, undefined, [a?.x, undefined, undefined], Math.floor(delaiB), 20, 'easeOutSine');
      delaiB += 0.2;
    }
    tween.retardateur(this, 1, 60, () => this.activeBT(true), () => this.startEnterFrame());
  }

  /** Retour habituel (96 %) : tout jaillit de deux points, puis se déploie avec un rebond. */
  private retourAccueil_v1(): void {
    const { tween } = this.rt;
    const u = this.univers;
    this.desactivePoints();
    this.activeLignes(23);
    tween.retardateur(this, 2, 3, () => this.snd('snd_menu_retour_1').start());
    for (let i = 0; i <= 22; i++) {
      u.array[i].position.reset(-600, 0, 0);
      u.array[i].render();
      tween.rMouvement(this, u, i, undefined, [this.accueil[i].x, undefined, undefined], 0, 20, 'easeInSine');
    }
    for (let i = 23; i <= u.array.length; i++) {
      u.array[i]?.position.reset(600, 0, 0);
      u.array[i]?.render();
      tween.rMouvement(this, u, i, undefined, [this.accueil[i]?.x, undefined, undefined], 0, 20, 'easeInSine');
    }
    tween.retardateur(
      this, 21, 31,
      () => {
        this.snd('snd_menu_retour_2').start();
        this.activeBT(true);
        for (let i = 0; i <= u.array.length; i++) {
          const a = this.accueil[i];
          tween.rMouvement(this, u, i, undefined, [undefined, a?.y, a?.z], random(3), 10, 'easeOutBack');
        }
      },
      () => this.startEnterFrame(),
    );
  }

  /** Sortie vers une section : éclatement en X, puis repli en Z, puis en Y. */
  sortieAccueil(funct: () => void): void {
    const { tween, api } = this.rt;
    const u = this.univers;
    delete this.rt.sample.onEnterFrame;
    delete this.E.onEnterFrame;
    this.activeBT(false);
    tween.soundVolume(this.snd('snd_menu_amb_1'), undefined, 0, 0, 30, 'easeInOutSine');
    tween.soundVolume(this.snd('snd_menu_amb_2'), undefined, 0, 0, 30, 'easeInOutSine');
    tween.retardateur(
      this, 1, 15,
      () => {
        this.snd('snd_menu_sortie').start();
        const x = random(2) !== 0 ? -random(350) - 200 : random(350) + 200;
        for (let i = 0; i < u.array.length; i++) {
          tween.rMouvement(this, u, i, undefined, [x, undefined, undefined], random(4), 10, 'easeOutExpo');
        }
      },
      () => {
        this.snd('snd_menu_sortie').start();
        for (let i = 0; i < u.array.length; i++) {
          tween.rMouvement(this, u, i, undefined, [undefined, undefined, 0], i % 4, 10, 'easeOutExpo');
        }
      },
    );
    tween.retardateur(
      this, 25, 30,
      () => {
        this.snd('snd_menu_sortie').start();
        for (let i = 0; i < u.array.length; i++) {
          tween.rMouvement(this, u, i, undefined, [undefined, 0, undefined], 0, 10, 'easeOutExpo');
        }
      },
      () => {
        for (let i = 0; i <= 22; i++) api.remove(`api${i}`);
        this.snd('snd_menu_amb_1').stop();
        this.snd('snd_menu_amb_2').stop();
        funct();
        this.E.removeMovieClip();
      },
    );
  }

  private activeBT(visible: boolean): void {
    for (const bt of this.bts) bt.visible = visible;
  }

  /** Allume les lignes une par une, une image sur deux, avec un son à chaque fois. */
  private activeLignesInTime(nbLigne: number): void {
    const tmp = this.E.createEmptyMovieClip('activeLignesTmp', 9999999);
    let i = 0;
    let a = 0;
    tmp.onEnterFrame = () => {
      if (a++ % 2 === 0) {
        this.snd('snd_menu_intro_2').start();
        this.rt.api.activeEtat(`api${i}`);
        i++;
        if (i >= nbLigne) delete tmp.onEnterFrame;
      }
    };
  }

  private activeLignes(nbLigne: number): void {
    for (let i = 0; i < nbLigne; i++) this.rt.api.activeEtat(`api${i}`);
  }

  private redrawPoints(thickness: number, color: number, alpha: number): void {
    for (const o of this.univers.array) {
      if (!(o instanceof Point3d)) continue;
      const g = o.point.graphics;
      g.clear();
      g.lineStyle(thickness, color, alpha);
      g.lineTo(1, 0);
    }
  }

  /** Les points s'effacent (alpha -4 par image). */
  private desactivePointsInTime(): void {
    const tmp = this.E.createEmptyMovieClip('activePointsTmp', 9999998);
    let alpha = 100;
    tmp.onEnterFrame = () => {
      this.redrawPoints(2, 0x475656, alpha);
      if (alpha > 0) alpha -= 4;
      else delete tmp.onEnterFrame;
    };
  }

  private desactivePoints(): void {
    this.redrawPoints(2, 0x475656, 0);
  }

  /** Frame 2, DoAction_6 : survols des cercles et des boutons. */
  private bindRollOvers(): void {
    const E = this.E;
    [15, 16, 17, 18].forEach((n, k) => {
      const mc = E.child(`api${n}`)!;
      mc.onRollOver = () => this.shakeXCercle3d(109 + 18 * k, n);
    });
    const api12 = E.child('api12')!;
    api12.onRollOver = () => {
      this.eventCercleCentral();
      const s = this.snd('snd_menu_central');
      s.stop();
      s.start();
    };
    for (const bt of this.bts) {
      bt.onRollOver = () => {
        this.shakeXBt(bt.id);
        this.snd('snd_menu_bt').start();
        bt.degrade.x = -50;
        bt.onEnterFrame = () => {
          bt.degrade.x += 22;
          if (bt.degrade.x >= 250) delete bt.onEnterFrame;
        };
      };
      bt.onPress = () => {
        const section = SECTION_BY_BT[bt.id];
        this.sortieAccueil(() => this.onSection(section));
      };
    }
  }

  /**
   * Un petit cercle tremble puis revient en place, et alterne entre les styles 0 et 1.
   * Particularité d'origine conservée : le compteur `tShake` vit dans le scénario de E et n'est
   * jamais remis à zéro ; seul le premier survol tremble 5 images, les suivants une seule.
   */
  private shakeXCercle3d(idInit: number, idApi: number): void {
    const obj = this.rt.api.apiOn.get(`api${idApi}`);
    if (obj) {
      if (obj.styleId === 0) {
        obj.styleId = 1;
        this.snd('snd_menu_cercle_a').start();
      } else {
        obj.styleId = 0;
        this.snd('snd_menu_cercle_b').start();
      }
    }
    const u = this.univers;
    const timer = this.rt.level10.createEmptyMovieClip('timeShake3d', -98963);
    timer.onEnterFrame = () => {
      this.tShake++;
      for (let i = idInit; i <= idInit + 17; i++) {
        u.array[i].position.x = random(20) - 10 + this.accueil[i].x;
        u.array[i].render(u.pers);
      }
      if (this.tShake >= 5) {
        for (let i = idInit; i <= idInit + 17; i++) {
          this.rt.tween.rMouvement(this, u, i, undefined, [this.accueil[i].x, undefined, undefined], 0, 10, 'easeOutSine');
        }
        delete timer.onEnterFrame;
      }
    };
  }

  /** Le cercle central s'opacifie (+50 d'alpha de fond) puis revient au style global en 10 images. */
  private eventCercleCentral(): void {
    const { api, tween } = this.rt;
    const obj = api.apiOn.get('api12');
    if (!obj) return;
    const style = [...api.style[obj.styleId]] as number[];
    api.setLocal('api12', style);
    tween.arrayValue('mvtApiapi12.4', style, 4, style[4] + 50, style[4], 0, 10, 'linearTween', undefined, () =>
      api.setGlobal('api12'),
    );
  }

  private shakeXBt(id: number): void {
    const u = this.univers;
    const x = u.array[id].position.x - (random(20) + 20);
    this.rt.tween.rMouvement(this, u, id, [x, undefined, undefined], [this.accueil[id].x, undefined, undefined], 1, 10, 'easeOutSine');
  }
}
