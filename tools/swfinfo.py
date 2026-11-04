"""Inspecteur SWF : placements (matrices, noms), champs texte, textes statiques, formes (chemins SVG).

Usage : python3 tools/swfinfo.py original/preload.swf [--shapes]
Unités : pixels (twips / 20).
"""
import sys, zlib, struct


class Bits:
    def __init__(self, data, pos=0):
        self.d = data; self.byte = pos; self.bit = 0

    def ub(self, n):
        v = 0
        for _ in range(n):
            b = (self.d[self.byte] >> (7 - self.bit)) & 1
            v = (v << 1) | b
            self.bit += 1
            if self.bit == 8: self.bit = 0; self.byte += 1
        return v

    def sb(self, n):
        if n == 0: return 0
        v = self.ub(n)
        if v & (1 << (n - 1)): v -= 1 << n
        return v

    def fb(self, n):
        return self.sb(n) / 65536.0

    def align(self):
        if self.bit: self.bit = 0; self.byte += 1
        return self.byte


def rect(bs):
    n = bs.ub(5)
    xmin, xmax, ymin, ymax = (bs.sb(n) / 20 for _ in range(4))
    return (xmin, ymin, xmax, ymax)


def matrix(bs):
    sx = sy = 1.0; r0 = r1 = 0.0
    if bs.ub(1):
        n = bs.ub(5); sx = bs.fb(n); sy = bs.fb(n)
    if bs.ub(1):
        n = bs.ub(5); r0 = bs.fb(n); r1 = bs.fb(n)
    n = bs.ub(5); tx = bs.sb(n) / 20; ty = bs.sb(n) / 20
    bs.align()
    return dict(a=sx, b=r0, c=r1, d=sy, tx=tx, ty=ty)


def cxform(bs, alpha):
    ha, hm = bs.ub(1), bs.ub(1); n = bs.ub(4); k = 4 if alpha else 3
    mult = [bs.sb(n) for _ in range(k)] if hm else None
    add = [bs.sb(n) for _ in range(k)] if ha else None
    bs.align()
    return dict(mult=mult, add=add)


def rgb(d, p, alpha):
    if alpha:
        return '#%02x%02x%02x' % tuple(d[p:p+3]) + ('' if d[p+3] == 255 else f'@{d[p+3]/255:.2f}'), p + 4
    return '#%02x%02x%02x' % tuple(d[p:p+3]), p + 3


def cstr(d, p):
    e = d.index(0, p)
    return d[p:e].decode('utf-8', 'replace'), e + 1


FONTS = {}


def fmtm(m):
    s = f'tx={m["tx"]:g} ty={m["ty"]:g}'
    if (m['a'], m['d']) != (1, 1): s += f' sx={m["a"]:.4g} sy={m["d"]:.4g}'
    if (m['b'], m['c']) != (0, 0): s += f' r0={m["b"]:.4g} r1={m["c"]:.4g}'
    return s


def fill_styles(d, p, shape_ver):
    n = d[p]; p += 1
    if n == 0xFF and shape_ver >= 2: n = struct.unpack('<H', d[p:p+2])[0]; p += 2
    out = []
    for _ in range(n):
        t = d[p]; p += 1
        if t == 0:
            c, p = rgb(d, p, shape_ver >= 3); out.append(f'solid {c}')
        elif t in (0x10, 0x12):
            bs = Bits(d, p); m = matrix(bs); p = bs.byte
            k = d[p] & 15; p += 1; stops = []
            for _ in range(k):
                r = d[p]; p += 1; c, p = rgb(d, p, shape_ver >= 3); stops.append(f'{r}:{c}')
            out.append(f'{"linear" if t == 0x10 else "radial"} [{fmtm(m)}] {" ".join(stops)}')
        elif t in (0x40, 0x41, 0x42, 0x43):
            bid = struct.unpack('<H', d[p:p+2])[0]; p += 2
            bs = Bits(d, p); m = matrix(bs); p = bs.byte
            out.append(f'bitmap {bid} [{fmtm(m)}]')
        else:
            out.append(f'?fill {t}'); break
    return out, p


def line_styles(d, p, shape_ver):
    n = d[p]; p += 1
    if n == 0xFF: n = struct.unpack('<H', d[p:p+2])[0]; p += 2
    out = []
    for _ in range(n):
        w = struct.unpack('<H', d[p:p+2])[0] / 20; p += 2
        c, p = rgb(d, p, shape_ver >= 3); out.append(f'{w}px {c}')
    return out, p


def shape_records(d, p, shape_ver, nfill, nline, font=False):
    """Retourne une liste de sous-chemins [(fill0, fill1, line, d_svg)]."""
    bs = Bits(d, p)
    fb, lb = bs.ub(4), bs.ub(4)
    x = y = 0.0; paths = []; cur = None; f0 = f1 = ln = 0

    def start():
        nonlocal cur
        cur = [f0, f1, ln, f'M{x:g} {y:g}']; paths.append(cur)
    while True:
        if bs.ub(1) == 0:
            flags = bs.ub(5)
            if flags == 0: break
            if flags & 1:
                n = bs.ub(5); x = bs.sb(n) / 20; y = bs.sb(n) / 20
            if flags & 2: f0 = bs.ub(fb)
            if flags & 4: f1 = bs.ub(fb)
            if flags & 8: ln = bs.ub(lb)
            if flags & 16:
                p2 = bs.align()
                fs, p2 = fill_styles(d, p2, shape_ver); ls, p2 = line_styles(d, p2, shape_ver)
                paths.append(['newstyles', fs, ls, ''])
                bs = Bits(d, p2); fb, lb = bs.ub(4), bs.ub(4)
            start()
        else:
            if cur is None: start()
            if bs.ub(1):
                n = bs.ub(4) + 2
                if bs.ub(1):
                    x += bs.sb(n) / 20; y += bs.sb(n) / 20
                elif bs.ub(1):
                    y += bs.sb(n) / 20
                else:
                    x += bs.sb(n) / 20
                cur[3] += f' L{x:g} {y:g}'
            else:
                n = bs.ub(4) + 2
                cx = x + bs.sb(n) / 20; cy = y + bs.sb(n) / 20
                x = cx + bs.sb(n) / 20; y = cy + bs.sb(n) / 20
                cur[3] += f' Q{cx:g} {cy:g} {x:g} {y:g}'
    return paths


def define_shape(code, d, out, ind, show):
    ver = {2: 1, 22: 2, 32: 3}[code]
    sid = struct.unpack('<H', d[:2])[0]
    bs = Bits(d, 2); b = rect(bs); p = bs.align()
    fs, p = fill_styles(d, p, ver); ls, p = line_styles(d, p, ver)
    out.append(f'{ind}Shape {sid} bounds={b} fills={fs} lines={ls}')
    if show:
        for f0, f1, ln, path in shape_records(d, p, ver, len(fs), len(ls)):
            if f0 == 'newstyles': out.append(f'{ind}  newstyles fills={f1} lines={ln}'); continue
            out.append(f'{ind}  f0={f0} f1={f1} l={ln} d="{path}"')


def define_font2(d, out, ind):
    fid = struct.unpack('<H', d[:2])[0]; fl = d[2]; nl = d[4]
    name = d[5:5+nl].decode('latin1').rstrip('\0'); p = 5 + nl
    ng = struct.unpack('<H', d[p:p+2])[0]; p += 2
    wide = fl & 0x08; wcodes = fl & 0x04
    offs = []
    for _ in range(ng):
        if wide: offs.append(struct.unpack('<I', d[p:p+4])[0]); p += 4
        else: offs.append(struct.unpack('<H', d[p:p+2])[0]); p += 2
    code_off = struct.unpack('<I' if wide else '<H', d[p:p+(4 if wide else 2)])[0]
    base = 5 + nl + 2
    cp = base + code_off
    codes = []
    for _ in range(ng):
        if wcodes: codes.append(struct.unpack('<H', d[cp:cp+2])[0]); cp += 2
        else: codes.append(d[cp]); cp += 1
    FONTS[fid] = dict(name=name, codes=codes)
    out.append(f'{ind}Font {fid} {name!r} bold={bool(fl & 1)} chars={"".join(chr(c) for c in codes)!r}')


def define_text(code, d, out, ind):
    tid = struct.unpack('<H', d[:2])[0]
    bs = Bits(d, 2); b = rect(bs); bs.align(); m = matrix(bs); p = bs.byte
    gb, ab = d[p], d[p+1]; p += 2
    font = None; color = None; h = None; xo = yo = 0; lines = []
    while d[p] != 0:
        f = d[p]; p += 1
        if f & 0x08: font = struct.unpack('<H', d[p:p+2])[0]; p += 2
        if f & 0x04: color, p = rgb(d, p, code == 33)
        if f & 0x01: xo = struct.unpack('<h', d[p:p+2])[0] / 20; p += 2
        if f & 0x02: yo = struct.unpack('<h', d[p:p+2])[0] / 20; p += 2
        if f & 0x08: h = struct.unpack('<H', d[p:p+2])[0] / 20; p += 2
        n = d[p]; p += 1
        bs = Bits(d, p); s = ''
        for _ in range(n):
            gi = bs.ub(gb); bs.sb(ab)
            codes = FONTS.get(font, {}).get('codes', [])
            s += chr(codes[gi]) if gi < len(codes) else '?'
        p = bs.align()
        lines.append(f'"{s}" font={font} h={h} color={color} at=({xo},{yo})')
    out.append(f'{ind}Text {tid} bounds={b} [{fmtm(m)}] ' + ' | '.join(lines))


def define_edit_text(d, out, ind):
    tid = struct.unpack('<H', d[:2])[0]
    bs = Bits(d, 2); b = rect(bs); p = bs.align()
    f1, f2 = d[p], d[p+1]; p += 2
    info = []
    if f1 & 0x01:
        info.append(f'font={struct.unpack("<H", d[p:p+2])[0]} h={struct.unpack("<H", d[p+2:p+4])[0] / 20}'); p += 4
    if f1 & 0x04:
        c, p = rgb(d, p, True); info.append(f'color={c}')
    if f1 & 0x02:
        info.append(f'maxlen={struct.unpack("<H", d[p:p+2])[0]}'); p += 2
    if f2 & 0x20:
        al, lm, rm, indent, lead = d[p], *struct.unpack('<HHHh', d[p+1:p+9]); p += 9
        info.append(f'align={["left", "right", "center", "justify"][al]} margins={lm/20},{rm/20} leading={lead/20}')
    var, p = cstr(d, p)
    if var: info.append(f'var={var!r}')
    if f1 & 0x80:
        t, p = cstr(d, p); info.append(f'text={t!r}')
    fl = []
    for bit, nm in ((0x40, 'wordwrap'), (0x20, 'multiline'), (0x10, 'password'), (0x08, 'readonly')):
        if f1 & bit: fl.append(nm)
    for bit, nm in ((0x10, 'autosize'), (0x08, 'noselect'), (0x04, 'border'), (0x02, 'html'), (0x01, 'useoutlines')):
        if f2 & bit: fl.append(nm)
    out.append(f'{ind}EditText {tid} bounds={b} {" ".join(info)} [{",".join(fl)}]')


def place2(d, out, ind, ver):
    f = d[0]; dep = struct.unpack('<H', d[1:3])[0]; p = 3; s = f'depth={dep}'
    if f & 0x01: s = 'MOVE ' + s
    if f & 0x02: s += f' char={struct.unpack("<H", d[p:p+2])[0]}'; p += 2
    bs = Bits(d, p)
    if f & 0x04: s += f' [{fmtm(matrix(bs))}]'
    if f & 0x08:
        c = cxform(bs, True); s += f' cx={c}'
    p = bs.byte
    if f & 0x10: s += f' ratio={struct.unpack("<H", d[p:p+2])[0]}'; p += 2
    if f & 0x20:
        nm, p = cstr(d, p); s += f' name={nm!r}'
    if f & 0x40: s += f' clipDepth={struct.unpack("<H", d[p:p+2])[0]}'; p += 2
    if f & 0x80: s += ' +clipActions'
    out.append(f'{ind}Place {s}')


TAGNAMES = {9: 'SetBackgroundColor', 43: 'FrameLabel', 56: 'ExportAssets', 12: 'DoAction', 59: 'DoInitAction', 34: 'DefineButton2',
            14: 'DefineSound', 6: 'DefineBits', 21: 'DefineBitsJPEG2', 35: 'DefineBitsJPEG3', 20: 'DefineBitsLossless', 36: 'DefineBitsLossless2'}


def tags(b, p, end, out, ver, show, depth=0):
    ind = '  ' * depth; frame = 1
    while p < end:
        h = struct.unpack('<H', b[p:p+2])[0]; p += 2
        code, ln = h >> 6, h & 0x3F
        if ln == 0x3F: ln = struct.unpack('<I', b[p:p+4])[0]; p += 4
        d = b[p:p+ln]; p += ln
        if code == 0: break
        if code == 1: out.append(f'{ind}-- frame {frame}'); frame += 1
        elif code == 39:
            out.append(f'{ind}Sprite {struct.unpack("<H", d[:2])[0]} frames={struct.unpack("<H", d[2:4])[0]}')
            tags(d, 4, len(d), out, ver, show, depth + 1)
        elif code in (2, 22, 32): define_shape(code, d, out, ind, show)
        elif code == 48: define_font2(d, out, ind)
        elif code in (11, 33): define_text(code, d, out, ind)
        elif code == 37: define_edit_text(d, out, ind)
        elif code == 26: place2(d, out, ind, ver)
        elif code == 28: out.append(f'{ind}Remove depth={struct.unpack("<H", d[:2])[0]}')
        elif code == 56:
            c = struct.unpack('<H', d[:2])[0]; q = 2; ex = []
            for _ in range(c):
                i = struct.unpack('<H', d[q:q+2])[0]; s, q = cstr(d, q + 2); ex.append(f'{i}:{s}')
            out.append(f'{ind}Export {ex}')
        elif code == 9: out.append(f'{ind}Background #{d[0]:02x}{d[1]:02x}{d[2]:02x}')
        elif code == 43: out.append(f'{ind}FrameLabel {cstr(d, 0)[0]!r}')
        elif code in TAGNAMES: out.append(f'{ind}{TAGNAMES[code]} ({ln} o)' + (f' id={struct.unpack("<H", d[:2])[0]}' if code in (14, 6, 21, 35, 20, 36, 34) else ''))
        else: out.append(f'{ind}tag{code} ({ln} o)')


def main():
    path = sys.argv[1]; show = '--shapes' in sys.argv
    d = open(path, 'rb').read(); ver = d[3]
    b = d[:8] + zlib.decompress(d[8:]) if d[:3] == b'CWS' else d
    bs = Bits(b, 8); r = rect(bs); p = bs.align()
    out = [f'SWF v{ver} stage={r} fps={b[p+1] + b[p] / 256}']
    tags(b, p + 4, len(b), out, ver, show)
    print('\n'.join(out))


if __name__ == '__main__':
    main()
