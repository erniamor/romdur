J’ai décompilé ton interface.swf avec JPEXS : j’ai récupéré environ 8 000 lignes d’ActionScript 2 lisible, ainsi que les formes (en SVG), les images et les textes.

Ce qu’est le fichier : c’est l’interface principale de romdur.com, une vitrine pour Flash 6 (compressée, en AS2). Elle sert de portail avec plusieurs sections :

Animations Flash : une liste. Chaque animation est chargée dans le niveau 66 avec loadMovieNum("externdata/flash/….swf", 66). On peut aussi télécharger l’animation en .exe ou son .fla dans un .rar.
Audio : des boutons « écouter » et « télécharger » (loadSound en streaming).
Web et Liens : des listes de sites avec captures d’écran, ouvertes dans _blank.
Configuration / Présélections : un éditeur de thème de couleurs avec des sliders. On peut l’enregistrer sous un « nom du thème » et un « nom du créateur ».

Comment c’est construit :

Moteur de tween maison (MoteurMv, frame 2) : il tourne sur un onEnterFrame global et utilise une file d’attente indexée par numéro de frame. Il ajoute à MovieClip.prototype les méthodes mouvement, retardateur, et soundVolume/soundPan pour les fondus audio. Les courbes d’easing sont de type Penner (easeOutSine…).
Mini moteur 3D (frame 3) : des repères avec rotation sur X, Y et Z, une projection en perspective et un rendu avec l’API de dessin (drawQuad, cube, cercle, étoile, liaisons cylindre…). Les styles peuvent être locaux ou globaux. Voilà pourquoi le rendu statique d’une frame est presque vide : tout est dessiné par le code à l’exécution.
Back-end PHP : concat.php renvoie les thèmes au format id|nom|pseudo|config_a_b_c|date, séparés par §. ajoption.php reçoit en POST un nouveau thème (var0, var1, var2).
Données externes : les tableaux _global.data_flash, data_audio, data_web et data_lien sont remplis ailleurs, probablement dans un autre SWF ou par les variables du HTML. Les médias sont dans externdata/.

Limites :

Je ne peux pas exécuter le SWF de façon interactive. Je lis le code et je fais le rendu des frames, des formes et des images.
Les noms de variables locales sont parfois perdus (_loc1_…), mais la logique reste claire.
Les fichiers de externdata/ et les PHP ne sont pas dans le SWF, donc je ne peux pas les voir.

Le zip interface_decompile.zip contient tout ce que j’ai extrait. Si c’est ton ancien site et que tu veux le faire revivre, je peux porter le moteur de tween et le moteur 3D en TypeScript avec Canvas ou SVG.