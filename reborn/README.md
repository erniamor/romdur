# romdur : nouvelle version (TypeScript)

Reconstruction de romdur.com (Flash 6, 2004) en TypeScript + Canvas 2D, sans dépendance d'exécution
(seule la police Libre Franklin est embarquée).

```sh
npm install
npm run dev        # http://localhost:5173 (expose window.romdur pour le débogage)
npm run build      # site statique dans dist/, déployable dans n'importe quel dossier
npm run preview    # sert dist/
```

Touche **F** : plein écran.

## Pages

| Page | Rôle |
|---|---|
| `index.html` | Accueil : texte d'origine de 2004 (style d'époque) et présentation de romdur reborn (style 2026), liens « entrer » et « Interview avec l'IA » |
| `site.html` | Le site romdur reborn (canvas, `src/main.ts`) |
| `interview.html` | Interview avec l'IA (questions : `<p class="question">`, réponses : `<p class="reponse">`) |

Les pages de texte partagent `src/pages/pages.css`.

## Organisation

| Dossier | Rôle | Origine Flash |
|---|---|---|
| `src/flash/` | Mini « lecteur Flash » : `Clip` (MovieClip avec profondeurs et `swapDepths`), `Graphics` (API de dessin), `TextField`, `Stage` (980×730 à 25 i/s, mise à l'échelle HD, souris et tactile) | le lecteur Flash |
| `src/engine/easing.ts` | Équations de Penner (`Back` avec s = 2), `random`, `int` | sprite 173 |
| `src/engine/space3d.ts` | `Vector3d`, `Repere3d`, `Point3d`, `Particle3d` | sprite 173 |
| `src/engine/shapes3d.ts` | Générateurs cube, cercle, étoile, carré | frame 3 |
| `src/engine/tween.ts` | `TweenEngine` = MoteurMv (mouvements à l'image, file d'attente, sons) | frame 2 |
| `src/engine/api.ts` | `ApiEngine` = MoteurApi (rendu filaire, styles globaux et locaux) | frame 3 |
| `src/symbols/` | Symboles de bibliothèque : bouton `BT`, fond `degrade`, `btRetour`, `btPleinEcran`, `infoCube` | sprites 7, 10, 130, 172, 179, 182 |
| `src/scenes/` | Scènes : `preload` (préchargement), `accueil` (sprite `E`), `cv` (section I), `multimedia` (section II), `lien` (section III), `info` (section IV) | preload.swf, sprites 11, 12, 79, 80, 126 |
| `src/audio/` | Sons Web Audio (`webaudio.ts` : volume et panoramique propres à chaque son, vérifié contre l'original), chargement avec progression | `_global.snd_*` |
| `src/theme/` | Éditeur de thème : panneau à curseurs, présélections, sauvegarde (`presets.ts` : JSON + navigateur) | sprites 145, 154–197 |
| `src/ui/` | Invitation à tourner le téléphone | |
| `public/` | `data/sounds.json` (nom logique → mp3) et `sounds/*.mp3` (`../tools/extract_sounds.py`) ; `data/themes.json`, thèmes fixes (`../tools/make_themes.py`) | `externdata/`, base MySQL |
| `src/runtime.ts` | `_level0` / `_level10` / `_global` : scène, moteurs, sons | |

## Principes de portage

- Le code des scènes suit l'original instruction par instruction, avec les mêmes indices de points ;
  les bizarreries d'origine qui ont un effet visible sont conservées et commentées.
- Les durées restent en images à 25 i/s : c'est le rythme d'origine.
- Ordre d'une image : `onEnterFrame` des clips, puis MoteurMv, puis MoteurApi.
- Repère : origine au centre (490, 365), axe Y 3D inversé à l'écran.
- Profondeurs : les éléments posés dans la timeline Flash vivent sous zéro (`timelineDepth`),
  les clips créés par le code au-dessus ; sans cette règle, ils s'écrasent mutuellement.

Voir `../docs/carte-du-code.md` pour la carte complète de l'original.
