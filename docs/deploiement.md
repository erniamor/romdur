# Déploiement : Cloudflare Pages + romdur.romain.re

Le site est statique (`reborn/dist/`, ~3,5 Mo). Cloudflare Pages le construit à chaque push sur GitHub
(`erniamor/romdur`) et le sert sur `romdur.romain.re` ; le domaine `romain.re` reste chez OVH.

## Préparé dans le dépôt

| Fichier | Rôle |
|---|---|
| `reborn/.node-version` | Node 22 pour le build (Vite 8 demande ≥ 22.12) |
| `reborn/package.json` → `packageManager` | pnpm 8.15.0, la version qui a produit `pnpm-lock.yaml` (format v6) |
| `reborn/public/_headers` | En-têtes : cache d'un an pour `/assets/*` (noms à empreinte), une semaine pour sons et images, une heure pour `/data/*` ; en-têtes de sécurité et CSP |

## 1. Créer le projet Pages

1. Tableau de bord Cloudflare → **Workers & Pages** → **Create** → onglet **Pages** → **Connect to Git**.
   (Le bouton par défaut propose un Worker : choisir explicitement **Pages**.)
2. Autoriser l'application Cloudflare sur GitHub, limitée au dépôt `erniamor/romdur`.
3. Paramètres de build :

   | Réglage | Valeur |
   |---|---|
   | Production branch | `main` |
   | Framework preset | None (ou Vite) |
   | Build command | `pnpm build` |
   | Build output directory | `dist` |
   | Root directory (advanced) | `reborn` |
   | Variable d'environnement | `PNPM_VERSION` = `8.15.0` |

   `NODE_VERSION` est inutile grâce à `reborn/.node-version`.
4. **Save and Deploy**. Le site est publié sur `https://<projet>.pages.dev`.

## 2. Vérifier sur l'adresse pages.dev

- Accueil, interview, lien « entrer ».
- Préchargement : les sons se chargent, « entrer » apparaît, le son démarre au premier clic.
- Les quatre sections, l'éditeur de thème (et l'enregistrement d'un thème), le plein écran.
- Console du navigateur : aucune erreur `Content-Security-Policy` (sinon, ajuster `_headers`).
- Mobile : invitation à tourner le téléphone, toucher.

## 3. Brancher romdur.romain.re

L'ordre compte : un CNAME créé avant d'avoir déclaré le domaine dans Pages ne fonctionne pas (erreur 522).

1. Projet Pages → **Custom domains** → **Set up a custom domain** → `romdur.romain.re`.
   Cloudflare indique la cible du CNAME (`<projet>.pages.dev`).
2. OVH → **Web Cloud** → **Noms de domaine** → `romain.re` → **Zone DNS** → **Ajouter une entrée** :
   - type **CNAME**, sous-domaine `romdur`, cible `<projet>.pages.dev.` (avec le point final) ;
   - supprimer toute entrée A, AAAA ou CNAME existante pour `romdur`.
3. Attendre la propagation (quelques minutes à quelques heures) : Cloudflare valide le domaine et émet
   le certificat HTTPS automatiquement.

## Ensuite

- Chaque push sur `main` redéploie la production ; chaque autre branche obtient une adresse de
  prévisualisation (`<branche>.<projet>.pages.dev`).
- Retour arrière : Pages → **Deployments** → choisir un déploiement précédent → **Rollback**.
