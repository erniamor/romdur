/**
 * Équations d'interpolation de Robert Penner, telles qu'elles figurent dans interface.swf (sprite 173).
 * t : temps (images), b : valeur de départ, c : variation, d : durée (images).
 * Particularité conservée : les variantes « Back » utilisent s = 2 par défaut (et non 1.70158).
 */
export type Easing = (t: number, b: number, c: number, d: number) => number;

const HALF_PI = Math.PI / 2;
const TWO_PI = Math.PI * 2;

const easeOutBounce: Easing = (t, b, c, d) => {
  if ((t /= d) < 1 / 2.75) return c * (7.5625 * t * t) + b;
  if (t < 2 / 2.75) return c * (7.5625 * (t -= 1.5 / 2.75) * t + 0.75) + b;
  if (t < 2.5 / 2.75) return c * (7.5625 * (t -= 2.25 / 2.75) * t + 0.9375) + b;
  return c * (7.5625 * (t -= 2.625 / 2.75) * t + 0.984375) + b;
};

const easeInBounce: Easing = (t, b, c, d) => c - easeOutBounce(d - t, 0, c, d) + b;

function elasticIn(t: number, b: number, c: number, d: number, a?: number, p?: number): number {
  if (t === 0) return b;
  if ((t /= d) === 1) return b + c;
  p ||= d * 0.3;
  let s: number;
  if (a === undefined || a < Math.abs(c)) {
    a = c;
    s = p / 4;
  } else s = (p / TWO_PI) * Math.asin(c / a);
  return -(a * Math.pow(2, 10 * (t -= 1)) * Math.sin(((t * d - s) * TWO_PI) / p)) + b;
}

function elasticOut(t: number, b: number, c: number, d: number, a?: number, p?: number): number {
  if (t === 0) return b;
  if ((t /= d) === 1) return b + c;
  p ||= d * 0.3;
  let s: number;
  if (a === undefined || a < Math.abs(c)) {
    a = c;
    s = p / 4;
  } else s = (p / TWO_PI) * Math.asin(c / a);
  return a * Math.pow(2, -10 * t) * Math.sin(((t * d - s) * TWO_PI) / p) + c + b;
}

function elasticInOut(t: number, b: number, c: number, d: number, a?: number, p?: number): number {
  if (t === 0) return b;
  if ((t /= d / 2) === 2) return b + c;
  p ||= d * (0.3 * 1.5);
  let s: number;
  if (a === undefined || a < Math.abs(c)) {
    a = c;
    s = p / 4;
  } else s = (p / TWO_PI) * Math.asin(c / a);
  if (t < 1) return -0.5 * (a * Math.pow(2, 10 * (t -= 1)) * Math.sin(((t * d - s) * TWO_PI) / p)) + b;
  return a * Math.pow(2, -10 * (t -= 1)) * Math.sin(((t * d - s) * TWO_PI) / p) * 0.5 + c + b;
}

export const easing = {
  linearTween: (t, b, c, d) => (c * t) / d + b,

  easeInQuad: (t, b, c, d) => c * (t /= d) * t + b,
  easeOutQuad: (t, b, c, d) => -c * (t /= d) * (t - 2) + b,
  easeInOutQuad: (t, b, c, d) => ((t /= d / 2) < 1 ? (c / 2) * t * t + b : (-c / 2) * (--t * (t - 2) - 1) + b),

  easeInCubic: (t, b, c, d) => c * (t /= d) * t * t + b,
  easeOutCubic: (t, b, c, d) => c * ((t = t / d - 1) * t * t + 1) + b,
  easeInOutCubic: (t, b, c, d) => ((t /= d / 2) < 1 ? (c / 2) * t * t * t + b : (c / 2) * ((t -= 2) * t * t + 2) + b),

  easeInQuart: (t, b, c, d) => c * (t /= d) * t * t * t + b,
  easeOutQuart: (t, b, c, d) => -c * ((t = t / d - 1) * t * t * t - 1) + b,
  easeInOutQuart: (t, b, c, d) =>
    (t /= d / 2) < 1 ? (c / 2) * t * t * t * t + b : (-c / 2) * ((t -= 2) * t * t * t - 2) + b,

  easeInQuint: (t, b, c, d) => c * (t /= d) * t * t * t * t + b,
  easeOutQuint: (t, b, c, d) => c * ((t = t / d - 1) * t * t * t * t + 1) + b,
  easeInOutQuint: (t, b, c, d) =>
    (t /= d / 2) < 1 ? (c / 2) * t * t * t * t * t + b : (c / 2) * ((t -= 2) * t * t * t * t + 2) + b,

  easeInSine: (t, b, c, d) => -c * Math.cos((t / d) * HALF_PI) + c + b,
  easeOutSine: (t, b, c, d) => c * Math.sin((t / d) * HALF_PI) + b,
  easeInOutSine: (t, b, c, d) => (-c / 2) * (Math.cos((Math.PI * t) / d) - 1) + b,

  easeInExpo: (t, b, c, d) => (t === 0 ? b : c * Math.pow(2, 10 * (t / d - 1)) + b),
  easeOutExpo: (t, b, c, d) => (t === d ? b + c : c * (-Math.pow(2, (-10 * t) / d) + 1) + b),
  easeInOutExpo: (t, b, c, d) => {
    if (t === 0) return b;
    if (t === d) return b + c;
    if ((t /= d / 2) < 1) return (c / 2) * Math.pow(2, 10 * (t - 1)) + b;
    return (c / 2) * (-Math.pow(2, -10 * --t) + 2) + b;
  },

  easeInCirc: (t, b, c, d) => -c * (Math.sqrt(1 - (t /= d) * t) - 1) + b,
  easeOutCirc: (t, b, c, d) => c * Math.sqrt(1 - (t = t / d - 1) * t) + b,
  easeInOutCirc: (t, b, c, d) =>
    (t /= d / 2) < 1 ? (-c / 2) * (Math.sqrt(1 - t * t) - 1) + b : (c / 2) * (Math.sqrt(1 - (t -= 2) * t) + 1) + b,

  easeInElastic: (t, b, c, d) => elasticIn(t, b, c, d),
  easeOutElastic: (t, b, c, d) => elasticOut(t, b, c, d),
  easeInOutElastic: (t, b, c, d) => elasticInOut(t, b, c, d),

  easeInBack: (t, b, c, d) => {
    const s = 2;
    return c * (t /= d) * t * ((s + 1) * t - s) + b;
  },
  easeOutBack: (t, b, c, d) => {
    const s = 2;
    return c * ((t = t / d - 1) * t * ((s + 1) * t + s) + 1) + b;
  },
  easeInOutBack: (t, b, c, d) => {
    let s = 2;
    if ((t /= d / 2) < 1) return (c / 2) * (t * t * (((s *= 1.525) + 1) * t - s)) + b;
    return (c / 2) * ((t -= 2) * t * (((s *= 1.525) + 1) * t + s) + 2) + b;
  },

  easeInBounce,
  easeOutBounce,
  easeInOutBounce: (t, b, c, d) =>
    t < d / 2 ? easeInBounce(t * 2, 0, c, d) * 0.5 + b : easeOutBounce(t * 2 - d, 0, c, d) * 0.5 + c * 0.5 + b,
} satisfies Record<string, Easing>;

export type EasingName = keyof typeof easing;

export const sinD = (angle: number): number => Math.sin(angle * (Math.PI / 180));
export const cosD = (angle: number): number => Math.cos(angle * (Math.PI / 180));

/** `random(n)` d'ActionScript : entier dans [0, n-1]. */
export const random = (n: number): number => Math.floor(Math.random() * n);

/** `int()` d'ActionScript : troncature vers zéro. */
export const int = (v: number): number => Math.trunc(v) || 0;
