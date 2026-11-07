#!/usr/bin/env python3
"""Fix + premium-style suggestions. Reads text on stdin, writes report to stdout, fixed text to clipboard."""
import sys, subprocess, os, tempfile, re
D=os.path.expanduser('~/writing-tools')
text=sys.stdin.read().strip()
if not text: print("No text found. Copy your text first (Cmd+C), then run again."); sys.exit()
tmp=tempfile.mktemp(suffix='.md'); open(tmp,'w').write(text)
flags=subprocess.run(['python3',f'{D}/report.py',tmp],capture_output=True,text=True).stdout
prompt=f"""You are a writing editor for a high school student, doing what Grammarly Premium does, using these rules.

HARD RULES (always apply, no exceptions):
- NO dashes of any kind (em dash, en dash, spaced hyphen). Use a comma, period, or "to". No underscores.
- No "it's not X, it's Y" contrast tic. No AI-sounding words or phrases (leverage, robust, seamless, delve, "I wanted to reach out", "I hope this email finds you well", "I'm excited to").
- Humanizer tells (from Wikipedia's Signs of AI writing), cut them: dramatic one line closers, sayings that sound deep, "let's dive in" style run ups, arguing with an objection nobody raised, forced lists of three, every sentence opening the same way, inflated significance ("pivotal moment", "the future looks bright"), sales words ("seamless", "cutting edge", "empowering"), "serves as"/"boasts" instead of "is"/"has", "experts believe" with no source, chatbot residue ("Great question!", "I hope this helps"), and explaining what the reader already knows before the ask. Cut only the tell, keep his specifics, slang and hedges; never flatten a casual text into a formal one.
- No apology padding. No punchline endings. Hedges stay visible. Plain verbs.
- Keep HIS voice and meaning. Do not make it more formal or polished than the audience needs.
- Register: teachers, coaches, directors, officials, adults he does not know get capitals, apostrophes, full sentences. Friends and parents stay casual (lowercase and slang are fine, do not correct texts to friends).
- Drafts: lead with the ask, short, no setup or justification lines.

Decide the likely audience and register from the text itself.

AUTOMATIC CHECKER FLAGS (a tool already found these; treat spelling/grammar items as real, judge the rest):
{flags}

TEXT:
\"\"\"
{text}
\"\"\"

Respond in EXACTLY this format, nothing else:

<<<FIXED>>>
(the corrected text only: fix every real error and hard-rule violation with the fewest changes needed; keep paragraph breaks)
<<<END>>>

TONE READ: one sentence on how this will land with its likely reader and the register you assumed.

WHAT I FIXED:
- up to 5 short bullets, only the meaningful changes

PREMIUM SUGGESTIONS (optional upgrades, NOT applied above; max 5, ranked by impact; skip any category with nothing to say):
- CLARITY / CONCISION / TONE / WORD CHOICE / STRUCTURE: "before" -> "after", with a few words on why

If the text is already clean, say so in one line under WHAT I FIXED and leave PREMIUM SUGGESTIONS short."""
r=subprocess.run(['claude','-p','--model','sonnet'],input=prompt,capture_output=True,text=True,cwd='/tmp',timeout=240)
out=r.stdout.strip() or ("Claude did not respond: "+r.stderr[:300])
m=re.search(r'<<<FIXED>>>\s*(.*?)\s*<<<END>>>',out,re.S)
fixed=m.group(1) if m else ''
if fixed: subprocess.run(['pbcopy'],input=fixed,text=True)
body=re.sub(r'<<<FIXED>>>\s*.*?\s*<<<END>>>\s*','',out,flags=re.S)
print("FIXED TEXT (already copied to your clipboard, just paste it):\n")
print(fixed or "(none)")
print("\n"+"="*60+"\n")
print(body)
print("\n"+"="*60+"\nCHECKER FLAGS (for reference)\n")
print(flags)
