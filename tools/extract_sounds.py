"""Génère reborn/public/data/sounds.json depuis original/externdata/data_romdur.txt (bloc 5 : nom_logique|fichier)
et copie les mp3 utilisés dans reborn/public/sounds/.

Usage : python3 tools/extract_sounds.py
"""
import json, os, re, shutil

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
src = open(os.path.join(ROOT, 'original/externdata/data_romdur.txt'), encoding='latin-1').read()
body = re.sub(r'</?xml>', '', src).strip()
bloc = body.split('§')[5]
sounds = []
for rec in bloc.split('#'):
    name, _, file = rec.partition('|')
    # Original : un fichier vide est remplacé par snd_blank.
    sounds.append({'name': name, 'file': file or 'snd_blank'})

os.makedirs(os.path.join(ROOT, 'reborn/public/data'), exist_ok=True)
os.makedirs(os.path.join(ROOT, 'reborn/public/sounds'), exist_ok=True)
with open(os.path.join(ROOT, 'reborn/public/data/sounds.json'), 'w') as f:
    json.dump(sounds, f, indent=1)
for file in sorted({s['file'] for s in sounds}):
    shutil.copy(os.path.join(ROOT, f'original/externdata/sample/{file}.mp3'), os.path.join(ROOT, f'reborn/public/sounds/{file}.mp3'))
print(len(sounds), 'sons,', len({s['file'] for s in sounds}), 'fichiers')
