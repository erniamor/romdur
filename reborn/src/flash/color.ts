/** Couleur au format Flash : nombre (0x3E4A4D) ou chaîne ("0x3E4A4D"). */
export type FlashColor = number | string;

export function colorToNumber(color: FlashColor): number {
  return typeof color === 'number' ? color : parseInt(color, 16) || 0;
}

/** Alpha Flash en pourcentage (0–100). */
export function rgba(color: FlashColor, alpha = 100): string {
  const c = colorToNumber(color);
  const a = Math.max(0, Math.min(100, alpha)) / 100;
  return `rgba(${(c >> 16) & 255},${(c >> 8) & 255},${c & 255},${a})`;
}
