# romdur (2004) : carte du code original

Document de référence pour le portage en TypeScript. Sources :
- `original/preload.swf` : décompilé maison, voir `docs/decompile/preload.*` ;
- `original/interface.swf` : extraction JPEXS dans `docs/decompile/interface/` (notes : `docs/decompile/jpexs.md`).

## 1. Vue d'ensemble

| | |
|---|---|
| Format | Flash 6, ActionScript 1/2, 25 images/s |
| Scène | **980 × 730** (le HTML l'affichait en 980×600, donc réduite) |
| Origine | Tout est centré en (490, 365) ; l'axe Y du 3D est inversé à l'écran (`_y = -screenPos.y`) |
| Fond | Dégradé radial `[0xCCCCCC → 0xAFAFAF]`, carré 500×500 centré, peint sur 980×730 (`degrade`) |
| Polices | Franklin Gothic Medium (normal + gras), Lucida Console (vide) |

Chaîne de chargement :

```
site.htm
 └─ preload.swf (_level0)
     ├─ XML.load("externdata/data_romdur.txt")  → tableaux _global.data_*
     ├─ loadMovie("interface.swf", _level10)    → frame 1 : stop
     │     └─ preload fait _level10.nextFrame() → frame 2 : moteur MoteurMv
     ├─ préchargement séquentiel des 47 sons → _global[snd_xxx] = new Sound()
     └─ bouton « entrer » → animation de sortie → _level10.nextFrame() → frame 3 : démarrage
```

`_root` dans `interface.swf` = `_level10` ; les moteurs vivent dans `_level0` (`_level0.MoteurMv`, `_level0.MoteurApi`).

## 2. preload.swf (écran « chargement »)

- **Univers de particules** (`univ`, sprite 1) : petit moteur 3D autonome (`Vector3d`, `Particle3d`, `Repere3d`, perspective 500).
  - Au départ, une seule particule en (-200, 200, 0), tournée d'un angle Z aléatoire.
  - `onMouseDown` : ajoute une particule à la position de la souris, 50 au maximum (texte « cliquez pour ajouter d'autres points »).
  - `onEnterFrame` : `rotateXY(_ymouse/100, _xmouse/100)`. On obtient l'ellipse de points de la capture `scene-preload.jpg`.
  - Mise à l'échelle des particules : `scale × pers × 1.5` ; profondeur triée par `swapDepths(100000 - z×100)`.
- **Trois barres de progression** : données, interface, samples. Les sons se chargent un par un ; le nom du son en cours et son pourcentage s'affichent.
- **« entrer »** : visible quand interface et samples sont chargés.
  - Survol : `snd_multi_evt_1`.
  - Clic : chaque particule part en z=1000 (`easeInSine`, 15 images, décalées), le conteneur passe en fondu, puis `_level10.nextFrame()`.
- En haut à gauche, « romdur.com » : lien `mailto:contact@romdur.com`.

## 3. Données : `externdata/data_romdur.txt`

Fichier Latin-1, enveloppé dans `<xml>…</xml>`, 6 blocs séparés par `§`, enregistrements séparés par `#`, champs par `|` :

| Bloc | Contenu | État en 2016 |
|---|---|---|
| 0 | menus de liens `id\|nom\|info` | 6 menus vides (`1\|\|`…`6\|\|`) |
| 1 | sites `id\|menuParent\|nom\|capture\|info\|lien\|genre` | vide |
| 2 | audio `id\|nom\|auteur\|album\|genre\|annee\|note\|temps\|poids\|fichier` | vide |
| 3 | web `id\|nom\|lien\|date\|fichier\|info\|technique` | vide |
| 4 | flash `id\|nom\|genre\|fichier\|description\|image\|poids` | vide |
| 5 | **sons** `nom_logique\|fichier_mp3` | 60 entrées → 47 fichiers |

Le bloc 5 est le seul qui compte pour la nouvelle version. Il deviendra un `sounds.json`.

## 4. Moteurs (interface.swf, frames 2 et 3, sprite 173)

### MoteurMv : interpolations à l'image (frame 2)
- File d'attente indexée par numéro d'image (`mouvsAttente[frame]`) et liste active (`mouvs[nom]`). La clé `nom` est unique par cible et propriété : un nouveau mouvement écrase l'ancien.
- Chaque mouvement : `a++` à chaque image, `valeur = Math[easing](a, dep, delta, durée)`. À `a == durée`, appel de `onStop`.
- Types de mouvement :
  - `mouvement` : propriété de clip, tronquée avec `int()` ;
  - `Rmouvement` : position 3D d'un point, `Math.round` ;
  - `Rrotation`, `RrotationRelative`, `RscaleRelative` ;
  - `volume` / `pan` : son ;
  - `apiMouv` : style de dessin ;
  - `retardateur` : minuterie pure, avec `onStart` et `onStop`.
- Les durées et délais sont **en images à 25 i/s**. À conserver pour garder le rythme.

### Bibliothèque mathématique / 3D (sprite 173, d'après Robert Penner)
- `Repere3d` : tableau de points, avec des rotations par point, par plage d'indices (`rotateObjectX(idDébut, idFin, angle)`) ou relatives à un point pivot ; translations et échelles.
- `Point3d` : point avec un clip « point » (trait de 2 px, `0x475656`) ; `Particle3d` : clip attaché.
- Les 32 easings de Penner (`linearTween`, `easeInSine`… `easeInOutBounce`), plus `sinD`/`cosD` en degrés.
- Classe `Vector` 2D et primitives de dessin (`drawQuad`, `drawRect`, `drawPoly`…).
- Générateurs de formes : `getCube3dPoints` (8 points), `getCercle3dPoints` (17 points de contrôle pour des `curveTo`), `getEtoile3dPoints`, `getCarre3dPoints`.

### MoteurApi : rendu vectoriel (frame 3)
- Registre d'objets de dessin `apiOn` / `apiOff`, redessinés à chaque image : `mc.clear()`, puis le tracé.
- Types de tracé :
  - `standardLine` / `standardCurve` ;
  - `standardFillLine` / `standardFillCurve` ;
  - `cercle` / `cercleCutted` ;
  - `liaisonCylindre` / `liaisonCerclePic` ;
  - `etoile` ;
  - `cube` (6 faces en `drawQuad`).
- Chaque type existe en version style **global** (`style[styleId]`) et **local** (tableau propre, animable).
- Styles `[épaisseur, couleurTrait, alphaTrait, couleurFond, alphaFond]` :
  - 0 : `[1, 0x3E4A4D, 40, 0xD3D6D6, 20]` ;
  - 1 : `[1, 0x3E4A4D, 50, 0x4E5E61, 10]` ;
  - 2 : `[1, 0x16343F, 50, 0xFFFFFF, 20]`.
- C'est ce qui donne le rendu filaire translucide des captures. Les styles sont modifiables par l'éditeur de thème.

### Démarrage (frame 3)
- `_global.Data = ["I","II","III","IV"]` : libellés des 4 boutons du menu.
- Boutons `option_btn`, `bt_retour`, `bt_quitter` en fondu ; requête `concat.php` pour les thèmes.
- `attachMovie("E")` : menu d'accueil.

## 5. Scènes

| Scène | Sprite | Entrée | Sons principaux |
|---|---|---|---|
| Accueil / menu | `E` (11), échelle 70 % | frame 3, ou retour depuis une section | `snd_menu_*` |
| I : CV | `cv` (80) | bouton I (id 19) | `snd_cv_*` |
| II : Multimédia | `multimedia` (12), le plus gros (1 739 lignes) | bouton II (id 20) | `snd_multi_*` |
| III : Liens | `lien` (79) | bouton III (id 21) | `snd_lien_*` |
| IV : Info | `info` (126), 5 cubes I à V | bouton IV (id 22) | `snd_info_*` |
| Configuration | `colorPatch` (195), `preset_mc` (194), `colorControl*` (167, 169) | `option_btn` | — |

Captures probables : `scene-1` = CV ou Liens (plaques), `scene-2` = Info (cubes I à V + cercle), `scene-3` = Liens (plaques alignées en profondeur). À confirmer avec Ruffle.

### Accueil (`E`)
- **Géométrie** (environ 186 points) :
  - un parallélépipède 900×20×20 (l'axe horizontal) ;
  - des étoiles et carrés aux extrémités ;
  - les 4 boutons `BT` sur un anneau (rotation X de 45° + 90°·i) ;
  - un cylindre central (2 cercles + liaisons) ;
  - un cercle « pic » à 4 rayons ;
  - 4 petits cercles à droite.
- Positions de repos sauvegardées dans `accueil[]` (`saveRepere`).
- **Intro** (premier passage) :
  - tous les points partent de (0, 0, 600) et vont à leur position, avec 0,3 image de décalage chacun, sur 30 images en `easeOutSine` ;
  - les lignes s'allument une par une (une toutes les 2 images, avec `snd_menu_intro_2`) ;
  - puis l'ambiance démarre.
- **Retour** depuis une section : animation v1 (96 % des cas) ou v0 (4 %).
- **Interaction continue** :
  - rotation X des objets selon la souris (`_ymouse/60` et `_xmouse/120`) ;
  - le cylindre central suit la souris en X, avec un amortissement.
- **Son d'ambiance** (sprite 199, `soundAmbient_accueil`) : `snd_menu_amb_1` panoramique = x du cylindre / 3 ; volume de `snd_menu_amb_2` = (x + 300) / 6.
- **Survols** :
  - petits cercles : tremblement, changement de style, `snd_menu_cercle_a/b` ;
  - cercle central : flash d'alpha, `snd_menu_central` ;
  - bouton : tremblement en X, balayage d'un dégradé, `snd_menu_bt`.
- **Sortie** (`sortieAccueil`) : fondu des ambiances, éclatement en X puis Z puis Y (`easeOutExpo`), `snd_menu_sortie` ×3, puis la section est attachée.

### Configuration (éditeur de thème)
- Panneau qui glisse depuis la droite (`colorPatch._x` 1100 → 865).
- Curseurs RVB + alpha pour le trait et le fond de 2 styles, plus les 2 couleurs du dégradé de fond : 19 valeurs.
- Présélections chargées depuis MySQL (`concat.php`), 6 par page ; enregistrement par `ajoption.php` avec le nom du thème et le nom du créateur.

### Contenu « vide »
Les sous-parties de Multimédia (audio, flash, web) et les fiches Liens affichent des listes construites depuis les données, vides depuis 2016. Les panneaux de CV (`cv_qui`, `cv_competence`, `cv_qualification`) ne contiennent plus qu'un rectangle et un titre. Les dialogues « télécharger .exe/.fla » ne peuvent plus apparaître.

## 6. Pièges pour le portage

- **AS1/AS2 en SWF v6 ne distingue pas les majuscules** : `Mouvs` = `mouvs`, `vector3d` = `Vector3d`, `Mouvement` = `mouvement`. Le code s'en sert, souvent sans le vouloir.
- `random(n)` donne un entier dans [0, n-1] ; `int()` tronque.
- Le volume Flash va de 0 à 100 mais le code monte jusqu'à **150** (amplification) ; le panoramique va de -100 à 100.
- Sons créés par `new Sound()` sans cible : vérifié à l'oreille contre Ruffle, chaque son garde **son propre** volume et son propre panoramique, et `stop()` n'arrête que ce son (pas de volume global partagé).
- `for…in` sur les tableaux associatifs : l'ordre d'itération Flash est l'inverse de l'ordre d'insertion. Ça peut changer l'ordre de dessin.
- Profondeur : les points sont triés par `swapDepths(z)`, mais les objets de dessin ont des profondeurs fixes (1000, 10001…). Le tri n'est donc pas par face : il faut le reproduire tel quel.
- Les traits Flash suivent l'échelle du clip : `E` est à 70 %, donc des traits « 1 px » valent 0,7 px. À reproduire en haute définition.
- Le dégradé de fond est peint sur la zone 980×730 seulement. En plein écran, il faudra l'étendre au-delà.

## 7. Outils

- Référence vivante : `tools/ruffle/` (Ruffle), lancer `python3 tools/ruffle/server.py 8000`.
- Désassembleur AVM1 maison (sans Java) : `tools/swfdis.py fichier.swf > out.txt`, puis `tools/avm1js.py out.txt` pour obtenir un pseudo-JS.
- Sorties pour `preload.swf` : `docs/decompile/preload.pseudo.js.txt` (lisible) et `preload.bytecode.txt` (brut).
