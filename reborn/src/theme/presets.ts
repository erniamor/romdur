import { asset } from '../audio/loader';

/**
 * Un thème, au format de l'original (table MySQL `style`) : `config` contient les positions
 * des 24 curseurs de l'éditeur (style 0, style 1, dégradé).
 */
export interface Preset {
  nom: string;
  pseudo: string;
  config: number[];
  /** Format MySQL d'origine : « AAAA-MM-JJ HH:MM:SS ». */
  date: string;
}

const STORAGE_KEY = 'romdur.themes';

/** Remplace concat.php : thèmes fixes (public/data/themes.json) puis ceux de ce navigateur, par date. */
export async function chargePresets(): Promise<Preset[]> {
  let fixes: Preset[] = [];
  try {
    const res = await fetch(asset('data/themes.json'));
    if (res.ok) fixes = await res.json();
  } catch (e) {
    console.warn('Thèmes fixes indisponibles', e);
  }
  return [...fixes, ...presetsLocaux()].sort((a, b) => a.date.localeCompare(b.date));
}

function presetsLocaux(): Preset[] {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    const list: unknown = raw ? JSON.parse(raw) : [];
    return Array.isArray(list) ? list.filter(estPreset) : [];
  } catch {
    return [];
  }
}

function estPreset(p: unknown): p is Preset {
  const o = p as Preset;
  return !!o && typeof o.nom === 'string' && typeof o.pseudo === 'string' && typeof o.date === 'string'
    && Array.isArray(o.config) && o.config.length === 24 && o.config.every((n) => typeof n === 'number');
}

/** Remplace ajoption.php : le thème est enregistré dans ce navigateur. Renvoie faux si c'est impossible. */
export function enregistrePreset(nom: string, pseudo: string, config: number[]): boolean {
  const preset: Preset = { nom, pseudo, config, date: dateMysql(new Date()) };
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify([...presetsLocaux(), preset]));
    return true;
  } catch {
    return false;
  }
}

function dateMysql(d: Date): string {
  const p = (n: number) => String(n).padStart(2, '0');
  return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())} ${p(d.getHours())}:${p(d.getMinutes())}:${p(d.getSeconds())}`;
}
