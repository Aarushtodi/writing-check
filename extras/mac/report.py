#!/usr/bin/env python3
"""Plain-language writing report. Usage: report.py file.md"""
import sys, json, subprocess, os, re
D=os.path.expanduser('~/writing-tools'); F=sys.argv[1]
text=open(F).read()
def snip(start,length=0):
    return text[start:start+max(length,1)]
items=[]  # (severity, snippet, message)
# Vale
v=subprocess.run([f'{D}/bin/vale','--config',f'{D}/.vale.ini','--output=JSON',F],capture_output=True,text=True).stdout
try:
    for f,alerts in json.loads(v).items():
        for a in alerts:
            sev={'error':0,'warning':1,'suggestion':2}.get(a['Severity'],2)
            items.append((sev,a['Match'],re.sub(r'\s*\(Grammarly:[^)]*\)','',a['Message'])))
except Exception: pass
# Harper
h=subprocess.run([f'{D}/bin/harper-cli','lint','--format','compact',F],capture_output=True,text=True).stdout
for line in h.splitlines():
    m=re.match(r'.*?:(\d+):(\d+): [\w:]+: (.*)',line)
    if m:
        ln,col,msg=int(m[1]),int(m[2]),m[3]
        src=text.splitlines()[ln-1][col-1:col+25].split(' ')[0] if ln<=len(text.splitlines()) else ''
        items.append((0,src,msg))
# LanguageTool
jre=f'{D}/jre/Contents/Home/bin/java'
import glob
jar=glob.glob(f'{D}/LanguageTool-*/languagetool-commandline.jar')
if jar:
    out=subprocess.run([jre,'-jar',jar[0],'-l','en-US','--json',F],capture_output=True,text=True).stdout
    try:
        j=json.loads(out[out.index('{'):])
        for m in j['matches']:
            o,l=m['offset'],m['length']
            rep=', '.join(r['value'] for r in m['replacements'][:2])
            items.append((0 if 'SPELL' in m['rule']['id'] or 'MORFOLOGIK' in m['rule']['id'] else 1,text[o:o+l],m['message']+(f'  -> {rep}' if rep else '')))
    except Exception: pass
# dedupe by snippet+rough message
seen=set(); rows=[]
for sev,s,msg in sorted(items,key=lambda x:(x[0],'->' not in x[2])):
    k=re.sub(r'\W','',s.lower())
    if k in seen: continue
    seen.add(k); rows.append((sev,s,msg))
words=len(text.split())
print(f"WRITING CHECK ({words} words)\n")
if not rows: print("Clean. Nothing to fix.")
names={0:'FIX THESE',1:'LOOK AT THESE',2:'OPTIONAL'}
for sev in (0,1,2):
    g=[r for r in rows if r[0]==sev]
    if not g: continue
    print(f"{names[sev]} ({len(g)})")
    for _,s,msg in g: print(f'  "{s.strip()}"  {msg}')
    print()
print("TIP: For the fixed version, paste your text into Claude and type /check")
