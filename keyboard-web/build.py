import json, tomllib, datetime, os
here = os.path.dirname(os.path.abspath(__file__)); os.chdir(here)
aero = tomllib.load(open('../aerospace.toml','rb'))
kar = json.load(open('../karabiner/karabiner-apple.json'))

# canonical key ids = karabiner key_codes
AK = {'minus':'hyphen','equal':'equal_sign','backtick':'grave_accent_and_tilde','leftSquareBracket':'open_bracket',
      'rightSquareBracket':'close_bracket','enter':'return_or_enter','esc':'escape','backspace':'delete_or_backspace'}
GL = {'left_command':'⌘L','right_command':'⌘R','command':'⌘','left_option':'⌥L','right_option':'⌥R','option':'⌥',
 'left_shift':'⇧','right_shift':'⇧R','left_control':'⌃','right_control':'⌃R','control':'⌃','shift':'⇧',
 'left_arrow':'←','right_arrow':'→','up_arrow':'↑','down_arrow':'↓','delete_or_backspace':'⌫','return_or_enter':'↩',
 'escape':'⎋','tab':'⇥','caps_lock':'⇪','page_up':'PgUp','page_down':'PgDn','hyphen':'-','equal_sign':'=',
 'open_bracket':'[','close_bracket':']','semicolon':';','quote':"'",'backslash':'\\','slash':'/','comma':',',
 'period':'.','grave_accent_and_tilde':'`','home':'Home','end':'End','button4':'Mouse 4','button5':'Mouse 5'}
SH = {'2':'@','quote':'"','3':'#','equal_sign':'+','0':')','4':'$','6':'^','close_bracket':'}','comma':'<','period':'>',
      '1':'!','slash':'?','8':'*','open_bracket':'{','9':'(','7':'&','5':'%','semicolon':':'}
def g(x): return GL.get(x, x.upper() if len(x)==1 else x)
def mods(m): return [] if not m else ([m] if isinstance(m,str) else list(m))
def cm(x):  # canonical modifier pill id
    return {'left_command':'cmdL','command':'cmdL','right_command':'cmdR','left_option':'optL','option':'optL','right_option':'optR',
            'left_shift':'shift','right_shift':'shift','shift':'shift','left_control':'ctrl','control':'ctrl','right_control':'ctrl'}[x]
def disp(key, ms):
    ms = mods(ms)
    if ms==['left_shift'] and key in SH: return SH[key]
    return ''.join(g(m) for m in ms) + g(key)

E = []  # entries
# --- Karabiner
p = kar['profiles'][0]
for s in p.get('simple_modifications',[]):
    E.append(dict(src='kar',mods=[],key=s['from']['key_code'],short=disp(s['to'][0]['key_code'],None),
                  full='Simple modification: %s → %s'%(g(s['from']['key_code']),disp(s['to'][0]['key_code'],None)),rule='Simple modifications',cond=False))
for r in p['complex_modifications']['rules']:
    for m in r['manipulators']:
        f=m['from']; key=f.get('key_code') or f.get('pointing_button')
        mm=sorted(set(cm(x) for x in mods(f.get('modifiers',{}).get('mandatory'))))
        outs=[]
        for t in m.get('to',[]):
            if 'key_code' in t: outs.append(disp(t['key_code'],t.get('modifiers')))
            elif 'pointing_button' in t: outs.append(g(t['pointing_button']))
            elif 'shell_command' in t: outs.append('$ '+t['shell_command'])
            else: outs.append('?')
        short=' '.join(outs)
        E.append(dict(src='kar',mods=mm,key=key,short=short,full=short,rule=r['description'],cond=bool(m.get('conditions')),any='any' in f.get('modifiers',{}).get('optional',[])))
# --- AeroSpace
ARW={'left':'←','right':'→','up':'↑','down':'↓'}
def ashort(c):
    w=c.split()
    if c=='workspace-back-and-forth': return '⇄'
    if w[0]=='workspace': return w[1]
    if w[0]=='move-node-to-workspace': return '→'+w[1]
    if w[0]=='focus': return ARW[w[1]]
    if w[0]=='move' and len(w)==2: return 'mv'+ARW[w[1]]
    if w[0]=='resize': return '−' if '-' in w[-1] else '+'
    if w[0]=='layout': return 'tiles' if w[1]=='tiles' else 'accord' if w[1]=='accordion' else 'float'
    if w[0]=='mode': return 'svc'
    if w[0]=='move-workspace-to-monitor': return 'mon'
    if w[0]=='join-with': return 'join'+ARW[w[1]]
    return {'reload-config':'reload','flatten-workspace-tree':'reset','close-all-windows-but-current':'only'}.get(w[0],w[0])
def parse(spec):
    parts=spec.split('-'); key=parts[-1]; ms=parts[:-1]
    # keys like alt-shift-semicolon fine; 'minus' etc
    return sorted(set({'alt':'optL','shift':'shift','cmd':'cmdL','ctrl':'ctrl'}[x] for x in ms)), AK.get(key,key)
for src,mode in (('aero','main'),('svc','service')):
    for spec,cmd in aero['mode'][mode]['binding'].items():
        ms,key=parse(spec); c=cmd if isinstance(cmd,str) else ' ; '.join(cmd)
        E.append(dict(src=src,mods=ms,key=key,short=ashort(c if isinstance(cmd,str) else cmd[0]),full=c,rule='AeroSpace '+mode+' mode',cond=False))
apps=[[(lambda i:i)(w['if']['app-id']),' ; '.join(w['run']) if isinstance(w['run'],list) else w['run']] for w in aero['on-window-detected']]
import base64,re
NAMES={'com.apple.Preview':'Preview','org.mozilla.nightlyunofficial':'Firefox Nightly','org.mozilla.firefoxdeveloperedition':'Firefox Dev Edition','com.apple.mail':'Mail','com.navicat.NavicatPremium':'Navicat','com.github.wez.wezterm':'WezTerm','com.microsoft.teams2':'Teams','app.freelens.Freelens':'Freelens','com.usebruno.app':'Bruno','com.apple.finder':'Finder','com.microsoft.VSCode':'VS Code','org.openvpn.client.app':'OpenVPN'}
def icon(i):
    f=f'icons/{i}.png'
    return 'data:image/png;base64,'+base64.b64encode(open(f,'rb').read()).decode() if os.path.exists(f) else None
wsapps={}
for w in aero['on-window-detected']:
    run=w['run'] if isinstance(w['run'],str) else ' '.join(w['run'])
    m=re.match(r'move-node-to-workspace (\w+)',run)
    i=w['if']['app-id']
    if m: wsapps.setdefault(m.group(1).lower(),[]).append(dict(id=i,name=NAMES.get(i,i),icon=icon(i)))
    else: apps_float=1
raw={'aerospace.toml':open('../aerospace.toml').read(),'karabiner.json':open('../karabiner/karabiner-apple.json').read()}
data={'raw':raw,'wsapps':wsapps,'entries':E,'apps':apps,'built':datetime.date.today().isoformat()}
os.makedirs('site',exist_ok=True); open('site/index.html','w').write(open('template.html').read().replace('/*DATA*/null',json.dumps(data)))
print(len(E),'entries')
