import { resolve } from 'node:path';
import { defineConfig } from 'vite';

// base relative : le build fonctionne depuis n'importe quel sous-dossier d'un hébergement statique.
// Trois pages, comme l'original (index.htm → site.htm) : accueil, site, interview.
export default defineConfig({
  base: './',
  build: {
    rollupOptions: {
      input: {
        accueil: resolve(import.meta.dirname, 'index.html'),
        site: resolve(import.meta.dirname, 'site.html'),
        interview: resolve(import.meta.dirname, 'interview.html'),
      },
    },
  },
});
