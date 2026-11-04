import '@fontsource/libre-franklin/500.css';
import '@fontsource/libre-franklin/600.css';
import { WebAudioBank } from './audio/webaudio';
import { timelineDepth } from './flash/clip';
import { isTyping } from './flash/stage';
import { Runtime } from './runtime';
import { Accueil, type Section } from './scenes/accueil';
import { Cv } from './scenes/cv';
import { Info } from './scenes/info';
import { Lien } from './scenes/lien';
import { Multimedia } from './scenes/multimedia';
import { Preload } from './scenes/preload';
import { BtPleinEcran } from './symbols/btPleinEcran';
import { BtRetour } from './symbols/btRetour';
import { Degrade } from './symbols/degrade';
import { EditeurTheme } from './theme/editeur';
import { installRotateHint } from './ui/rotateHint';

function boot(): void {
  const canvas = document.getElementById('stage') as HTMLCanvasElement;
  const bank = new WebAudioBank();
  // Le premier geste (clic pour ajouter un point, toucher, touche) débloque le son.
  window.addEventListener('pointerdown', () => bank.unlock());
  window.addEventListener('keydown', () => bank.unlock());

  const rt = new Runtime(canvas, bank);

  // _level0 : le fond du préchargement.
  const fond = rt.stage.root.addChildAt(new Degrade(), timelineDepth(1));
  fond.x = 490;
  fond.y = 365;

  // _level10 : l'interface, invisible jusqu'à « entrer ».
  rt.level10.visible = false;
  new Preload(rt, bank, () => startInterface(rt));

  rt.stage.start();
  installRotateHint();
  if (import.meta.env.DEV) Object.assign(window, { romdur: rt });
}

/** Frame 3 d'interface.swf : fond, bouton du coin en fondu, puis l'accueil. */
function startInterface(rt: Runtime): void {
  const L10 = rt.level10;
  const degrade = L10.addChildAt(new Degrade(), timelineDepth(1));
  degrade.x = 490;
  degrade.y = 365;

  // À l'emplacement de l'ancien bouton « quitter ».
  const pleinEcran = L10.addChildAt(new BtPleinEcran(rt.sounds, () => rt.stage.toggleFullscreen()), timelineDepth(6));
  pleinEcran.x = 956.45;
  pleinEcran.y = 22.15;
  rt.tween.mouvement(pleinEcran, 'alpha', 0, 100, 0, 25, 'easeInOutSine');

  // Éditeur de thème : bouton « outil » entre retour et plein écran, panneau à droite.
  const editeur = new EditeurTheme(rt, degrade);
  rt.tween.mouvement(editeur.optionBtn, 'alpha', 0, 100, 0, 25, 'easeInOutSine');

  rt.btRetour = L10.addChildAt(new BtRetour(rt.sounds), timelineDepth(9));
  rt.btRetour.x = 901.95;
  rt.btRetour.y = 22.85;
  // Inutile dans le menu : caché au départ, il apparaît avec les sections.
  rt.btRetour.visible = false;
  rt.btRetour.alpha = 0;
  const montreRetour = (visible: boolean): void => {
    const bt = rt.btRetour;
    if (visible) {
      bt.visible = true;
      rt.tween.mouvement(bt, 'alpha', undefined, 100, 0, 15, 'easeInOutSine');
    } else {
      rt.tween.mouvement(bt, 'alpha', undefined, 0, 0, 15, 'easeInOutSine', undefined, () => {
        bt.visible = false;
        bt.xscale = bt.yscale = 100;
      });
    }
  };

  // Raccourcis du bouton retour : Échap, ou un clic dans le vide. Ils ne font rien tant
  // que la scène en cours n'a pas branché d'action sur le bouton (menu, transitions).
  const retour = (): void => rt.btRetour.onRelease?.call(rt.btRetour);
  rt.stage.onEmptyClick(retour);
  window.addEventListener('keydown', (e) => {
    if (e.key === 'Escape' && !isTyping(e)) retour();
  });

  L10.visible = true;

  const sections: Record<Section, (back: () => void) => void> = {
    cv: (back) => new Cv(rt, back),
    multimedia: (back) => new Multimedia(rt, back),
    lien: (back) => new Lien(rt, back),
    info: (back) => new Info(rt, back),
  };
  const openAccueil = (): void => {
    if (rt.btRetour.visible) montreRetour(false);
    new Accueil(rt, (section) => {
      montreRetour(true);
      sections[section](openAccueil);
    });
  };
  openAccueil();
}

boot();
