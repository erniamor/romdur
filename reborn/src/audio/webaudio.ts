import type { FlashSound, SoundBank } from './sound';

/**
 * Modèle sonore vérifié à l'oreille contre l'original (Ruffle) :
 * - chaque son a son propre volume et son propre panoramique ;
 * - `stop()` n'arrête que les voix de ce son.
 */

/** Chaîne de sortie d'un son : volume (gain) puis panoramique façon Flash (atténuation linéaire d'un canal). */
class Output {
  readonly input: GainNode;
  private readonly left: GainNode;
  private readonly right: GainNode;

  constructor(private readonly ctx: AudioContext) {
    this.input = ctx.createGain();
    // Un son mono est réparti sur les deux canaux avant le panoramique.
    this.input.channelCount = 2;
    this.input.channelCountMode = 'explicit';
    this.input.channelInterpretation = 'speakers';
    const split = ctx.createChannelSplitter(2);
    const merge = ctx.createChannelMerger(2);
    this.left = ctx.createGain();
    this.right = ctx.createGain();
    this.input.connect(split);
    split.connect(this.left, 0);
    split.connect(this.right, 1);
    this.left.connect(merge, 0, 0);
    this.right.connect(merge, 0, 1);
    merge.connect(ctx.destination);
  }

  /** Volume Flash 0–100, au-delà amplifie ; pan -100 (gauche) … 100 (droite). */
  apply(volume: number, pan: number): void {
    const now = this.ctx.currentTime;
    // Lissage très court : les réglages image par image ne produisent pas de clics.
    this.input.gain.setTargetAtTime(Math.max(0, volume) / 100, now, 0.015);
    const p = Math.max(-100, Math.min(100, pan));
    this.left.gain.setTargetAtTime(p > 0 ? (100 - p) / 100 : 1, now, 0.015);
    this.right.gain.setTargetAtTime(p < 0 ? (100 + p) / 100 : 1, now, 0.015);
  }
}

class WebSound implements FlashSound {
  private readonly voices = new Set<AudioBufferSourceNode>();
  private volume = 100;
  private pan = 0;
  private output: Output | null = null;

  constructor(
    private readonly bank: WebAudioBank,
    private file: string,
  ) {}

  setFile(file: string): void {
    this.file = file;
  }

  private get out(): Output {
    return (this.output ??= new Output(this.bank.ctx));
  }

  /** start(décalage en s, boucles) : chaque appel lance une nouvelle voix, qui se superpose aux autres. */
  start(offset = 0, loops = 1): void {
    const buffer = this.bank.buffer(this.file);
    if (!buffer) return;
    const src = this.bank.ctx.createBufferSource();
    src.buffer = buffer;
    const start = Math.min(Math.max(offset, 0), buffer.duration);
    if (loops > 1) {
      src.loop = true;
      src.loopStart = start;
      src.loopEnd = buffer.duration;
    }
    src.connect(this.out.input);
    this.out.apply(this.volume, this.pan);
    src.onended = () => this.voices.delete(src);
    this.voices.add(src);
    src.start(0, start);
    if (loops > 1 && loops < 1000) src.stop(this.bank.ctx.currentTime + (buffer.duration - start) * loops);
  }

  stop(): void {
    for (const v of this.voices) {
      try {
        v.stop();
      } catch {
        // déjà arrêtée
      }
    }
    this.voices.clear();
  }

  setVolume(v: number): void {
    this.volume = v;
    this.out.apply(this.volume, this.pan);
  }

  getVolume(): number {
    return this.volume;
  }

  setPan(p: number): void {
    this.pan = p;
    this.out.apply(this.volume, this.pan);
  }

  getPan(): number {
    return this.pan;
  }
}

export interface SoundEntry {
  name: string;
  file: string;
}

/** Banque Web Audio : sons logiques (snd_*) → fichiers mp3 décodés. */
export class WebAudioBank implements SoundBank {
  readonly ctx = new AudioContext();
  private readonly buffers = new Map<string, AudioBuffer>();
  private readonly sounds = new Map<string, WebSound>();
  private readonly files = new Map<string, string>();

  /** Table nom logique → fichier (sounds.json), connue une fois les « données » chargées. */
  setEntries(entries: SoundEntry[]): void {
    for (const e of entries) {
      this.files.set(e.name, e.file);
      // Un son demandé avant le chargement de la table pointait vers un fichier inconnu.
      this.sounds.get(e.name)?.setFile(e.file);
    }
  }

  /** Les navigateurs exigent un geste de l'utilisateur avant de jouer du son. */
  unlock(): void {
    if (this.ctx.state === 'suspended') void this.ctx.resume();
  }

  get(name: string): FlashSound {
    let s = this.sounds.get(name);
    if (!s) this.sounds.set(name, (s = new WebSound(this, this.files.get(name) ?? '')));
    return s;
  }

  buffer(file: string): AudioBuffer | undefined {
    return this.buffers.get(file);
  }

  hasBuffer(file: string): boolean {
    return this.buffers.has(file);
  }

  async decode(file: string, data: ArrayBuffer): Promise<void> {
    this.buffers.set(file, await this.ctx.decodeAudioData(data));
  }
}
