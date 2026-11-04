import type { Clip } from '../flash/clip';
import type { FlashColor } from '../flash/color';
import { Point3d, type Repere3d } from './space3d';

/**
 * Générateurs de points (frame 3 d'interface.swf). Chacun ajoute ses points à la fin du repère
 * et note l'indice du premier dans `repere.idObjet`.
 * Particularités conservées :
 * - l'étoile et le carré ignorent `z` et placent leurs points à `haut / 2` ;
 * - le cube et l'étoile transmettent la couleur et l'alpha bruts (sans valeur par défaut).
 */
export interface PointStyle {
  taille?: number;
  couleur?: FlashColor;
  alpha?: number;
}

function push(repere: Repere3d, timeline: Clip, x: number, y: number, z: number, s: PointStyle, raw: boolean): void {
  const taille = s.taille ?? 3;
  const couleur = raw ? s.couleur : (s.couleur ?? 0x000000);
  const alpha = raw ? s.alpha : (s.alpha ?? 100);
  repere.array.push(new Point3d(x, y, z, timeline, taille, couleur, alpha, repere.array.length));
}

export function getCube3dPoints(
  timeline: Clip, repere: Repere3d, x: number, y: number, z: number,
  long: number, larg: number, haut: number, style: PointStyle = {},
): void {
  repere.idObjet.push(repere.array.length);
  const lo = long / 2, lr = larg / 2, h = haut / 2;
  const corners: [number, number, number][] = [
    [x - lo, y + lr, z + h], [x + lo, y + lr, z + h], [x + lo, y - lr, z + h], [x - lo, y - lr, z + h],
    [x - lo, y + lr, z - h], [x + lo, y + lr, z - h], [x + lo, y - lr, z - h], [x - lo, y - lr, z - h],
  ];
  for (const [px, py, pz] of corners) push(repere, timeline, px, py, pz, style, true);
}

/** Cercle en 18 points : départ + 8 couples (contrôle, ancre) pour curveTo, et le départ répété. */
export function getCercle3dPoints(
  timeline: Clip, repere: Repere3d, x: number, y: number, z: number,
  rx: number, ry: number, style: PointStyle = {},
): void {
  repere.idObjet.push(repere.array.length);
  const k = 0.4142, r = 0.7071;
  const pts: [number, number][] = [
    [x + rx, y], [rx + x, k * ry + y], [r * rx + x, r * ry + y], [k * rx + x, ry + y], [x, ry + y],
    [-k * rx + x, ry + y], [-r * rx + x, r * ry + y], [-rx + x, k * ry + y], [-rx + x, y],
    [-rx + x, -k * ry + y], [-r * rx + x, -r * ry + y], [-k * rx + x, -ry + y], [x, -ry + y],
    [k * rx + x, -ry + y], [r * rx + x, -r * ry + y], [rx + x, -k * ry + y], [rx + x, y], [rx + x, y],
  ];
  for (const [px, py] of pts) push(repere, timeline, px, py, z, style, false);
}

export function getEtoile3dPoints(
  timeline: Clip, repere: Repere3d, x: number, y: number, _z: number,
  long: number, larg: number, haut: number, style: PointStyle = {},
): void {
  repere.idObjet.push(repere.array.length);
  const lo = long / 2, lr = larg / 2, h = haut / 2;
  const pts: [number, number][] = [[x + lo, y + lr], [x + lo, y - lr], [x - lo, y - lr], [x - lo, y + lr], [x, y]];
  for (const [px, py] of pts) push(repere, timeline, px, py, h, style, true);
}

export function getCarre3dPoints(
  timeline: Clip, repere: Repere3d, x: number, y: number, _z: number,
  long: number, larg: number, haut: number, style: PointStyle = {},
): void {
  repere.idObjet.push(repere.array.length);
  const lo = long / 2, lr = larg / 2, h = haut / 2;
  const pts: [number, number][] = [[x + lo, y + lr], [x + lo, y - lr], [x - lo, y - lr], [x - lo, y + lr]];
  for (const [px, py] of pts) push(repere, timeline, px, py, h, style, true);
}

/** createPtsArray : [idInit, idInit + 1, …, idInit + nbElt - 1]. */
export function createPtsArray(idInit: number, nbElt: number): number[] {
  return Array.from({ length: nbElt }, (_, i) => idInit + i);
}
