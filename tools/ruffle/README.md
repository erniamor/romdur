# Original via Ruffle

Fait tourner `original/preload.swf` (qui charge `interface.swf` et `externdata/`) avec l'émulateur Ruffle,
pour comparer avec la nouvelle version.

```sh
cd tools/ruffle && npm install && cd ../..   # une fois : installe Ruffle
python3 tools/ruffle/server.py 8000          # depuis la racine du dépôt
```

Puis ouvrir http://localhost:8000/tools/ruffle/ (ajouter `?shot` pour masquer le bouton de son, utile aux captures).

- Le serveur convertit `data_romdur.txt` de Latin-1 en UTF-8 : Ruffle ignore `System.useCodepage`,
  ce qui cassait le séparateur « § » et empêchait le chargement des sons.
- Les PHP (`concat.php`, `ajoption.php`) ne tournent pas : les thèmes partagés ne se chargent pas.
