"""Turn swfdis.py output into readable pseudo-JS (stack reconstruction, gotos kept for branches)."""
import sys, re

LINE = re.compile(r'^(\s*)(\d{5}) (\S+)\s?(.*)$')
BIN = {'add':'+','add2':'+','subtract':'-','multiply':'*','divide':'/','modulo':'%','less':'<','less2':'<','greater':'>',
       'equals':'==','equals2':'==','strictEquals':'===','and':'&&','or':'||','stringEquals':'eq','stringAdd':'add',
       'bitAnd':'&','bitOr':'|','bitXor':'^','bitLShift':'<<','bitRShift':'>>','bitURShift':'>>>','stringLess':'lt',
       'stringGreater':'gt','instanceOf':'instanceof'}
PROPS = ['_x','_y','_xscale','_yscale','_currentframe','_totalframes','_alpha','_visible','_width','_height','_rotation',
         '_target','_framesloaded','_name','_droptarget','_url','_highquality','_focusrect','_soundbuftime','_quality','_xmouse','_ymouse']

def split_args(s):
    out, cur, depth, q = [], '', 0, None
    for ch in s:
        if q:
            cur += ch
            if ch == q and not cur.endswith('\\' + q): q = None
            continue
        if ch in '\'"': q = ch; cur += ch; continue
        if ch == ',' and depth == 0: out.append(cur.strip()); cur = ''; continue
        cur += ch
    if cur.strip(): out.append(cur.strip())
    return out

def num(x):
    try: return int(float(x))
    except: return None

def convert(lines):
    out = []; stack = []; regs = {}; saved = []
    targets = set()
    for l in lines:
        m = re.search(r'-> (\d{5})', l)
        if m: targets.add(m.group(1))
    def pop():
        return stack.pop() if stack else '<?>'
    def emit(ind, s):
        out.append(ind + s)
    for l in lines:
        m = LINE.match(l)
        if m and m.group(3) in ('function', 'function2', 'with'):
            ind0 = m.group(1); hdr = l.strip()[6:]
            anon = m.group(3) != 'with' and re.match(r'function2? \(', hdr) is not None
            if m.group(3) == 'with':
                hdr = f'with ({pop()}) {{'
            out.append(ind0 + hdr)
            saved.append((stack[:], anon, m.group(3) == 'with'))
            stack.clear(); continue
        if not m:
            s = l.strip()
            if s == '}':
                if stack: out.append(l.replace('}', f'/* stack: {stack} */ }}'))
                else: out.append(l)
                stack.clear()
                if saved:
                    st, anon, isw = saved.pop(); stack.extend(st)
                    if anon: stack.append('<fn above>')
            elif s.startswith(('function', 'with')):
                pass
            else:
                out.append(l)
            continue
        ind, off, op, arg = m.groups()
        if off in targets:
            if stack: emit(ind, f'/* stack@label: {stack} */')
            emit(ind[:-2] if len(ind) >= 2 else '', f'L{off}:')
        if op == 'push':
            stack.extend(split_args(arg))
        elif op == 'pop':
            v = pop()
            if v != '<?>' and not re.fullmatch(r"r\d+|'[^']*'|-?\d+(\.\d+)?|undefined|null|true|false", v): emit(ind, v + ';')
        elif op in BIN:
            b = pop(); a = pop(); stack.append(f'({a} {BIN[op]} {b})')
        elif op == 'not': stack.append(f'!{pop()}')
        elif op == 'getVariable': stack.append(pop().strip("'"))
        elif op == 'setVariable':
            v = pop(); n = pop(); emit(ind, f'{n.strip(chr(39))} = {v};')
        elif op in ('defineLocal',):
            v = pop(); n = pop(); emit(ind, f'var {n.strip(chr(39))} = {v};')
        elif op == 'defineLocal2':
            emit(ind, f'var {pop().strip(chr(39))};')
        elif op == 'getMember':
            k = pop(); o = pop()
            stack.append(f'{o}.{k[1:-1]}' if re.fullmatch(r"'[A-Za-z_$][\w$]*'", k) else f'{o}[{k}]')
        elif op == 'setMember':
            v = pop(); k = pop(); o = pop()
            emit(ind, (f'{o}.{k[1:-1]}' if re.fullmatch(r"'[A-Za-z_$][\w$]*'", k) else f'{o}[{k}]') + f' = {v};')
        elif op == 'callFunction':
            n = pop(); c = num(pop()) or 0; a = [pop() for _ in range(c)]
            stack.append(f'{n.strip(chr(39))}({", ".join(a)})')
        elif op == 'callMethod':
            n = pop(); o = pop(); c = num(pop()) or 0; a = [pop() for _ in range(c)]
            fn = o if n in ("''", 'undefined') else f'{o}.{n.strip(chr(39))}'
            stack.append(f'{fn}({", ".join(a)})')
        elif op == 'newObject':
            n = pop(); c = num(pop()) or 0; a = [pop() for _ in range(c)]
            stack.append(f'new {n.strip(chr(39))}({", ".join(a)})')
        elif op == 'newMethod':
            n = pop(); o = pop(); c = num(pop()) or 0; a = [pop() for _ in range(c)]
            stack.append(f'new {o}.{n.strip(chr(39))}({", ".join(a)})')
        elif op == 'initArray':
            c = num(pop()) or 0; a = [pop() for _ in range(c)]; stack.append(f'[{", ".join(a)}]')
        elif op == 'initObject':
            c = num(pop()) or 0; a = []
            for _ in range(c):
                v = pop(); k = pop(); a.append(f'{k}: {v}')
            stack.append('{' + ', '.join(a) + '}')
        elif op == 'storeRegister':
            v = stack[-1] if stack else '<?>'
            emit(ind, f'{arg} = {v};'); stack[-1:] = [arg] if stack else []
        elif op == 'pushDuplicate': stack.append(stack[-1] if stack else '<?>')
        elif op == 'stackSwap':
            if len(stack) >= 2: stack[-1], stack[-2] = stack[-2], stack[-1]
        elif op in ('increment', 'decrement'): stack.append(f'({pop()} {"+" if op == "increment" else "-"} 1)')
        elif op in ('toNumber', 'toInteger', 'toString', 'typeOf', 'targetPath', 'charToAscii', 'asciiToChar', 'stringLength', 'mbStringLength'):
            stack.append(f'{op}({pop()})')
        elif op == 'randomNumber': stack.append(f'random({pop()})')
        elif op == 'getTime': stack.append('getTimer()')
        elif op in ('stringExtract', 'mbStringExtract'):
            c = pop(); i = pop(); s = pop(); stack.append(f'substring({s}, {i}, {c})')
        elif op == 'getProperty':
            i = num(pop()); t = pop(); stack.append(f'{t}.{PROPS[i] if i is not None and i < len(PROPS) else "prop?"}')
        elif op == 'setProperty':
            v = pop(); i = num(pop()); t = pop(); emit(ind, f'{t}.{PROPS[i] if i is not None and i < len(PROPS) else "prop?"} = {v};')
        elif op == 'return': emit(ind, f'return {pop()};')
        elif op == 'if': emit(ind, f'if {pop()} goto L{arg[3:]};')
        elif op == 'jump': emit(ind, f'goto L{arg[3:]};')
        elif op in ('delete',):
            k = pop(); o = pop(); emit(ind, f'delete {o}[{k}];')
        elif op == 'delete2': emit(ind, f'delete {pop()};')
        elif op == 'trace': emit(ind, f'trace({pop()});')
        elif op == 'getURL2':
            t = pop(); u = pop(); emit(ind, f'getURL2({u}, {t}) /*{arg}*/;')
        elif op == 'getURL': emit(ind, f'getURL({arg});')
        elif op == 'gotoFrame2': emit(ind, f'gotoFrame2({pop()}) /*{arg}*/;')
        elif op == 'setTarget2': emit(ind, f'tellTarget({pop()});')
        elif op == 'cloneSprite':
            d = pop(); t = pop(); s = pop(); emit(ind, f'duplicateMovieClip({s}, {t}, {d});')
        elif op == 'removeSprite': emit(ind, f'removeMovieClip({pop()});')
        elif op == 'startDrag':
            t = pop(); lock = pop(); c = pop()
            emit(ind, f'startDrag({t}, {lock}, constrain={c});')
        elif op == 'enumerate2' or op == 'enumerate':
            stack.append(f'ENUM({pop()})')
        elif op == 'extends':
            sup = pop(); sub = pop(); emit(ind, f'{sub} extends {sup};')
        elif op == 'constantPool': pass
        elif op == 'end': pass
        elif op in ('play', 'stop', 'nextFrame', 'prevFrame', 'stopSounds'):
            emit(ind, f'{op}();')
        elif op == 'gotoFrame': emit(ind, f'gotoFrame({arg});')
        elif op == 'goToLabel': emit(ind, f'gotoLabel({arg});')
        elif op == 'setTarget': emit(ind, f'setTarget({arg});')
        else:
            emit(ind, f'/* {op} {arg} */')
    # re-insert function headers by second pass over original
    return out

def main(path):
    raw = open(path, encoding='utf8').read().split('\n')
    res = convert(raw)
    print('\n'.join(res))

if __name__ == '__main__':
    main(sys.argv[1])
