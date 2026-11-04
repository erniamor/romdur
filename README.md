# romdur

**romdur** (2004) est une interface multimédia en Flash : un espace en trois dimensions où évoluent des objets
simples, animés dans le temps et accompagnés d'un environnement sonore qui suit leurs mouvements.
**romdur reborn** (2026) le fait revivre en TypeScript, fidèlement, à partir des seuls fichiers compilés.

| Dossier | Contenu |
|---|---|
| [`original/`](original/) | Le site d'origine tel qu'il était en ligne : pages HTML, `preload.swf`, `interface.swf`, sons et données (`externdata/`), PHP des thèmes, et captures d'écran d'époque (`screenshots/`) |
| [`reborn/`](reborn/) | Le nouveau site (Vite + TypeScript + Canvas 2D + Web Audio) : accueil, site, interview |
| [`docs/`](docs/) | Documentation du projet reborn : carte du code d'origine, journal des décisions, code décompilé |
| [`tools/`](tools/) | Outils du reborn : décompilation SWF, extraction des sons et des thèmes, original via Ruffle, captures de comparaison |

## Démarrage rapide

```sh
cd reborn
pnpm install        # ou npm install
pnpm dev            # http://localhost:5173
pnpm build          # site statique dans reborn/dist/
```

Pour voir l'original : [`tools/ruffle/`](tools/ruffle/README.md).
