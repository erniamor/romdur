"""Minimal SWF tag lister + AVM1 disassembler (AS1/AS2)."""
import sys, zlib, struct

TAGS = {0:'End',1:'ShowFrame',2:'DefineShape',4:'PlaceObject',5:'RemoveObject',6:'DefineBits',7:'DefineButton',
8:'JPEGTables',9:'SetBackgroundColor',10:'DefineFont',11:'DefineText',12:'DoAction',13:'DefineFontInfo',14:'DefineSound',
15:'StartSound',17:'DefineButtonSound',18:'SoundStreamHead',19:'SoundStreamBlock',20:'DefineBitsLossless',21:'DefineBitsJPEG2',
22:'DefineShape2',24:'Protect',26:'PlaceObject2',28:'RemoveObject2',32:'DefineShape3',33:'DefineText2',34:'DefineButton2',
35:'DefineBitsJPEG3',36:'DefineBitsLossless2',37:'DefineEditText',39:'DefineSprite',43:'FrameLabel',45:'SoundStreamHead2',
46:'DefineMorphShape',48:'DefineFont2',56:'ExportAssets',57:'ImportAssets',58:'EnableDebugger',59:'DoInitAction',62:'DefineFontInfo2',
64:'EnableDebugger2',65:'ScriptLimits',66:'SetTabIndex',69:'FileAttributes',77:'Metadata',88:'DefineFontName'}

OPS = {0x04:'nextFrame',0x05:'prevFrame',0x06:'play',0x07:'stop',0x08:'toggleQuality',0x09:'stopSounds',0x0A:'add',0x0B:'subtract',
0x0C:'multiply',0x0D:'divide',0x0E:'equals',0x0F:'less',0x10:'and',0x11:'or',0x12:'not',0x13:'stringEquals',0x14:'stringLength',
0x15:'stringExtract',0x17:'pop',0x18:'toInteger',0x1C:'getVariable',0x1D:'setVariable',0x20:'setTarget2',0x21:'stringAdd',
0x22:'getProperty',0x23:'setProperty',0x24:'cloneSprite',0x25:'removeSprite',0x26:'trace',0x27:'startDrag',0x28:'endDrag',
0x29:'stringLess',0x2A:'throw',0x2B:'castOp',0x2C:'implementsOp',0x30:'randomNumber',0x31:'mbStringLength',0x32:'charToAscii',
0x33:'asciiToChar',0x34:'getTime',0x35:'mbStringExtract',0x36:'mbCharToAscii',0x37:'mbAsciiToChar',0x3A:'delete',0x3B:'delete2',
0x3C:'defineLocal',0x3D:'callFunction',0x3E:'return',0x3F:'modulo',0x40:'newObject',0x41:'defineLocal2',0x42:'initArray',
0x43:'initObject',0x44:'typeOf',0x45:'targetPath',0x46:'enumerate',0x47:'add2',0x48:'less2',0x49:'equals2',0x4A:'toNumber',
0x4B:'toString',0x4C:'pushDuplicate',0x4D:'stackSwap',0x4E:'getMember',0x4F:'setMember',0x50:'increment',0x51:'decrement',
0x52:'callMethod',0x53:'newMethod',0x54:'instanceOf',0x55:'enumerate2',0x60:'bitAnd',0x61:'bitOr',0x62:'bitXor',0x63:'bitLShift',
0x64:'bitRShift',0x65:'bitURShift',0x66:'strictEquals',0x67:'greater',0x68:'stringGreater',0x69:'extends',
0x81:'gotoFrame',0x83:'getURL',0x87:'storeRegister',0x88:'constantPool',0x8A:'waitForFrame',0x8B:'setTarget',0x8C:'goToLabel',
0x8D:'waitForFrame2',0x8E:'defineFunction2',0x8F:'try',0x94:'with',0x96:'push',0x99:'jump',0x9A:'getURL2',0x9B:'defineFunction',
0x9D:'if',0x9E:'call',0x9F:'gotoFrame2'}

def cstr(b, p):
    e = b.index(0, p)
    return b[p:e].decode('latin1'), e + 1

def disasm(b, out, ind=0, pool=None):
    pool = pool if pool is not None else []
    p, n = 0, len(b)
    pad = '  ' * ind
    while p < n:
        off = p
        op = b[p]; p += 1
        if op == 0:
            out.append(f'{pad}{off:05d} end'); continue
        ln = 0
        if op >= 0x80:
            ln = struct.unpack('<H', b[p:p+2])[0]; p += 2
        d = b[p:p+ln]; p += ln
        name = OPS.get(op, f'op_{op:02x}')
        arg = ''
        if op == 0x88:
            c = struct.unpack('<H', d[:2])[0]; q = 2; pool[:] = []
            for _ in range(c):
                s, q = cstr(d, q); pool.append(s)
            arg = f'[{len(pool)}]'
        elif op == 0x96:
            vals = []; q = 0
            while q < len(d):
                t = d[q]; q += 1
                if t == 0: s, q = cstr(d, q); vals.append(repr(s))
                elif t == 1: vals.append(repr(struct.unpack('<f', d[q:q+4])[0])); q += 4
                elif t == 2: vals.append('null')
                elif t == 3: vals.append('undefined')
                elif t == 4: vals.append(f'r{d[q]}'); q += 1
                elif t == 5: vals.append('true' if d[q] else 'false'); q += 1
                elif t == 6:
                    x = d[q:q+8]; vals.append(repr(struct.unpack('<d', x[4:]+x[:4])[0])); q += 8
                elif t == 7: vals.append(str(struct.unpack('<i', d[q:q+4])[0])); q += 4
                elif t == 8: i = d[q]; q += 1; vals.append(repr(pool[i]) if i < len(pool) else f'c{i}')
                elif t == 9: i = struct.unpack('<H', d[q:q+2])[0]; q += 2; vals.append(repr(pool[i]) if i < len(pool) else f'c{i}')
            arg = ', '.join(vals)
        elif op in (0x99, 0x9D):
            o = struct.unpack('<h', d[:2])[0]; arg = f'-> {p + o:05d}'
        elif op in (0x81,):
            arg = str(struct.unpack('<H', d[:2])[0])
        elif op in (0x8C,):
            arg = repr(cstr(d, 0)[0])
        elif op == 0x83:
            u, q = cstr(d, 0); t, _ = cstr(d, q); arg = f'{u!r}, {t!r}'
        elif op == 0x87:
            arg = f'r{d[0]}'
        elif op in (0x9A, 0x9F, 0x8B):
            arg = d.hex()
        elif op == 0x9B:
            fn, q = cstr(d, 0); c = struct.unpack('<H', d[q:q+2])[0]; q += 2
            params = []
            for _ in range(c):
                s, q = cstr(d, q); params.append(s)
            sz = struct.unpack('<H', d[q:q+2])[0]
            out.append(f'{pad}{off:05d} function {fn}({", ".join(params)}) {{')
            disasm(b[p:p+sz], out, ind + 1, pool)
            out.append(f'{pad}}}')
            p += sz; continue
        elif op == 0x8E:
            fn, q = cstr(d, 0); c = struct.unpack('<H', d[q:q+2])[0]; q += 2
            regc = d[q]; q += 1; q += 2
            params = []
            for _ in range(c):
                r = d[q]; q += 1; s, q = cstr(d, q); params.append(f'{s}@r{r}' if r else s)
            sz = struct.unpack('<H', d[q:q+2])[0]
            out.append(f'{pad}{off:05d} function2 {fn}({", ".join(params)}) {{')
            disasm(b[p:p+sz], out, ind + 1, pool)
            out.append(f'{pad}}}')
            p += sz; continue
        elif op == 0x94:
            sz = struct.unpack('<H', d[:2])[0]
            out.append(f'{pad}{off:05d} with {{')
            disasm(b[p:p+sz], out, ind + 1, pool)
            out.append(f'{pad}}}')
            p += sz; continue
        elif ln:
            arg = d.hex()
        out.append(f'{pad}{off:05d} {name} {arg}'.rstrip())
    return out

def clip_actions(b, out, ver):
    # PlaceObject2 clip actions: reserved(2) allflags(2|4) then records
    q = 2; fl = 4 if ver >= 6 else 2; q += fl
    while True:
        flags = int.from_bytes(b[q:q+fl], 'little'); q += fl
        if flags == 0: break
        size = struct.unpack('<I', b[q:q+4])[0]; q += 4
        rec = b[q:q+size]; q += size
        k = 0
        if fl == 4 and flags & (1 << 17):  # keyPress
            k = 1
        out.append(f'  onClipEvent(flags={flags:#x}) {{')
        disasm(rec[k:], out, 2)
        out.append('  }')

def tags(b, p, end, out, ver, depth=0):
    pad = '  ' * depth
    frame = 1
    while p < end:
        h = struct.unpack('<H', b[p:p+2])[0]; p += 2
        code, ln = h >> 6, h & 0x3F
        if ln == 0x3F:
            ln = struct.unpack('<I', b[p:p+4])[0]; p += 4
        d = b[p:p+ln]; p += ln
        nm = TAGS.get(code, f'tag{code}')
        if code == 39:
            sid = struct.unpack('<H', d[:2])[0]
            out.append(f'{pad}DefineSprite id={sid} frames={struct.unpack("<H", d[2:4])[0]}')
            tags(d, 4, len(d), out, ver, depth + 1)
        elif code == 12:
            out.append(f'{pad}[frame {frame}] DoAction:')
            disasm(d, out, depth + 1)
        elif code == 59:
            out.append(f'{pad}DoInitAction sprite={struct.unpack("<H", d[:2])[0]}:')
            disasm(d[2:], out, depth + 1)
        elif code == 1:
            out.append(f'{pad}-- ShowFrame (end frame {frame})'); frame += 1
        elif code == 43:
            out.append(f'{pad}FrameLabel {cstr(d, 0)[0]!r}')
        elif code == 26:
            f = d[0]; q = 1
            depth_ = struct.unpack('<H', d[q:q+2])[0]; q += 2
            info = f'depth={depth_}'
            if f & 2: info += f' char={struct.unpack("<H", d[q:q+2])[0]}'
            if f & 32:
                # need to skip matrix/cxform to read name; do a crude search instead
                pass
            out.append(f'{pad}PlaceObject2 {info} flags={f:#x}')
            if f & 0x80:
                # locate clip actions crudely: parse fields
                q = 3
                if f & 2: q += 2
                def skip_matrix(q):
                    bits = int.from_bytes(d[q:q+40], 'big'); tot = len(d[q:q+40]) * 8; pos = 0
                    def rd(n):
                        nonlocal pos
                        v = (bits >> (tot - pos - n)) & ((1 << n) - 1); pos += n; return v
                    if rd(1): nb = rd(5); rd(nb); rd(nb)
                    if rd(1): nb = rd(5); rd(nb); rd(nb)
                    nb = rd(5); rd(nb); rd(nb)
                    return q + (pos + 7) // 8
                def skip_cx(q):
                    bits = int.from_bytes(d[q:q+40], 'big'); tot = len(d[q:q+40]) * 8; pos = 0
                    def rd(n):
                        nonlocal pos
                        v = (bits >> (tot - pos - n)) & ((1 << n) - 1); pos += n; return v
                    ha, hm = rd(1), rd(1); nb = rd(4)
                    if hm: [rd(nb) for _ in range(4)]
                    if ha: [rd(nb) for _ in range(4)]
                    return q + (pos + 7) // 8
                if f & 4: q = skip_matrix(q)
                if f & 8: q = skip_cx(q)
                if f & 16: q += 2
                if f & 32: s, q = cstr(d, q); out[-1] += f' name={s!r}'
                if f & 64: q += 2
                clip_actions(d[q:], out, ver)
            elif f & 32:
                q = 3
                if f & 2: q += 2
        elif code == 34:
            bid = struct.unpack('<H', d[:2])[0]
            ao = struct.unpack('<H', d[3:5])[0]
            out.append(f'{pad}DefineButton2 id={bid}')
            if ao:
                q = 3 + ao
                while True:
                    sz = struct.unpack('<H', d[q:q+2])[0]
                    cond = struct.unpack('<H', d[q+2:q+4])[0]
                    body = d[q+4:q+sz] if sz else d[q+4:]
                    out.append(f'{pad}  on(cond={cond:#x}) {{')
                    disasm(body, out, depth + 2)
                    out.append(f'{pad}  }}')
                    if sz == 0: break
                    q += sz
        elif code == 37:
            cid = struct.unpack('<H', d[:2])[0]
            # find variable name and initial text crudely
            out.append(f'{pad}DefineEditText id={cid} raw={d[-80:]!r}')
        elif code == 56:
            c = struct.unpack('<H', d[:2])[0]; q = 2; ex = []
            for _ in range(c):
                i = struct.unpack('<H', d[q:q+2])[0]; s, q = cstr(d, q + 2); ex.append(f'{i}:{s}')
            out.append(f'{pad}ExportAssets {ex}')
        elif code == 14:
            out.append(f'{pad}DefineSound id={struct.unpack("<H", d[:2])[0]} fmt={d[2]:#x} samples={struct.unpack("<I", d[3:7])[0]}')
        else:
            out.append(f'{pad}{nm} len={ln}' + (f' id={struct.unpack("<H", d[:2])[0]}' if code in (2,22,32,6,20,21,35,36,10,48,11,33,46) else ''))
        if code == 0:
            break

def main(path):
    d = open(path, 'rb').read()
    ver = d[3]
    b = d[:8] + zlib.decompress(d[8:]) if d[:3] == b'CWS' else d
    nb = b[8] >> 3; rl = (5 + 4 * nb + 7) // 8
    bits = int.from_bytes(b[8:8+rl], 'big'); tot = rl * 8
    vals = [(bits >> (tot - 5 - nb * (i + 1))) & ((1 << nb) - 1) for i in range(4)]
    p = 8 + rl
    out = [f'SWF v{ver} rect(twips)={vals} fps={b[p+1] + b[p]/256} frames={struct.unpack("<H", b[p+2:p+4])[0]}']
    tags(b, p + 4, len(b), out, ver)
    print('\n'.join(out))

if __name__ == '__main__':
    main(sys.argv[1])
