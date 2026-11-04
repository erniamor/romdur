import { easing, type EasingName, int } from './easing';
import { type Repere3d, type Vec3, Vector3d } from './space3d';

/** Son pilotable par le moteur (volume 0–100, peut dépasser 100 ; panoramique -100…100). */
export interface TweenableSound {
  setVolume(v: number): void;
  getVolume(): number;
  setPan(p: number): void;
  getPan(): number;
}

type Callback = (this: Mouv, cible: unknown) => void;

interface Mouv {
  name: string;
  a: number;
  duree: number;
  cible: unknown;
  update(m: Mouv): void;
  onStart?: Callback;
  onStop?: Callback;
}

type Axes = [number | undefined, number | undefined, number | undefined];
type PartialVec = { x?: number; y?: number; z?: number };

const ids = new WeakMap<object, number>();
let nextId = 1;
/** Identifiant stable d'un objet, pour construire les clés uniques des mouvements. */
function uid(o: object): number {
  let id = ids.get(o);
  if (!id) ids.set(o, (id = nextId++));
  return id;
}

/**
 * Moteur d'animation « MoteurMv » (frame 2 d'interface.swf).
 *
 * - Tout est compté en images (25 i/s).
 * - Un mouvement avec délai attend dans `attente[image]` ; à son départ il remplace le mouvement
 *   actif de même nom, puis `onStart` est appelé. Sans délai, il remplace directement et
 *   `onStart` n'est jamais appelé (comportement d'origine).
 * - À chaque image : `a++`, valeur = easing(a, départ, variation, durée) ; à `a == durée`,
 *   `onStop` est appelé puis le mouvement est supprimé (même s'il vient d'être remplacé par onStop).
 * - Comme le for…in de Flash 6, les mouvements actifs sont parcourus du plus récent au plus ancien.
 */
export class TweenEngine {
  curFrame = -1;
  private readonly mouvs = new Map<string, Mouv>();
  private readonly attente = new Map<number, Mouv[]>();

  tick = (): void => {
    this.curFrame++;
    const waiting = this.attente.get(this.curFrame);
    if (waiting) {
      for (const m of waiting) {
        if (!m.cible) continue;
        this.mouvs.set(m.name, m);
        m.onStart?.call(m, m.cible);
      }
      this.attente.delete(this.curFrame);
    }
    for (const key of [...this.mouvs.keys()].reverse()) {
      const m = this.mouvs.get(key);
      if (!m) continue;
      m.a++;
      m.update(m);
      if (m.a === m.duree) {
        m.onStop?.call(m, m.cible);
        this.mouvs.delete(key);
      }
    }
  };

  /** Annule tous les mouvements actifs et en attente. */
  reset(): void {
    this.mouvs.clear();
    this.attente.clear();
  }

  /** `clip.mouvement(prop, dep, dest, delai, duree, easing, onStart, onStop)` : valeur tronquée (int). */
  mouvement<T extends object>(
    cible: T, prop: keyof T & string, dep: number | undefined, dest: number,
    delai: number, duree: number, ease: EasingName, onStart?: Callback, onStop?: Callback,
  ): void {
    const target = cible as Record<string, number>;
    let valeurDep: number;
    if (dep !== undefined) {
      valeurDep = dep;
      target[prop] = dep;
    } else valeurDep = target[prop];
    const valeurMouv = dest - valeurDep;
    const f = easing[ease];
    this.schedule(delai, {
      name: `${uid(cible)}.${prop}`, a: 0, duree, cible, onStart, onStop,
      update: (m) => {
        target[prop] = int(f(m.a, valeurDep, valeurMouv, duree));
      },
    });
  }

  /** `RMouvement` : déplace le point `id` du repère ; les axes non définis de `dest` ne bougent pas. */
  rMouvement(
    owner: object, repere: Repere3d, id: number, dep: Axes | undefined, dest: Axes,
    delai: number, duree: number, ease: EasingName, onStart?: Callback, onStop?: Callback,
  ): void {
    const obj = repere.array[id];
    if (!obj) {
      // Le code d'origine vise parfois un indice hors du tableau : Flash crée alors un mouvement sans cible.
      this.schedule(delai, { name: `${uid(owner)}.${id}_Rmouv`, a: 0, duree, cible: undefined, onStart, onStop, update: () => {} });
      return;
    }
    const start: [number, number, number] = dep
      ? [dep[0] ?? 0, dep[1] ?? 0, dep[2] ?? 0]
      : [Math.round(obj.position.x), Math.round(obj.position.y), Math.round(obj.position.z)];
    const f = easing[ease];
    const axes = ['x', 'y', 'z'] as const;
    this.schedule(delai, {
      name: `${uid(owner)}.${id}_Rmouv`, a: 0, duree, cible: obj, onStart, onStop,
      update: (m) => {
        for (let i = 0; i < 3; i++) {
          const to = dest[i];
          if (to === undefined) continue;
          obj.position[axes[i]] = Math.round(f(m.a, start[i], to - start[i], duree));
        }
        obj.render(repere.pers);
      },
    });
  }

  /** `RRotation` : rotation absolue du point `id` (par incréments arrondis au degré). */
  rRotation(
    owner: object, repere: Repere3d, id: number, dep: PartialVec | undefined, dest: PartialVec,
    delai: number, duree: number, ease: EasingName, onStart?: Callback, onStop?: Callback,
  ): void {
    this.rotation(`${uid(owner)}.${id}_rot`, repere, id, dep, dest, delai, duree, ease, onStart, onStop, (axis, eff) => {
      if (axis === 'x') repere.rotateObjectX(id, id, eff);
      else if (axis === 'y') repere.rotateObjectY(id, id, eff);
      else repere.rotateObjectZ(id, id, eff);
    });
  }

  /** `RRotationRelative` : rotation du point `id` autour du point d'indice `idControl`, ou d'un point donné. */
  rRotationRelative(
    owner: object, repere: Repere3d, id: number, idControl: number | Vec3, dep: PartialVec | undefined, dest: PartialVec,
    delai: number, duree: number, ease: EasingName, onStart?: Callback, onStop?: Callback,
  ): void {
    this.rotation(`${uid(owner)}.${id}_rotRel`, repere, id, dep, dest, delai, duree, ease, onStart, onStop, (axis, eff) => {
      if (axis === 'x') repere.relativeRotatePointX(id, idControl, eff);
      else if (axis === 'y') repere.relativeRotatePointY(id, idControl, eff);
      else repere.relativeRotatePointZ(id, idControl, eff);
    });
  }

  /**
   * `RScaleRelative` : dans l'original, la cible est un point (qui n'a pas de méthode
   * relativeScaleObject) : seul le rendu est effectué. Comportement conservé.
   */
  rScaleRelative(
    owner: object, repere: Repere3d, id: number, delai: number, duree: number,
    onStart?: Callback, onStop?: Callback,
  ): void {
    const obj = repere.array[id];
    this.schedule(delai, {
      name: `${uid(owner)}.${id}_RscaleRelative`, a: 0, duree, cible: obj, onStart, onStop,
      update: () => obj?.render(repere.pers),
    });
  }

  /** `retardateur` : minuterie ; onStart au départ (si délai > 0), onStop après `duree` images. */
  retardateur(owner: object, delai: number, duree: number, onStart?: Callback, onStop?: Callback): void {
    this.schedule(delai, {
      name: `${uid(owner)}.timer${Math.random()}`, a: 0, duree, cible: owner, onStart, onStop, update: () => {},
    });
  }

  soundVolume(
    sound: TweenableSound, vInit: number | undefined, vEnd: number,
    delai: number, duree: number, ease: EasingName, onStart?: Callback, onStop?: Callback,
  ): void {
    this.soundTween(sound, 'volume', vInit, vEnd, delai, duree, ease, onStart, onStop);
  }

  soundPan(
    sound: TweenableSound, vInit: number | undefined, vEnd: number,
    delai: number, duree: number, ease: EasingName, onStart?: Callback, onStop?: Callback,
  ): void {
    this.soundTween(sound, 'pan', vInit, vEnd, delai, duree, ease, onStart, onStop);
  }

  /** Interpolation d'une valeur d'un tableau de style (ApiMouvement), avec une clé fournie. */
  arrayValue(
    name: string, cible: number[], index: number, dep: number, dest: number,
    delai: number, duree: number, ease: EasingName, onStart?: Callback, onStop?: Callback,
  ): void {
    cible[index] = dep;
    const f = easing[ease];
    this.schedule(delai, {
      name, a: 0, duree, cible, onStart, onStop,
      update: (m) => {
        cible[index] = int(f(m.a, dep, dest - dep, duree));
      },
    });
  }

  private soundTween(
    sound: TweenableSound, kind: 'volume' | 'pan', vInit: number | undefined, vEnd: number,
    delai: number, duree: number, ease: EasingName, onStart?: Callback, onStop?: Callback,
  ): void {
    const set = (v: number) => (kind === 'volume' ? sound.setVolume(v) : sound.setPan(v));
    let dep: number;
    if (vInit !== undefined) {
      dep = vInit;
      set(vInit);
    } else dep = kind === 'volume' ? sound.getVolume() : sound.getPan();
    const f = easing[ease];
    this.schedule(delai, {
      name: `sound_${kind}${Math.random()}`, a: 0, duree, cible: sound, onStart, onStop,
      update: (m) => set(Math.round(f(m.a, dep, vEnd - dep, duree))),
    });
  }

  private rotation(
    name: string, repere: Repere3d, id: number, dep: PartialVec | undefined, dest: PartialVec,
    delai: number, duree: number, ease: EasingName, onStart: Callback | undefined, onStop: Callback | undefined,
    apply: (axis: 'x' | 'y' | 'z', eff: number) => void,
  ): void {
    const obj = repere.array[id];
    const valeurDep = dep ? new Vector3d(dep.x ?? 0, dep.y ?? 0, dep.z ?? 0) : obj.rotation.getClone();
    const courant = valeurDep.getClone();
    const f = easing[ease];
    this.schedule(delai, {
      name, a: 0, duree, cible: repere, onStart, onStop,
      update: (m) => {
        for (const axis of ['x', 'y', 'z'] as const) {
          const to = dest[axis];
          if (to === undefined) continue;
          const next = Math.round(f(m.a, valeurDep[axis], to - valeurDep[axis], duree));
          const eff = next - courant[axis];
          courant[axis] += eff;
          apply(axis, eff);
        }
      },
    });
  }

  private schedule(delai: number, m: Mouv): void {
    if (delai > 0) {
      const top = this.curFrame + delai;
      let list = this.attente.get(top);
      if (!list) this.attente.set(top, (list = []));
      list.push(m);
    } else {
      this.mouvs.set(m.name, m);
    }
  }
}
