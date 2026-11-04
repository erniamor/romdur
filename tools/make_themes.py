"""Génère reborn/public/data/themes.json : thèmes fixes de l'éditeur, au format de l'original
(positions des 24 curseurs : style 0 [épaisseur, R, V, B, alpha trait, R, V, B, alpha fond],
style 1 [idem], dégradé [R, V, B centre, R, V, B bord]).

Usage : python3 tools/make_themes.py
"""
import json, os

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DATE = '2026-11-03 00:00:00'

def y_ep(bt):    return round((5 - bt) * 12.7, 1)
def y_col(c):    return round((128 - min(max(c, 2), 254)) / 2, 1)
def y_alpha(a):  return round((50 - a) * 127 / 100, 1)
def rgb(h):      return [(h >> 16) & 255, (h >> 8) & 255, h & 255]

def style(bt, trait, a_trait, fond, a_fond):
    return [y_ep(bt), *map(y_col, rgb(trait)), y_alpha(a_trait), *map(y_col, rgb(fond)), y_alpha(a_fond)]

def theme(nom, s0, s1, centre, bord):
    config = style(*s0) + style(*s1) + [*map(y_col, rgb(centre)), *map(y_col, rgb(bord))]
    return {'nom': nom, 'pseudo': 'romdur', 'config': config, 'date': DATE}

THEMES = [
    # Les valeurs d'origine (frame 3 et sprite 172).
    theme('romdur',  (1, 0x3E4A4D, 40, 0xD3D6D6, 20), (1, 0x3E4A4D, 50, 0x4E5E61, 10), 0xCCCCCC, 0xAFAFAF),
    theme('nuit',    (1, 0xC8D2D6, 45, 0x8A9AA0, 12), (1, 0xDDE6EA, 55, 0x2E3A40, 25), 0x3A4045, 0x15181B),
    theme('sépia',   (1, 0x5A4630, 45, 0xF0E2CC, 22), (1, 0x5A4630, 55, 0x7A5E3E, 12), 0xE6D8C0, 0xB8A27E),
    theme('glacier', (1, 0x2E5266, 40, 0xFEFEFE, 25), (1, 0x2E5266, 50, 0x4F7F96, 12), 0xE8F2F6, 0xA9C3CF),
    theme('encre',   (2, 0x111111, 70, 0xFEFEFE, 10), (1, 0x111111, 80, 0x222222, 8),  0xF2F2F2, 0xD6D6D6),
]

with open(os.path.join(ROOT, 'reborn/public/data/themes.json'), 'w') as f:
    json.dump(THEMES, f, ensure_ascii=False, indent=1)
print(len(THEMES), 'thèmes')
