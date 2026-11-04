# Journal des décisions (novembre 2026)

Trace des choix faits pendant le reborn, pour les développements futurs.

## Objectif

Une reproduction **fidèle mais modernisée** : l'œuvre (formes, mouvements, rythme, sons, réactions à la
souris) reste identique ; le support (affichage, écrans, saisie, hébergement) est modernisé.
Le site reste **vide de fond**, comme depuis 2016 : c'est une expérience visuelle et sonore, pas un site
d'information. Hébergement statique, sans serveur applicatif.

## Règles de fidélité

- La logique tourne à **25 images/s** fixes : toutes les durées du code d'origine sont en images.
- Le code des scènes suit l'original instruction par instruction, avec les mêmes indices de points.
- Les **bizarreries ayant un effet visible ou audible sont conservées** et commentées dans le code. Exemples :
  - accueil : le premier survol d'un petit cercle tremble 5 images, les suivants une seule (compteur jamais remis à zéro) ;
  - liens : l'intro est lancée deux fois (nappes doublées, vrille cumulée) ;
  - multimédia : la plaque II s'allume quand la III commence sa chute ; l'ambiance web ne suit jamais la profondeur ;
  - 3D : `relativeScale` multiplie par le pivot au lieu du facteur.
- Les **règles du lecteur Flash 6** sont reproduites dans `reborn/src/flash/` : profondeurs et `swapDepths`,
  éléments de timeline à des profondeurs négatives, ordre du `for…in`, `undefined` valant 0, troncature `int()`.
- **Son** (vérifié à l'oreille contre l'original) : chaque son garde son propre volume et son propre
  panoramique ; `stop()` n'arrête que ce son.

## Retiré

- Les panneaux de contenu vides : CV (`cv_qui`, `cv_competence`, `cv_qualification`), fiche d'Info
  (`info_mc`, réduite au mot « romdur »), panneau de Liens (`lien_lic`), panneaux audio et web du multimédia,
  dialogue `flash_quest_mc`. Les temps d'animation sont conservés.
- Les liens « romdur.com » vers `mailto:contact@romdur.com` (préchargement et interface).
- Le bouton « quitter » (`window.close()`), remplacé par un bouton plein écran au même endroit et dans le même style.
- Le back-end PHP/MySQL des thèmes.

## Ajouté ou modernisé

- Rendu Canvas 2D en résolution native (traits nets), mise à l'échelle « showAll » plein écran,
  dégradé de fond étendu à tout l'écran.
- Toucher sur mobile ; invitation discrète « tournez votre téléphone » en portrait.
- Plein écran : bouton et touche **F**.
- **Bouton retour conservé** (seul moyen de sortir d'une section), caché dans le menu où il ne sert à rien,
  avec deux raccourcis : **Échap** et **clic dans le vide**.
- Police **Libre Franklin** (libre) à la place de Franklin Gothic Medium ; un texte qui dépasserait sa
  largeur d'origine est légèrement condensé.
- Éditeur de thème : thèmes fixes dans `reborn/public/data/themes.json` (« romdur », « nuit », « sépia »,
  « glacier », « encre », générés par `tools/make_themes.py`), thèmes des visiteurs enregistrés dans leur
  navigateur. Comme l'original : chaque visite repart sur les couleurs d'origine, et on ne peut pas
  supprimer un thème enregistré. Les champs de saisie sont de vrais champs HTML.
- Page d'accueil (texte de 2004 au style d'époque + présentation 2026), page d'interview, favicon.

## Corrigé (bugs d'origine qui cassaient l'usage)

- Dialogue de sauvegarde : « annuler » visait un clip inexistant, le dialogue ne pouvait plus se rouvrir.
- Le panneau de thème, rangé hors scène, est masqué (il serait visible sur les écrans larges).
- Le fond du panneau et du dialogue absorbent les clics (pas de « clic dans le vide » à travers).

## Non vérifié

- Seuls le préchargement et le menu ont été comparés image par image avec l'original (Ruffle). Les
  sections ont été portées à partir du code et des trois captures d'époque.
- Le son n'a été écouté que par l'auteur, sur le menu. Les ambiances des sections suivent le code.
- Quelques points relèvent d'une interprétation de la sémantique Flash : ordre d'exécution des
  `onEnterFrame` (ici : clips, puis moteur d'animation, puis moteur de dessin), valeur de `this` dans les
  appels non qualifiés, moment d'exécution du code des clips attachés.

## Déploiement prévu

Cloudflare Pages, sur le sous-domaine `romdur.romain.re` (domaine `romain.re` chez OVH).
