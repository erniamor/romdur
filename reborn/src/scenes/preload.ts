import { asset, fetchWithProgress } from '../audio/loader';
import type { SoundEntry, WebAudioBank } from '../audio/webaudio';
import { random } from '../engine/easing';
import { Particle3d, Repere3d } from '../engine/space3d';
import { Clip, timelineDepth } from '../flash/clip';
import { editText, staticText, TextField } from '../flash/text';
import type { Runtime } from '../runtime';

const GRIS = 0x666666;
const GRIS_CLAIR = 0xb1b1b1;

/** Symbole « pts » (sprite 3) : disque plein de 2,1 px de rayon. */
function pts(): Clip {
  const mc = new Clip('pts');
  const g = mc.graphics;
  g.beginFill(GRIS, 100);
  g.moveTo(1.5, -1.45);
  g.curveTo(2.1, -0.85, 2.1, 0);
  g.curveTo(2.1, 0.85, 1.5, 1.5);
  g.curveTo(0.85, 2.1, 0, 2.1);
  g.curveTo(-0.85, 2.1, -1.45, 1.5);
  g.curveTo(-2.1, 0.85, -2.1, 0);
  g.curveTo(-2.1, -0.85, -1.45, -1.45);
  g.curveTo(-0.85, -2.1, 0, -2.1);
  g.curveTo(0.85, -2.1, 1.5, -1.45);
  g.endFill();
  return mc;
}

/** Symbole « chargeur » (sprite 16) : libellé à droite, barre de 173,75 px, pourcentage. */
class Chargeur extends Clip {
  readonly nom: TextField;
  readonly progression: TextField;
  readonly barre: Clip;

  constructor(name: string, label: string) {
    super(name);
    this.progression = this.addChildAt(
      editText('progression_txt', { size: 10, color: GRIS, align: 'right' }, [75.45, -1], [-2, -2, 59, 17.9]), 1);
    this.nom = this.addChildAt(
      editText('nom_txt', { text: label, size: 10, color: GRIS, align: 'right' }, [-132.45, -1], [-2, -2, 48, 17.9]), 2);
    this.barre = this.createEmptyMovieClip('barre', 3);
    this.barre.x = -80.45;
    this.barre.y = 8;
    this.barre.graphics.lineStyle(1, 0x4e5e61, 100);
    this.barre.graphics.lineTo(173.75, 0);
    this.barre.xscale = 0;
  }

  set percent(p: number) {
    this.barre.xscale = p;
    this.progression.text = `${p} %`;
  }
}

/**
 * Préchargement (preload.swf) : chargement des données, de l'interface et des sons,
 * avec un petit univers 3D de points qu'on enrichit en cliquant.
 * Retirés à la demande : le lien « romdur.com ».
 */
export class Preload {
  private readonly conteneur: Clip;
  private readonly univ: Clip;
  private readonly univers = new Repere3d(500);
  private nbPts = 0;
  private readonly data: Chargeur;
  private readonly interface: Chargeur;
  private readonly sample: Chargeur;
  private readonly percentSample: TextField;
  private readonly nameSample: TextField;
  private readonly btEntrer: Clip;
  /** `_global.autreLoadingIsFinish` : le premier des deux chargements terminé le met à vrai. */
  private autreLoadingIsFinish = false;
  private readonly offMouseDown: () => void;

  constructor(
    private readonly rt: Runtime,
    private readonly bank: WebAudioBank,
    private readonly onEnter: () => void,
  ) {
    const root = rt.stage.root;

    // conteneur (sprite 19), placé en (355.55, 12.3).
    const c = (this.conteneur = root.createEmptyMovieClip('conteneur', timelineDepth(4)));
    c.x = 355.55;
    c.y = 12.3;
    this.percentSample = c.addChildAt(
      editText('percentSample_txt', { size: 18, color: GRIS_CLAIR, align: 'right' }, [252.45, 352.25], [-2, -2, 66, 69]), 1);
    this.nameSample = c.addChildAt(
      editText('nameSample_txt', { size: 12, color: GRIS_CLAIR, align: 'right' }, [22.45, 362.25], [-2, -2, 217.95, 33.45]), 2);
    this.interface = this.place(new Chargeur('chargeur_interface', 'interface'), 3, 134.45, 341.25);
    this.sample = this.place(new Chargeur('chargeur_sample', 'samples'), 7, 134.45, 356.25);
    c.addChildAt(staticText('chargement', 'chargement', 12, GRIS, 68 + 35, 300.75 + 11, 72.3), 11);
    c.addChildAt(staticText('cliquez', "cliquez pour ajouter d'autres points", 14, 0x333333, 389.65 + 9, 2 + 13, 222.25), 12);
    this.data = this.place(new Chargeur('chargeur_data', 'données'), 13, 134.45, 326.25);

    // btEntrer (sprite 7) : zone transparente + « entrer ».
    const bt = (this.btEntrer = c.createEmptyMovieClip('btEntrer', 17));
    bt.x = 50.5;
    bt.y = 376.35;
    bt.addChildAt(staticText('entrer', 'entrer', 12, GRIS, 2 + 67, 2 + 11, 41.05), 2);
    bt.hitArea = { x: 52.9, y: 2.35, w: 62, h: 19 };
    bt.visible = false;
    bt.onRollOver = () => {
      const s = this.bank.get('snd_multi_evt_1');
      s.stop();
      s.start();
    };
    bt.onRelease = () => this.enter();

    // Univers de points (sprite 1 « univ »), au centre, au-dessus de tout.
    const u = (this.univ = root.createEmptyMovieClip('univ', 66666));
    u.x = 490;
    u.y = 365;
    this.univers.array[0] = new Particle3d(-200, 200, 0, u, pts, 'pts', 0);
    this.univers.array[0].position.rotateZ(random(360));
    this.univers.array[0].render(500);
    this.offMouseDown = rt.stage.onMouseDown(() => this.addPoint());
    u.onEnterFrame = () => this.univers.rotateXY(u.ymouse / 100, u.xmouse / 100);

    void this.load();
  }

  private place<T extends Clip>(clip: T, depth: number, x: number, y: number): T {
    this.conteneur.addChildAt(clip, depth);
    clip.x = x;
    clip.y = y;
    return clip;
  }

  /** onMouseDown : un point de plus sous la souris ; au-delà de 50, on recommence au premier. */
  private addPoint(): void {
    const u = this.univ;
    this.nbPts = this.nbPts < 50 ? this.nbPts + 1 : 0;
    u.child(`pts_${this.nbPts}`)?.removeMovieClip();
    this.univers.array[this.nbPts] = new Particle3d(u.xmouse, 0 - u.ymouse, 0, u, pts, 'pts', this.nbPts);
  }

  private async load(): Promise<void> {
    this.data.percent = 0;
    this.interface.percent = 0;
    this.sample.percent = 0;

    // « interface » : ici, les polices (le code est déjà chargé).
    void document.fonts.ready.then(() => {
      this.interface.percent = 100;
      this.loadingDone();
    });

    // « données » : la table des sons.
    let entries: SoundEntry[];
    try {
      const buf = await fetchWithProgress(asset('data/sounds.json'), (r) => (this.data.percent = Math.floor(r * 100)));
      entries = JSON.parse(new TextDecoder().decode(buf));
    } catch (e) {
      console.error('Chargement des données impossible', e);
      return;
    }
    this.data.percent = 100;
    this.bank.setEntries(entries);

    // « samples » : chargement séquentiel, avec le nom et le pourcentage du son en cours.
    for (let i = 0; i < entries.length; i++) {
      const { name, file } = entries[i];
      this.sample.percent = Math.floor(((i + 1) / entries.length) * 100);
      this.nameSample.text = name;
      if (!this.bank.hasBuffer(file)) {
        try {
          const buf = await fetchWithProgress(asset(`sounds/${file}.mp3`), (r) => {
            this.percentSample.text = `${Math.floor(r * 100)} %`;
          });
          await this.bank.decode(file, buf);
        } catch (e) {
          console.warn(`Son ${name} (${file}) indisponible`, e);
        }
      }
      this.nameSample.text = '';
      this.percentSample.text = '';
    }
    this.loadingDone();
  }

  /** Le second des deux chargements (interface, sons) terminé fait apparaître « entrer ». */
  private loadingDone(): void {
    if (!this.autreLoadingIsFinish) {
      this.autreLoadingIsFinish = true;
      return;
    }
    this.btEntrer.visible = true;
    this.bank.get('snd_multi_evt_1').start();
  }

  /** « entrer » : les points filent vers le fond, le texte s'efface, puis l'interface démarre. */
  private enter(): void {
    const { tween } = this.rt;
    delete this.univ.onEnterFrame;
    const n = this.univers.array.length;
    for (let q = 0; q < n; q++) {
      tween.rMouvement(this, this.univers, q, undefined, [0, 0, 1000], q, 15, 'easeInSine');
    }
    tween.mouvement(this.conteneur, 'alpha', 100, 0, 0, 10 + n, 'easeInOutSine');
    tween.retardateur(this, 15 + n, 2, () => {
      this.offMouseDown();
      this.univ.removeMovieClip();
      this.conteneur.removeMovieClip();
      this.onEnter();
    });
    delete this.btEntrer.onRelease;
  }
}
