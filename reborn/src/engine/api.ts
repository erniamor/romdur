import type { Clip } from '../flash/clip';
import type { FlashColor } from '../flash/color';
import type { Graphics } from '../flash/graphics';
import type { Repere3d, Vector3d } from './space3d';

/** Style de tracé : [épaisseur, couleur du trait, alpha du trait, couleur de fond, alpha du fond]. */
export type ApiStyle = [number, FlashColor, number, FlashColor, number];

export type ApiType =
  | 'standardLine'
  | 'standardCurve'
  | 'standardFillLine'
  | 'standardFillCurve'
  | 'cercle'
  | 'cercleCutted'
  | 'liaisonCylindre'
  | 'liaisonCerclePic'
  | 'etoile'
  | 'cube';

export interface ApiObject {
  name: string;
  mc: Clip;
  repere: Repere3d;
  /** Indices des points ; pour liaisonCylindre, deux listes. */
  pts: number[] | number[][];
  styleId: number;
  styleLocal: number[];
  styleMethode: 'global' | 'local';
  typeObjet: ApiType;
  etat: boolean;
}

/** Styles d'origine (frame 3). Modifiables par l'éditeur de thème. */
export const DEFAULT_STYLES: ApiStyle[] = [
  [1, 0x3e4a4d, 40, 0xd3d6d6, 20],
  [1, 0x3e4a4d, 50, 0x4e5e61, 10],
  [1, 0x16343f, 50, 0xffffff, 20],
];

/**
 * Moteur de rendu « MoteurApi » : chaque objet actif est redessiné à chaque image dans son clip,
 * à partir des positions écran (screenPos) des points de son repère. L'axe Y est inversé.
 */
export class ApiEngine {
  readonly style: ApiStyle[] = DEFAULT_STYLES.map((s) => [...s] as ApiStyle);
  readonly apiOn = new Map<string, ApiObject>();
  readonly apiOff = new Map<string, ApiObject>();

  tick = (): void => {
    // for…in de Flash 6 : du plus récent au plus ancien (sans effet visuel, chaque objet a son clip).
    for (const obj of [...this.apiOn.values()].reverse()) draw(obj, this.styleOf(obj));
  };

  createApi(
    mc: Clip, repere: Repere3d, pts: number[] | number[][], nom: string,
    styleId: number, typeObjet: ApiType, etat: boolean, methode: 'global' | 'local',
  ): ApiObject {
    const obj: ApiObject = {
      name: nom, mc, repere, pts, styleId, styleLocal: [], styleMethode: methode, typeObjet, etat,
    };
    (etat ? this.apiOn : this.apiOff).set(nom, obj);
    return obj;
  }

  activeEtat(nom: string): void {
    const obj = this.apiOff.get(nom);
    if (!obj) return;
    obj.etat = true;
    this.apiOn.set(nom, obj);
    this.apiOff.delete(nom);
  }

  desactiveEtat(nom: string): void {
    const obj = this.apiOn.get(nom);
    if (!obj) return;
    obj.etat = false;
    obj.mc.graphics.clear();
    this.apiOff.set(nom, obj);
    this.apiOn.delete(nom);
  }

  /** Supprime un objet actif sans effacer son dessin (comme `delete apiOn[nom]`). */
  remove(nom: string): void {
    this.apiOn.delete(nom);
  }

  setLocal(nom: string, style: number[]): void {
    const obj = this.apiOn.get(nom);
    if (!obj) return;
    obj.styleMethode = 'local';
    obj.styleLocal = style;
  }

  setGlobal(nom: string): void {
    const obj = this.apiOn.get(nom);
    if (obj) obj.styleMethode = 'global';
  }

  /** Vide la liste des objets actifs (`for (api in apiOn) delete apiOn[api]`). */
  removeAllOn(): void {
    this.apiOn.clear();
  }

  reset(): void {
    this.apiOn.clear();
    this.apiOff.clear();
  }

  private styleOf(obj: ApiObject): readonly (number | FlashColor)[] {
    return obj.styleMethode === 'local' ? obj.styleLocal : (this.style[obj.styleId] ?? []);
  }
}

function draw(obj: ApiObject, style: readonly (number | FlashColor)[]): void {
  const g = obj.mc.graphics;
  const at = (i: number): Vector3d => obj.repere.array[i]?.screenPos ?? ZERO;
  const lineStyle = () => g.lineStyle(style[0] as number, style[1], style[2] as number);
  const beginFill = () => g.beginFill(style[3] ?? 0, style[4] as number);
  const moveTo = (i: number) => g.moveTo(at(i).x, -at(i).y);
  const lineTo = (i: number) => g.lineTo(at(i).x, -at(i).y);
  const curveTo = (c: number, i: number) => g.curveTo(at(c).x, -at(c).y, at(i).x, -at(i).y);
  const pts = obj.pts as number[];

  g.clear();
  lineStyle();
  switch (obj.typeObjet) {
    case 'standardLine':
      moveTo(pts[0]);
      for (let i = 1; i < pts.length; i++) lineTo(pts[i]);
      break;
    case 'standardCurve':
      moveTo(pts[0]);
      for (let i = 1; i < pts.length; i += 2) curveTo(pts[i], pts[i + 1]);
      break;
    case 'standardFillLine':
      beginFill();
      moveTo(pts[0]);
      for (let i = 1; i < pts.length; i++) lineTo(pts[i]);
      g.endFill();
      break;
    case 'standardFillCurve':
      beginFill();
      moveTo(pts[0]);
      for (let i = 1; i < pts.length; i += 2) curveTo(pts[i], pts[i + 1]);
      g.endFill();
      break;
    case 'cercle':
      beginFill();
      moveTo(pts[0]);
      for (let i = 1; i < pts.length - 1; i += 2) curveTo(pts[i], pts[i + 1]);
      g.endFill();
      break;
    case 'cercleCutted':
      moveTo(pts[0]);
      for (let i = 1; i < pts.length - 3; i += 2) curveTo(pts[i], pts[i + 1]);
      break;
    case 'liaisonCerclePic': {
      // pts = [premier point du cercle, premier des 4 pics] : relie un point sur 4 du cercle à chaque pic.
      let inc = 0;
      for (let i = pts[1]; i <= pts[1] + 3; i++) {
        moveTo(pts[0] + inc);
        lineTo(i);
        inc += 4;
      }
      break;
    }
    case 'liaisonCylindre': {
      const [a, b] = obj.pts as number[][];
      for (let i = 0; i < a.length; i += 2) {
        moveTo(a[i]);
        lineTo(b[i]);
      }
      break;
    }
    case 'etoile': {
      const idC = pts[0], idInit = pts[1];
      beginFill();
      moveTo(idInit);
      curveTo(idC, idInit + 1);
      curveTo(idC, idInit + 2);
      curveTo(idC, idInit + 3);
      curveTo(idC, idInit);
      g.endFill();
      break;
    }
    case 'cube': {
      const id = pts[0];
      const faces = [
        [0, 1, 2, 3], [4, 5, 6, 7], [0, 4, 7, 3], [1, 5, 6, 2], [0, 1, 5, 4], [3, 2, 6, 7],
      ];
      for (const f of faces) {
        beginFill();
        drawQuad(g, at(id + f[0]), at(id + f[1]), at(id + f[2]), at(id + f[3]));
        g.endFill();
      }
      break;
    }
  }
}

/** drawQuad de la frame 3 (celle qui écrase la version du sprite 173) : Y inversé. */
function drawQuad(g: Graphics, p1: Vector3d, p2: Vector3d, p3: Vector3d, p4: Vector3d): void {
  g.moveTo(p1.x, -p1.y);
  g.lineTo(p2.x, -p2.y);
  g.lineTo(p3.x, -p3.y);
  g.lineTo(p4.x, -p4.y);
  g.lineTo(p1.x, -p1.y);
}

const ZERO = { x: 0, y: 0, z: 0 } as Vector3d;
