# Captures de comparaison

Pilote le Chrome installé (puppeteer-core) pour prendre des captures à des instants donnés,
avec des actions souris. Sert à comparer l'original (Ruffle) et la nouvelle version.

```sh
cd tools/capture && npm install
# node shot.mjs URL PREFIXE_SORTIE "t1,t2,…" '[actions]'
node shot.mjs http://localhost:5173/ /tmp/new "6000" '[{"t":300,"move":[490,400]}]'
node shot.mjs "http://localhost:8000/tools/ruffle/?shot" /tmp/ref "19000" '[{"t":12500,"click":[490,400]}]'
```

Actions (`t` en ms depuis le chargement) : `move: [x, y]`, `click: [x, y]`,
`eval: "expression JS"` (résultat affiché), `clickEval: "expression qui renvoie [x, y]"`.
En développement, la nouvelle version expose `window.romdur` (le Runtime).
