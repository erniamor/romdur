import type { ApiStyle } from '../engine/api';
import { random } from '../engine/easing';
import { Clip, timelineDepth } from '../flash/clip';
import { editText, staticText, TextField } from '../flash/text';
import type { Runtime } from '../runtime';
import type { Degrade } from '../symbols/degrade';
import { chargePresets, enregistrePreset, type Preset } from './presets';

const GRIS = 0x666666;
const ENCRE = 0x181731;
const ENCRE_SURVOL = 0x494996;
/** Course d'un curseur : de -63 (haut) à 63 (bas). */
const COURSE = 63;

// ———————————————————————————— dessins

function cercle(g: Clip['graphics'], r: number): void {
  const k = 0.4142 * r, d = 0.7071 * r;
  g.moveTo(r, 0);
  g.curveTo(r, k, d, d);
  g.curveTo(k, r, 0, r);
  g.curveTo(-k, r, -d, d);
  g.curveTo(-r, k, -r, 0);
  g.curveTo(-r, -k, -d, -d);
  g.curveTo(-k, -r, 0, -r);
  g.curveTo(k, -r, d, -d);
  g.curveTo(r, -k, r, 0);
}

function rect(g: Clip['graphics'], x1: number, y1: number, x2: number, y2: number): void {
  g.moveTo(x1, y1);
  g.lineTo(x2, y1);
  g.lineTo(x2, y2);
  g.lineTo(x1, y2);
  g.lineTo(x1, y1);
}

/** Pastilles « potarCase » (sprite 160) : 1 épaisseur, 2 rouge, 3 vert, 4 bleu, 5 alpha. */
type Pastille = 1 | 2 | 3 | 4 | 5;

function potarCase(type: Pastille): Clip {
  const mc = new Clip('potarCase');
  const g = mc.graphics;
  g.lineStyle(0.5, GRIS, 100);
  g.beginFill(0x3333ff, 0);
  cercle(g, 4.45);
  g.endFill();
  g.lineStyle();
  if (type === 1) {
    g.beginFill(0x333333, 100);
    rect(g, -2.1, -2, 1.95, 2.25);
    rect(g, -1.7, -1.75, 1.5, 1.8);
    g.endFill();
  } else if (type === 5) {
    g.beginFill(GRIS, 100);
    rect(g, -1.9, -2, 2.1, 2.05);
    g.endFill();
  } else {
    g.beginFill({ 2: 0xcc3300, 3: 0x339933, 4: 0x333399 }[type], 100);
    cercle(g, 1.65);
    g.endFill();
  }
  return mc;
}

/** Bouton texte (sprite 187) : change de teinte au survol, avec un petit son. */
function boutonTexte(rt: Runtime, name: string, label: string, onRelease: () => void): Clip {
  const mc = new Clip(name);
  const txt = mc.addChildAt(editText('_txt', { text: label, size: 12, color: ENCRE, align: 'center' }, [-37.5, 2], [-2, -2, 77, 17.1]), 1);
  mc.onRollOver = () => {
    rt.sounds.get('snd_glob_text_over').start();
    txt.color = ENCRE_SURVOL;
  };
  mc.onRollOut = () => (txt.color = ENCRE);
  mc.onRelease = onRelease;
  return mc;
}

// ———————————————————————————— curseurs

/**
 * Curseur vertical (sprites 166 et 168) : une pastille ; en appuyant dessus, la réglette et le
 * curseur apparaissent et suivent la souris (startDrag borné à ±63), la valeur s'affiche à côté.
 */
class Curseur extends Clip {
  readonly curseur: Clip;
  readonly valeur: TextField;
  private readonly ligne: Clip;

  constructor(name: string, type: Pastille, onPress: () => void, onRelease: () => void) {
    super(name);
    const pastille = this.addChildAt(potarCase(type), 1);
    pastille.xscale = pastille.yscale = 127.5;
    pastille.y = 0.05;
    this.ligne = this.createEmptyMovieClip('potarLigne', 4);
    this.ligne.x = 5.65;
    this.ligne.graphics.lineStyle(2, GRIS, 100);
    this.ligne.graphics.moveTo(0, -63.45);
    this.ligne.graphics.lineTo(0, 63.5);
    this.curseur = this.createEmptyMovieClip('potarCurseur', 6);
    this.curseur.x = 7;
    this.curseur.graphics.lineStyle(2, GRIS, 100);
    this.curseur.graphics.moveTo(5.7, 5.7);
    this.curseur.graphics.lineTo(0, 0);
    this.curseur.graphics.lineTo(5.7, -5.7);
    this.valeur = this.curseur.addChildAt(editText('_txt', { size: 12, color: 0x000000 }, [10.5, -7.6], [-2, -2, 27.5, 17.1]), 2);
    this.ligne.alpha = this.curseur.alpha = 0;

    let depart = { souris: 0, curseur: 0 };
    pastille.onPress = () => {
      onPress();
      depart = { souris: this.ymouse, curseur: this.curseur.y };
      this.ligne.alpha = this.curseur.alpha = 100;
      this.onEnterFrame = () => {
        const y = depart.curseur + (this.ymouse - depart.souris);
        this.curseur.y = Math.max(-COURSE, Math.min(COURSE, y));
      };
    };
    pastille.onRelease = pastille.onReleaseOutside = () => {
      delete this.onEnterFrame;
      onRelease();
      this.ligne.alpha = this.curseur.alpha = 0;
    };
  }

  get y0(): number {
    return this.curseur.y;
  }
}

const COMPOSANTES = ['bt', 'br', 'bv', 'bb', 'ba', 'fr', 'fv', 'fb', 'fa'] as const;
type Composante = (typeof COMPOSANTES)[number];

const epaisseur = (y: number) => Math.round(-y / 12.7 + 5);
const couleur = (y: number) => Math.round(-y * 2 + 128);
const opacite = (y: number) => Math.round((-y * 100) / 127 + 50);
const rgb = (r: number, v: number, b: number) => ((r & 255) << 16) | ((v & 255) << 8) | (b & 255);
const composantes = (c: number) => [(c >> 16) & 255, (c >> 8) & 255, c & 255];

/** Réglages d'un style de tracé (sprite 169) : épaisseur, couleur et alpha du trait, couleur et alpha du fond. */
class ColorControl extends Clip {
  readonly curseurs = {} as Record<Composante, Curseur>;

  constructor(name: string, private readonly style: ApiStyle, onPress: () => void) {
    super(name);
    const place: Record<Composante, [number, number, Pastille]> = {
      fr: [-23.55, 9.85, 2], fv: [-3.55, 9.85, 3], fb: [16.45, 9.85, 4], fa: [36.45, 9.85, 5],
      bt: [-43.55, -9.8, 1], br: [-23.55, -9.8, 2], bv: [-3.55, -9.8, 3], bb: [16.45, -9.8, 4], ba: [36.45, -9.8, 5],
    };
    let depth = 1;
    for (const k of ['fr', 'fv', 'fb', 'fa', 'bt', 'br', 'bv', 'bb', 'ba'] as const) {
      const [x, y, type] = place[k];
      const c = this.addChildAt(new Curseur(`${k}_slider`, type, () => {
        onPress();
        this.activeControl();
      }, () => this.desactiveControl()), depth);
      depth += 7;
      c.x = x;
      c.y = y;
      this.curseurs[k] = c;
    }
    this.actualiseControl();
  }

  /** Tant que le contrôle est actif, les curseurs règlent le style à chaque image. */
  activeControl(): void {
    this.onEnterFrame = () => {
      const v = (k: Composante) => this.curseurs[k].y0;
      const bt = epaisseur(v('bt'));
      const b = [couleur(v('br')), couleur(v('bv')), couleur(v('bb'))];
      const ba = opacite(v('ba'));
      const f = [couleur(v('fr')), couleur(v('fv')), couleur(v('fb'))];
      const fa = opacite(v('fa'));
      const textes: Record<Composante, number> = { bt, br: b[0], bv: b[1], bb: b[2], ba, fr: f[0], fv: f[1], fb: f[2], fa };
      for (const k of COMPOSANTES) this.curseurs[k].valeur.text = String(textes[k]);
      this.style[0] = bt;
      this.style[1] = rgb(b[0], b[1], b[2]);
      this.style[2] = ba;
      this.style[3] = rgb(f[0], f[1], f[2]);
      this.style[4] = fa;
    };
  }

  desactiveControl(): void {
    delete this.onEnterFrame;
  }

  /** Place les curseurs d'après le style courant (actualiseControl). */
  private actualiseControl(): void {
    const [bt, bc, ba, fc, fa] = this.style;
    const b = composantes(Number(bc)), f = composantes(Number(fc));
    const vals: Record<Composante, [number, number]> = {
      bt: [bt as number, (bt as number) * 12.7], br: [b[0], b[0] / 2], bv: [b[1], b[1] / 2], bb: [b[2], b[2] / 2],
      ba: [ba as number, ((ba as number) * 127) / 100], fr: [f[0], f[0] / 2], fv: [f[1], f[1] / 2], fb: [f[2], f[2] / 2],
      fa: [fa as number, ((fa as number) * 127) / 100],
    };
    for (const k of COMPOSANTES) {
      this.curseurs[k].valeur.text = String(vals[k][0]);
      this.curseurs[k].curseur.y = 64 - vals[k][1];
    }
  }
}

const DEGRADE = ['ra', 'va', 'ba', 'rb', 'vb', 'bb'] as const;
type CompDegrade = (typeof DEGRADE)[number];

/** Réglages du dégradé de fond (sprite 167) : couleur du centre (a) en bas, du bord (b) en haut. */
class DegradeControl extends Clip {
  readonly curseurs = {} as Record<CompDegrade, Curseur>;

  constructor(private readonly degrade: Degrade, onPress: () => void) {
    super('colorControl_degrade');
    const place: Record<CompDegrade, [number, number, Pastille]> = {
      rb: [-23.5, 3.05, 2], vb: [-3.5, 3.05, 3], bb: [16.5, 3.05, 4],
      ra: [-23.45, 23.05, 2], va: [-3.45, 23.05, 3], ba: [16.55, 23.05, 4],
    };
    let depth = 1;
    for (const k of ['rb', 'vb', 'bb', 'ra', 'va', 'ba'] as const) {
      const [x, y, type] = place[k];
      const c = this.addChildAt(new Curseur(`${k}_mc`, type, () => {
        onPress();
        this.activeControl();
      }, () => this.desactiveControl()), depth);
      depth += 7;
      c.x = x;
      c.y = y;
      this.curseurs[k] = c;
    }
    const a = composantes(Number(degrade.colors[0])), b = composantes(Number(degrade.colors[1]));
    const vals: Record<CompDegrade, number> = { ra: a[0], va: a[1], ba: a[2], rb: b[0], vb: b[1], bb: b[2] };
    for (const k of DEGRADE) {
      this.curseurs[k].valeur.text = String(vals[k]);
      this.curseurs[k].curseur.y = 64 - vals[k] / 2;
    }
  }

  activeControl(): void {
    this.onEnterFrame = () => {
      const v = {} as Record<CompDegrade, number>;
      for (const k of DEGRADE) {
        v[k] = couleur(this.curseurs[k].y0);
        this.curseurs[k].valeur.text = String(v[k]);
      }
      this.degrade.colors = [rgb(v.ra, v.va, v.ba), rgb(v.rb, v.vb, v.bb)];
      this.degrade.update();
    };
  }

  desactiveControl(): void {
    delete this.onEnterFrame;
  }
}

// ———————————————————————————— panneau

/**
 * Éditeur de thème (colorPatch, sprite 195) et ses compagnons : le bouton « outil » (option_btn),
 * le texte du thème en bas à droite (theme_mc) et le dialogue de sauvegarde (option_quest_mc).
 *
 * Les présélections viennent de public/data/themes.json et du navigateur (à la place de MySQL).
 */
export class EditeurTheme {
  readonly patch: Clip;
  readonly optionBtn: Clip;
  private readonly themeMc: Clip;
  private readonly themeTxt: TextField;
  private readonly controls: ColorControl[];
  private readonly degradeControl: DegradeControl;
  private readonly presetMc: Clip;
  private readonly pageTxt: TextField;
  private readonly prev: Clip;
  private readonly next: Clip;
  private readonly dialogue: Dialogue;
  private presets: Preset[] = [];
  /** `_global.presetActuel` : indice du thème appliqué, -1 aléatoire, -2 modifié. */
  private presetActuel = 0;
  private page = 0;
  private ouvert = false;

  constructor(private readonly rt: Runtime, degrade: Degrade) {
    const L10 = rt.level10;

    // Texte du thème, en bas à droite (theme_mc), visible quand le panneau est ouvert.
    this.themeMc = L10.createEmptyMovieClip('theme_mc', timelineDepth(177));
    this.themeMc.x = 970.95;
    this.themeMc.y = 715.55;
    this.themeMc.alpha = 0;
    this.themeTxt = this.themeMc.addChildAt(
      editText('theme_txt', { size: 14, color: 0x333333, align: 'right' }, [-621.85, -7.95], [-2, -2, 621.85, 17.9]), 1);

    // Le panneau (colorPatch), rangé hors de la scène à droite.
    const p = (this.patch = L10.createEmptyMovieClip('colorPatch', timelineDepth(14)));
    p.x = 1100.25;
    p.y = 193.55;
    p.visible = false;
    const fond = p.createEmptyMovieClip('colorPatchFond', 1);
    fond.x = -0.25;
    fond.y = 110.45;
    fond.alpha = 30;
    fond.graphics.lineStyle(1, 0x333333, 100);
    fond.graphics.beginFill(0xffffff, 100);
    rect(fond.graphics, 0, -110, 112.25, 244.05);
    fond.graphics.endFill();
    // Le fond absorbe les clics : un clic dans le panneau n'est pas un « clic dans le vide ».
    fond.hitArea = { x: 0, y: -110, w: 112.25, h: 354.05 };
    fond.useHandCursor = false;
    fond.onPress = () => {};
    const traits = p.createEmptyMovieClip('traits', 3);
    traits.graphics.lineStyle(0, GRIS, 100);
    traits.graphics.moveTo(6.25, 169.8);
    traits.graphics.lineTo(105.75, 169.8);
    traits.graphics.moveTo(6.25, 218.8);
    traits.graphics.lineTo(105.75, 218.8);

    const sauver = p.addChildAt(boutonTexte(rt, 'saveOption_btn', 'sauvegarder', () => this.dialogue.ouvre()), 4);
    sauver.x = 56.1;
    sauver.y = 174.55;
    const hasard = p.addChildAt(boutonTexte(rt, 'randomOption_btn', 'aléatoire', () => {
      this.presetActuel = -1;
      this.updateThemeText(this.presetActuel);
      this.startRandomOption();
    }), 6);
    hasard.x = 56.1;
    hasard.y = 193.65;
    p.addChildAt(editText('titre', { text: 'Configuration', size: 13, color: 0x333333, align: 'center' }, [6.25, 6.9], [-2, -2, 101.05, 17.1]), 8);

    const modifie = () => {
      this.presetActuel = -2;
      this.updateThemeText(this.presetActuel);
    };
    this.controls = [0, 1].map((id) => {
      const c = p.addChildAt(new ColorControl(`colorControl${id}`, rt.api.style[id], modifie), id === 0 ? 9 : 67);
      c.x = 56.7;
      c.y = id === 0 ? 47.95 : 94.05;
      return c;
    });
    this.degradeControl = p.addChildAt(new DegradeControl(degrade, modifie), 125);
    this.degradeControl.x = 56.65;
    this.degradeControl.y = 127.15;

    // Présélections (preset_mc, sprite 194).
    const pm = (this.presetMc = p.createEmptyMovieClip('preset_mc', 162));
    pm.x = 55.75;
    pm.y = 221.6;
    pm.addChildAt(staticText('presel', 'Présélections', 13, 0x000000, -53.25 + 16, 2 + 12, 85.3), 1);
    this.prev = pm.addChildAt(flechePage(), 2, 'presetPrevPage_btn');
    this.prev.x = -40.85;
    this.prev.y = 9.85;
    this.next = pm.addChildAt(flechePage(), 4, 'presetNextPage_btn');
    this.next.x = 40.9;
    this.next.y = 10.25;
    this.next.xscale = this.next.yscale = -100;
    this.pageTxt = pm.addChildAt(editText('page_txt', { size: 10, color: 0x000000, align: 'right' }, [29.25, 118.6], [-5.8, -2, 23.5, 14.55]), 6);

    // Bouton « outil » (option_btn) : ouvre et ferme le panneau.
    this.optionBtn = L10.addChildAt(boutonOutil(), timelineDepth(12));
    this.optionBtn.x = 930.55;
    this.optionBtn.y = 22.85;
    this.optionBtn.onRelease = () => this.bascule();

    this.dialogue = new Dialogue(rt, () => this.recupOptionValue(), () => void this.connectionDataOption());
    void this.connectionDataOption();
  }

  private bascule(): void {
    const { tween } = this.rt;
    if (this.ouvert) {
      tween.mouvement(this.themeMc, 'alpha', undefined, 0, 0, 10, 'easeInOutSine');
      tween.mouvement(this.patch, 'x', undefined, 1100, 0, 10, 'easeInCubic', undefined, () => {
        // Rangé hors scène : masqué, sinon visible sur les écrans plus larges que 980×730.
        if (!this.ouvert) this.patch.visible = false;
      });
      this.ouvert = false;
    } else {
      this.patch.visible = true;
      tween.mouvement(this.themeMc, 'alpha', undefined, 100, 0, 10, 'easeInOutSine');
      tween.mouvement(this.patch, 'x', undefined, 865, 0, 10, 'easeOutCubic');
      this.ouvert = true;
    }
  }

  private async connectionDataOption(): Promise<void> {
    this.presets = await chargePresets();
    this.page = 0;
    this.actuPreset();
  }

  private get pageTotal(): number {
    return Math.max(1, Math.ceil(this.presets.length / 6));
  }

  private actuPreset(): void {
    const pm = this.presetMc;
    this.pageTxt.text = `${this.page + 1} / ${this.pageTotal}`;
    const liste = pm.createEmptyMovieClip('presetList', 222223);
    const fin = Math.min(this.page * 6 + 6, this.presets.length);
    for (let i = this.page * 6, y = 20; i < fin; i++, y += 15) {
      const bt = liste.addChildAt(this.presetListBt(i), i, `presetListBt${i}`);
      bt.y = y;
    }
    this.etatFleche(this.prev, this.page > 0, () => this.page--);
    this.etatFleche(this.next, this.page + 1 < this.pageTotal, () => this.page++);
  }

  private etatFleche(bt: Clip, actif: boolean, change: () => void): void {
    (bt as Fleche).actif(actif);
    if (actif) {
      bt.onRelease = () => {
        change();
        this.actuPreset();
      };
    } else delete bt.onRelease;
  }

  /** Une ligne de la liste (presetListBt, sprite 154) : survol = aperçu du nom, clic = application. */
  private presetListBt(id: number): Clip {
    const preset = this.presets[id];
    const bt = new Clip('presetListBt');
    const txt = bt.addChildAt(editText('_txt', { text: preset.nom, size: 12, color: ENCRE, align: 'center' }, [-54.1, 2], [-2, -2, 110.25, 17.1]), 1);
    bt.onRollOver = () => {
      this.themeTxt.text = `"${preset.nom}" enregistré par "${preset.pseudo}" le ${preset.date}`;
      this.rt.sounds.get('snd_glob_text_over').start();
      txt.color = ENCRE_SURVOL;
    };
    bt.onRollOut = () => {
      this.updateThemeText(this.presetActuel);
      txt.color = ENCRE;
    };
    bt.onRelease = () => {
      this.rt.sounds.get('snd_glob_text_press').start();
      this.applicPreset(id);
    };
    return bt;
  }

  private updateThemeText(id: number): void {
    if (id === -1) this.themeTxt.text = 'theme aléatoire';
    else if (id < -1) this.themeTxt.text = 'theme modifié';
    else {
      const p = this.presets[id];
      this.themeTxt.text = p ? `theme actuel : "${p.nom}" enregistré par "${p.pseudo}" le ${p.date}` : '';
    }
  }

  private tousLesCurseurs(): Curseur[] {
    return [
      ...this.controls.flatMap((c) => COMPOSANTES.map((k) => c.curseurs[k])),
      ...DEGRADE.map((k) => this.degradeControl.curseurs[k]),
    ];
  }

  /** Les 24 curseurs glissent vers leurs cibles en 25 images, les réglages suivent. */
  private anime(cibles: number[]): void {
    for (const c of this.controls) c.activeControl();
    this.degradeControl.activeControl();
    this.tousLesCurseurs().forEach((c, i) => this.rt.tween.mouvement(c.curseur, 'y', undefined, cibles[i], 0, 25, 'linearTween'));
    this.rt.tween.retardateur(this, 26, 2, () => {
      for (const c of this.controls) c.desactiveControl();
      this.degradeControl.desactiveControl();
    });
  }

  private applicPreset(id: number): void {
    this.presetActuel = id;
    this.updateThemeText(id);
    this.anime(this.presets[id].config);
  }

  /** « aléatoire » : des réglages tirés au hasard dans la moitié centrale de chaque course. */
  private startRandomOption(): void {
    this.anime(this.tousLesCurseurs().map((_, i) => (i === 0 || i === 9 ? random(66) - 34 : random(64) - 32)));
  }

  /** Positions des 24 curseurs : le format d'un thème. */
  private recupOptionValue(): number[] {
    return this.tousLesCurseurs().map((c) => c.curseur.y);
  }
}

type Fleche = Clip & { actif(on: boolean): void };

/** Flèche de page (sprite 192) : grise et petite si inactive, foncée si active. */
function flechePage(): Fleche {
  const mc = new Clip('fleche') as Fleche;
  mc.actif = (on: boolean) => {
    const g = mc.graphics;
    g.clear();
    if (on) {
      g.beginFill(0x333333, 100);
      g.moveTo(-3.05, 0);
      g.lineTo(3.1, -6.15);
      g.lineTo(3.1, 6.2);
      g.lineTo(-3.05, 0);
    } else {
      g.beginFill(0xcccccc, 100);
      g.moveTo(-2.2, 0);
      g.lineTo(2.2, -4.35);
      g.lineTo(2.2, 4.4);
      g.lineTo(-2.2, 0);
    }
    g.endFill();
    mc.useHandCursor = on;
  };
  mc.hitArea = { x: -4, y: -7, w: 8, h: 14 };
  mc.actif(false);
  return mc;
}

/** Bouton « outil » (option_btn, sprite 171) : un marteau dans un carré, grossit au survol. */
function boutonOutil(): Clip {
  const mc = new Clip('option_btn');
  const g = mc.graphics;
  g.lineStyle(1, 0x333333, 100);
  g.beginFill(0xffffff, 50);
  rect(g, -7.6, -7.65, 9.15, 7.7);
  g.endFill();
  g.lineStyle();
  g.beginFill(0x333333, 100);
  g.moveTo(3.6, -5.8);
  g.curveTo(0.6, -3.2, -1.95, -6.15);
  g.lineTo(-6.45, -1.6);
  g.lineTo(-2.5, 2.3);
  g.lineTo(4.55, -4.8);
  g.lineTo(3.6, -5.8);
  g.endFill();
  g.lineStyle(2, 0x000000, 100);
  g.moveTo(1.1, -0.25);
  g.lineTo(6.95, 5.6);
  mc.hitArea = { x: -7.6, y: -7.65, w: 16.75, h: 15.35 };
  mc.onRollOver = () => (mc.xscale = mc.yscale = 120);
  mc.onRollOut = () => (mc.xscale = mc.yscale = 100);
  return mc;
}

// ———————————————————————————— dialogue de sauvegarde

/**
 * Dialogue de sauvegarde (option_quest_mc, sprite 145) : nom du thème et nom du créateur
 * (15 caractères), puis « Enregistrement ok ». Les champs sont de vrais champs HTML posés sur le
 * canvas, pour le clavier et le mobile.
 *
 * Corrigé : « annuler » renvoyait vers un clip inexistant, et le dialogue ne pouvait plus se rouvrir.
 */
class Dialogue {
  private readonly mc: Clip;
  private readonly masque: Clip;
  private readonly form: Clip;
  private readonly ok: Clip;
  private readonly champs: HTMLInputElement[];
  /** Le focus attend que le dialogue soit ouvert : un champ encore masqué ne peut pas le recevoir. */
  private focusEnAttente = false;

  constructor(
    private readonly rt: Runtime,
    private readonly valeurs: () => number[],
    private readonly recharge: () => void,
  ) {
    const mc = (this.mc = rt.level10.createEmptyMovieClip('option_quest_mc', 99999999));
    mc.x = 490;
    mc.y = 365;
    mc.visible = false;
    this.masque = mc.createEmptyMovieClip('flash_quest_mask', 1);
    this.masque.graphics.beginFill(0x006633, 100);
    rect(this.masque.graphics, -178.95, -88, 179, 88);
    this.masque.graphics.endFill();
    const c = mc.createEmptyMovieClip('contenu', 2);
    c.setMask(this.masque);
    c.graphics.lineStyle(1, GRIS, 100);
    c.graphics.beginFill(0xe2e2e2, 82);
    rect(c.graphics, -166, -77, 165.95, 77);
    c.graphics.endFill();
    // Le fond absorbe les clics (pas de « clic dans le vide » à travers le dialogue).
    c.hitArea = { x: -166, y: -77, w: 332, h: 154 };
    c.useHandCursor = false;
    c.onPress = () => {};

    const f = (this.form = mc.createEmptyMovieClip('form', 3));
    f.setMask(this.masque);
    f.addChildAt(staticText('titre', 'Sauvegarde de configuration', 17, 0x333333, -145.95 + 41, -57.05 + 16, 224), 1);
    f.addChildAt(staticText('l1', 'nom du theme :', 15, 0x333333, -145.95 + 26, -27.05 + 14, 114), 2);
    f.addChildAt(staticText('l2', 'nom du créateur :', 15, 0x333333, -145.95 + 14, -2.05 + 14, 126), 3);
    const non = f.addChildAt(this.bouton('non_btn', 'annuler', () => this.ferme(() => this.etat(1))), 4);
    non.x = -128.95;
    non.y = 38;
    const oui = f.addChildAt(this.bouton('oui_btn', 'continuer', () => this.valide()), 5);
    oui.x = 55;
    oui.y = 38;

    this.ok = mc.createEmptyMovieClip('ok', 4);
    this.ok.setMask(this.masque);
    this.ok.addChildAt(staticText('ok', 'Enregistrement ok', 17, 0x333333, -145.95 + 79, -11.05 + 16, 148), 1);

    this.champs = [0, 1].map(() => {
      const input = document.createElement('input');
      input.type = 'text';
      input.maxLength = 15;
      input.autocomplete = 'off';
      input.spellcheck = false;
      Object.assign(input.style, {
        position: 'fixed', display: 'none', boxSizing: 'border-box', padding: '0 2px', margin: '0',
        border: 'none', borderBottom: '1px solid #999', background: 'transparent', outline: 'none',
        color: '#333', fontFamily: '"Libre Franklin", sans-serif', fontWeight: '500',
      });
      input.addEventListener('keydown', (e) => {
        if (e.key === 'Enter') this.valide();
        if (e.key === 'Escape') this.ferme(() => this.etat(1));
      });
      document.body.append(input);
      return input;
    });
  }

  private bouton(name: string, label: string, onRelease: () => void): Clip {
    const bt = new Clip(name);
    bt.hitArea = { x: 0, y: 0, w: 74, h: 20 };
    bt.addChildAt(new TextField('label', { text: label, size: 16, color: 0x333333, align: 'center', width: 74 }), 1).y = 0;
    bt.onRelease = onRelease;
    return bt;
  }

  /** gotoAndStop : 1 caché, 2 formulaire, 3 « Enregistrement ok ». */
  private etat(frame: 1 | 2 | 3): void {
    this.mc.visible = frame !== 1;
    this.form.visible = frame === 2;
    this.ok.visible = frame === 3;
    for (const c of this.champs) c.style.display = frame === 2 ? 'block' : 'none';
    if (frame === 2) {
      this.place();
      this.mc.onEnterFrame = () => this.place();
      this.focusEnAttente = true;
    } else delete this.mc.onEnterFrame;
    if (frame !== 1) {
      this.masque.yscale = 0;
      this.rt.tween.mouvement(this.masque, 'yscale', 0, 100, 0, 6, 'easeOutSine');
    }
  }

  ouvre(): void {
    for (const c of this.champs) c.value = '';
    this.etat(2);
  }

  /** Les champs HTML suivent la scène (redimensionnement, plein écran) et le masque qui s'ouvre. */
  private place(): void {
    const ouvert = this.masque.yscale >= 99;
    this.champs.forEach((input, i) => {
      const r = this.rt.stage.stageToClient(490 - 9.95 - 2, 365 + (i === 0 ? -27.05 : -2.05) - 2, 151.95, 21);
      Object.assign(input.style, {
        left: `${r.left}px`, top: `${r.top}px`, width: `${r.width}px`, height: `${r.height}px`,
        fontSize: `${15 * r.scale}px`, visibility: ouvert ? 'visible' : 'hidden',
      });
    });
    if (ouvert && this.focusEnAttente) {
      this.focusEnAttente = false;
      this.champs[0].focus();
    }
  }

  private ferme(ensuite: () => void): void {
    for (const c of this.champs) {
      c.style.display = 'none';
      c.blur();
    }
    delete this.mc.onEnterFrame;
    this.rt.tween.mouvement(this.masque, 'yscale', 100, 0, 0, 6, 'easeOutSine');
    this.rt.tween.retardateur(this, 7, 2, ensuite);
  }

  private valide(): void {
    const nom = this.champs[0].value.trim() || 'sans nom';
    const pseudo = this.champs[1].value.trim() || 'anonyme';
    enregistrePreset(nom, pseudo, this.valeurs());
    this.ferme(() => {
      this.etat(3);
      this.rt.tween.retardateur(this, 15, 7, () => this.rt.tween.mouvement(this.masque, 'yscale', 100, 0, 0, 6, 'easeOutSine'), () => {
        this.recharge();
        this.etat(1);
      });
    });
  }
}
