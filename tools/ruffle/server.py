"""Serveur statique pour la référence Ruffle.

Sert la racine du dépôt et convertit à la volée original/externdata/data_romdur.txt
de Latin-1 en UTF-8 : Ruffle ignore System.useCodepage et lit le fichier en UTF-8,
ce qui casse le séparateur « § » et empêche le chargement des samples.
"""
import http.server, os, sys

# tools/ruffle/server.py → racine du dépôt.
ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
DATA = '/original/externdata/data_romdur.txt'

class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *a, **k):
        super().__init__(*a, directory=ROOT, **k)

    def do_GET(self):
        if self.path.split('?')[0] == DATA:
            with open(os.path.join(ROOT, DATA.lstrip('/')), 'rb') as f:
                body = f.read().decode('latin-1').encode('utf-8')
            self.send_response(200)
            self.send_header('Content-Type', 'text/plain; charset=utf-8')
            self.send_header('Content-Length', str(len(body)))
            self.end_headers()
            self.wfile.write(body)
            return
        super().do_GET()

if __name__ == '__main__':
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 8000
    print(f'http://localhost:{port}/tools/ruffle/')
    http.server.ThreadingHTTPServer(('', port), Handler).serve_forever()
