/** Télécharge un fichier en signalant la progression (0–1), comme getBytesLoaded / getBytesTotal. */
export async function fetchWithProgress(url: string, onProgress: (ratio: number) => void): Promise<ArrayBuffer> {
  const res = await fetch(url);
  if (!res.ok) throw new Error(`${url} : HTTP ${res.status}`);
  const total = Number(res.headers.get('content-length')) || 0;
  if (!res.body || !total) {
    const buf = await res.arrayBuffer();
    onProgress(1);
    return buf;
  }
  const reader = res.body.getReader();
  const out = new Uint8Array(total);
  let loaded = 0;
  for (;;) {
    const { done, value } = await reader.read();
    if (done) break;
    if (loaded + value.length > out.length) {
      // Taille annoncée inexacte (compression) : on bascule sur un assemblage simple.
      const rest = [value];
      for (;;) {
        const r = await reader.read();
        if (r.done) break;
        rest.push(r.value);
      }
      const merged = new Uint8Array(loaded + rest.reduce((n, c) => n + c.length, 0));
      merged.set(out.subarray(0, loaded));
      let p = loaded;
      for (const c of rest) {
        merged.set(c, p);
        p += c.length;
      }
      onProgress(1);
      return merged.buffer;
    }
    out.set(value, loaded);
    loaded += value.length;
    onProgress(loaded / total);
  }
  onProgress(1);
  return out.buffer.slice(0, loaded);
}

/** URL d'une ressource de public/, relative à la page (le site peut vivre dans un sous-dossier). */
export function asset(path: string): string {
  return `${import.meta.env.BASE_URL}${path}`;
}
