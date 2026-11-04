import type { SoundBank } from './audio/sound';
import { ApiEngine } from './engine/api';
import { TweenEngine } from './engine/tween';
import { Clip, timelineDepth } from './flash/clip';
import { Stage } from './flash/stage';

/**
 * Tout ce que le code d'origine trouvait dans `_level0`, `_level10` et `_global` :
 * la scène, le moteur d'animation, le moteur de dessin et les sons.
 */
export class Runtime {
  readonly stage: Stage;
  readonly tween = new TweenEngine();
  readonly api = new ApiEngine();
  /** `_level10` : la racine d'interface.swf (le `_root` de son code). */
  readonly level10: Clip;
  /** `_global.firstEnter` : vrai jusqu'à la première intro de l'accueil. */
  firstEnter = true;
  /** Clip « sample » (sprite 199) : son onEnterFrame pilote les ambiances sonores de la scène en cours. */
  readonly sample: Clip;
  /** Bouton « retour » de l'interface : chaque section branche son onRelease. */
  btRetour: Clip = new Clip('bt_retour');

  constructor(
    canvas: HTMLCanvasElement,
    readonly sounds: SoundBank,
  ) {
    this.stage = new Stage(canvas);
    this.level10 = this.stage.root.addChildAt(new Clip('_level10'), 10);
    this.sample = this.level10.createEmptyMovieClip('sample', timelineDepth(180));
    // Position d'origine : certaines ambiances lisent la souris dans le repère de ce clip.
    this.sample.x = 357.95;
    this.sample.y = 229;
    // Ordre d'une image : onEnterFrame des clips, puis MoteurMv, puis MoteurApi.
    this.stage.addSystem(this.tween.tick);
    this.stage.addSystem(this.api.tick);
  }
}
