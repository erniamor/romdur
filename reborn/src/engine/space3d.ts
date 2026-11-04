import type { Clip } from '../flash/clip';
import type { FlashColor } from '../flash/color';
import { cosD, sinD } from './easing';

/** Vecteur 3D (Robert Penner), avec les méthodes utilisées par romdur. */
export class Vector3d {
  constructor(
    public x = 0,
    public y = 0,
    public z = 0,
  ) {}

  reset(x: number, y: number, z: number): void {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  getClone(): Vector3d {
    return new Vector3d(this.x, this.y, this.z);
  }

  plus(v: Partial<Vec3>): void {
    // En AS2 (SWF 6), une composante absente vaut 0 en calcul : translateObject(…, {x: -370}).
    this.x += v.x ?? 0;
    this.y += v.y ?? 0;
    this.z += v.z ?? 0;
  }

  minusNew(v: Vec3): Vector3d {
    return new Vector3d(this.x - v.x, this.y - v.y, this.z - v.z);
  }

  scale(v: Vec3): void {
    this.x *= v.x;
    this.y *= v.y;
    this.z *= v.z;
  }

  /**
   * Bug d'origine conservé : la mise à l'échelle utilise le pivot `v` comme facteur, pas `k`.
   */
  relativeScale(v: Vec3, _k: Vec3): void {
    const t = this.minusNew(v);
    t.scale(v);
    t.plus(v);
    this.reset(t.x, t.y, t.z);
  }

  getPerspective(viewDist = 1000): number {
    return viewDist / (this.z + viewDist);
  }

  persProjectNew(p = this.getPerspective()): Vector3d {
    return new Vector3d(p * this.x, p * this.y, 0);
  }

  rotateXTrig(ca: number, sa: number): void {
    const y = this.y * ca - this.z * sa;
    const z = this.y * sa + this.z * ca;
    this.y = y;
    this.z = z;
  }

  rotateYTrig(ca: number, sa: number): void {
    const x = this.x * ca + this.z * sa;
    const z = this.x * -sa + this.z * ca;
    this.x = x;
    this.z = z;
  }

  rotateZTrig(ca: number, sa: number): void {
    const x = this.x * ca - this.y * sa;
    const y = this.x * sa + this.y * ca;
    this.x = x;
    this.y = y;
  }

  rotateX(angle: number): void {
    this.rotateXTrig(cosD(angle), sinD(angle));
  }

  rotateY(angle: number): void {
    this.rotateYTrig(cosD(angle), sinD(angle));
  }

  rotateZ(angle: number): void {
    this.rotateZTrig(cosD(angle), sinD(angle));
  }

  rotateXYTrig(ca: number, sa: number, cb: number, sb: number): void {
    const rz = this.y * sa + this.z * ca;
    this.y = this.y * ca - this.z * sa;
    this.z = this.x * -sb + rz * cb;
    this.x = this.x * cb + rz * sb;
  }

  rotateXY(a: number, b: number): void {
    this.rotateXYTrig(cosD(a), sinD(a), cosD(b), sinD(b));
  }

  relativeRotateX(v: Vec3, angle: number): void {
    this.relative(v, (t) => t.rotateX(angle));
  }

  relativeRotateY(v: Vec3, angle: number): void {
    this.relative(v, (t) => t.rotateY(angle));
  }

  relativeRotateZ(v: Vec3, angle: number): void {
    this.relative(v, (t) => t.rotateZ(angle));
  }

  relativeRotateXTrig(v: Vec3, ca: number, sa: number): void {
    this.relative(v, (t) => t.rotateXTrig(ca, sa));
  }

  relativeRotateYTrig(v: Vec3, ca: number, sa: number): void {
    this.relative(v, (t) => t.rotateYTrig(ca, sa));
  }

  relativeRotateZTrig(v: Vec3, ca: number, sa: number): void {
    this.relative(v, (t) => t.rotateZTrig(ca, sa));
  }

  private relative(v: Vec3, op: (t: Vector3d) => void): void {
    const t = this.minusNew(v);
    op(t);
    t.plus(v);
    this.reset(t.x, t.y, t.z);
  }
}

export interface Vec3 {
  x: number;
  y: number;
  z: number;
}

/** Point affichable d'un repère : il a une position, une rotation cumulée et un clip à l'écran. */
export interface Object3d {
  position: Vector3d;
  rotation: Vector3d;
  scale: number;
  screenPos: Vector3d;
  render(perspective?: number): void;
}

/** Place le clip d'un objet 3D : projection, échelle selon la profondeur, tri par swapDepths. */
function placeClip(obj: Object3d, mc: Clip, perspective: number | undefined): void {
  const pers = obj.position.getPerspective(perspective);
  obj.screenPos = obj.position.persProjectNew(pers);
  mc.x = obj.screenPos.x;
  mc.y = -obj.screenPos.y;
  mc.xscale = mc.yscale = obj.scale * pers * 1.5;
  mc.swapDepths(100000 - obj.position.z * 100);
}

/** Point 3D dessiné comme un petit trait (lineStyle(taille) ; lineTo(1, 0)). */
export class Point3d implements Object3d {
  position: Vector3d;
  rotation: Vector3d;
  scale = 100;
  screenPos = new Vector3d();
  readonly point: Clip;

  constructor(
    x: number,
    y: number,
    z: number,
    readonly timeline: Clip,
    taille: number,
    couleur: FlashColor | undefined,
    alpha: number | undefined,
    depth: number,
    rot?: [number, number, number],
  ) {
    this.position = new Vector3d(x, y, z);
    this.point = timeline.createEmptyMovieClip(`point${depth}`, depth);
    this.point.graphics.lineStyle(taille, couleur ?? 0, alpha ?? 100);
    this.point.graphics.lineTo(1, 0);
    this.rotation = rot ? new Vector3d(...rot) : new Vector3d();
    this.render();
  }

  render(perspective?: number): void {
    placeClip(this, this.point, perspective);
  }
}

/** Objet 3D porté par un clip de bibliothèque (attachMovie), comme les boutons du menu. */
export class Particle3d<T extends Clip = Clip> implements Object3d {
  position: Vector3d;
  rotation: Vector3d;
  scale = 100;
  screenPos = new Vector3d();
  readonly mc: T;

  constructor(
    x: number,
    y: number,
    z: number,
    readonly timeline: Clip,
    symbol: () => T,
    mcID: string,
    depth: number,
    rot?: [number, number, number],
  ) {
    this.position = new Vector3d(x, y, z);
    this.mc = timeline.addChildAt(symbol(), depth, `${mcID}_${depth}`);
    this.rotation = rot ? new Vector3d(...rot) : new Vector3d();
    this.render();
  }

  render(perspective?: number): void {
    placeClip(this, this.mc, perspective);
  }
}

type Pivot = number | Vec3;

/** Repère 3D : liste ordonnée d'objets, manipulés par indice ou par plage d'indices [idInit, idEnd]. */
export class Repere3d {
  readonly array: Object3d[] = [];
  /** Indice du premier point de chaque objet créé par les générateurs de formes. */
  readonly idObjet: number[] = [];

  constructor(readonly pers?: number) {}

  render(perspective = this.pers): void {
    for (let i = this.array.length - 1; i >= 0; i--) this.array[i].render(perspective);
  }

  rotateX(angle: number): void {
    this.rotateRange(0, this.array.length - 1, 'x', angle, true);
  }

  rotateY(angle: number): void {
    this.rotateRange(0, this.array.length - 1, 'y', angle, true);
  }

  rotateZ(angle: number): void {
    this.rotateRange(0, this.array.length - 1, 'z', angle, true);
  }

  rotateXY(a: number, b: number): void {
    const ca = cosD(a), sa = sinD(a), cb = cosD(b), sb = sinD(b);
    for (let i = this.array.length - 1; i >= 0; i--) {
      const o = this.array[i];
      o.position.rotateXYTrig(ca, sa, cb, sb);
      o.render(this.pers);
      o.rotation.x += a;
      o.rotation.y += b;
    }
  }

  rotatePointX(id: number, angle: number): void {
    this.rotateRange(id, id, 'x', angle, true);
  }

  rotatePointY(id: number, angle: number): void {
    this.rotateRange(id, id, 'y', angle, true);
  }

  rotatePointZ(id: number, angle: number): void {
    this.rotateRange(id, id, 'z', angle, true);
  }

  rotateObjectX(idInit: number, idEnd: number, angle: number): void {
    this.rotateRange(idInit, idEnd, 'x', angle, true);
  }

  rotateObjectY(idInit: number, idEnd: number, angle: number): void {
    this.rotateRange(idInit, idEnd, 'y', angle, true);
  }

  rotateObjectZ(idInit: number, idEnd: number, angle: number): void {
    this.rotateRange(idInit, idEnd, 'z', angle, true);
  }

  rotateObjectXY(idInit: number, idEnd: number, angleX: number, angleY: number): void {
    const ca = cosD(angleX), sa = sinD(angleX), cb = cosD(angleY), sb = sinD(angleY);
    for (let i = idInit; i <= idEnd; i++) {
      const o = this.array[i];
      o.position.rotateXYTrig(ca, sa, cb, sb);
      o.render(this.pers);
      o.rotation.x += angleX;
      o.rotation.y += angleY;
    }
  }

  relativeRotateObjectX(idInit: number, idEnd: number, idV: Pivot, angle: number): void {
    const v = this.pivot(idV), ca = cosD(angle), sa = sinD(angle);
    this.forRange(idInit, idEnd, (o) => o.position.relativeRotateXTrig(v, ca, sa));
  }

  relativeRotateObjectY(idInit: number, idEnd: number, idV: Pivot, angle: number): void {
    const v = this.pivot(idV), ca = cosD(angle), sa = sinD(angle);
    this.forRange(idInit, idEnd, (o) => o.position.relativeRotateYTrig(v, ca, sa));
  }

  relativeRotateObjectZ(idInit: number, idEnd: number, idV: Pivot, angle: number): void {
    const v = this.pivot(idV), ca = cosD(angle), sa = sinD(angle);
    this.forRange(idInit, idEnd, (o) => o.position.relativeRotateZTrig(v, ca, sa));
  }

  relativeRotatePointX(id: number, idV: Pivot, angle: number): void {
    const v = this.pivot(idV);
    this.forRange(id, id, (o) => o.position.relativeRotateX(v, angle));
  }

  relativeRotatePointY(id: number, idV: Pivot, angle: number): void {
    const v = this.pivot(idV);
    this.forRange(id, id, (o) => o.position.relativeRotateY(v, angle));
  }

  relativeRotatePointZ(id: number, idV: Pivot, angle: number): void {
    const v = this.pivot(idV);
    this.forRange(id, id, (o) => o.position.relativeRotateZ(v, angle));
  }

  translateObject(idInit: number, idEnd: number, d: Partial<Vec3>): void {
    this.forRange(idInit, idEnd, (o) => o.position.plus(d));
  }

  translatePoint(id: number, d: Partial<Vec3>): void {
    this.forRange(id, id, (o) => o.position.plus(d));
  }

  scalePoint(id: number, k: number | Vec3): void {
    const v = toVec(k);
    this.forRange(id, id, (o) => o.position.scale(v));
  }

  scaleObject(idInit: number, idEnd: number, k: number | Vec3): void {
    const v = toVec(k);
    this.forRange(idInit, idEnd, (o) => o.position.scale(v));
  }

  relativeScalePoint(id: number, idV: Pivot, k: number | Vec3): void {
    const v = toVec(k), pivot = this.pivot(idV);
    this.forRange(id, id, (o) => o.position.relativeScale(pivot, v));
  }

  relativeScaleObject(idInit: number, idEnd: number, idV: Pivot, k: number | Vec3): void {
    const v = toVec(k), pivot = this.pivot(idV);
    this.forRange(idInit, idEnd, (o) => o.position.relativeScale(pivot, v));
  }

  /** Copie des positions courantes (saveRepere), pour revenir à une pose de référence. */
  savePositions(): Vector3d[] {
    return this.array.map((o) => o.position.getClone());
  }

  private rotateRange(idInit: number, idEnd: number, axis: 'x' | 'y' | 'z', angle: number, track: boolean): void {
    const ca = cosD(angle), sa = sinD(angle);
    for (let i = idInit; i <= idEnd; i++) {
      const o = this.array[i];
      if (!o) continue;
      if (axis === 'x') o.position.rotateXTrig(ca, sa);
      else if (axis === 'y') o.position.rotateYTrig(ca, sa);
      else o.position.rotateZTrig(ca, sa);
      o.render(this.pers);
      if (track) o.rotation[axis] += angle;
    }
  }

  private forRange(idInit: number, idEnd: number, op: (o: Object3d) => void): void {
    for (let i = idInit; i <= idEnd; i++) {
      const o = this.array[i];
      if (!o) continue;
      op(o);
      o.render(this.pers);
    }
  }

  private pivot(idV: Pivot): Vector3d {
    return typeof idV === 'number' ? this.array[idV].position.getClone() : new Vector3d(idV.x, idV.y, idV.z);
  }
}

function toVec(k: number | Vec3): Vec3 {
  return typeof k === 'number' ? { x: k, y: k, z: k } : k;
}
