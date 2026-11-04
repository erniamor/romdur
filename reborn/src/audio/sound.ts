import type { TweenableSound } from '../engine/tween';

/** Son Flash : start(décalage en secondes, boucles), stop, volume 0–100 (amplifiable), pan -100…100. */
export interface FlashSound extends TweenableSound {
  start(offset?: number, loops?: number): void;
  stop(): void;
}

/** Banque des sons par nom logique (snd_menu_bt, snd_cv_rot_1…). */
export interface SoundBank {
  get(name: string): FlashSound;
}

/** Son muet : garde volume et panoramique pour que les animations audio se comportent normalement. */
class SilentSound implements FlashSound {
  private volume = 100;
  private pan = 0;
  start(): void {}
  stop(): void {}
  setVolume(v: number): void {
    this.volume = v;
  }
  getVolume(): number {
    return this.volume;
  }
  setPan(p: number): void {
    this.pan = p;
  }
  getPan(): number {
    return this.pan;
  }
}

/** Banque provisoire, en attendant le moteur Web Audio (étape 5). */
export class SilentBank implements SoundBank {
  private readonly sounds = new Map<string, FlashSound>();
  get(name: string): FlashSound {
    let s = this.sounds.get(name);
    if (!s) this.sounds.set(name, (s = new SilentSound()));
    return s;
  }
}
