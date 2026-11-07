---
name: check
description: Run the local writing checker (Vale + Harper + LanguageTool + Humanizer AI tell pass) on a file, pasted text, or the clipboard, then apply the judgment layer. Use when the user says "check this", "/check", or before sending any email or turning in school writing.
metadata:
  argument-hint: <file | pasted text | blank for clipboard>
---

# Writing check

Tool: `~/writing-tools/check.sh <file>` (or `-` to read stdin).

## Steps
1. Get the text: file path argument, pasted text (write it to a temp .md file), or the clipboard if there is no argument (`pbpaste` on Mac, `powershell.exe -NoProfile -Command Get-Clipboard` on Windows).
2. Run `~/writing-tools/check.sh <file>`. LanguageTool takes about 20 seconds, that is normal.
3. Judge each flag, do not dump the raw output:
   - Hard rules (always fix): no dashes of any kind, no underscores, spelling, its/it's type errors, repeated words.
   - AI tells and the "not X, it's Y" tic: rewrite plainly.
   - Humanizer pass: read the text once against `references/humanizer.md` for the tells a regex can't catch (dramatic closers, forced threes, same openings, inflated significance, re-explaining before the ask). Fewest changes; keep the writer's voice, slang and hedges.
   - Suggestions (passive, first person, bland words, small numbers, split infinitives): apply only if it helps; ignore scores, dates, money, and casual register.
   - Register: officials, teachers and coaches get capitals, apostrophes, full sentences. Friends and parents stay casual, so do not over-correct texts.
   - Never change the meaning or flatten the voice. Hedges stay visible.
4. Reply with the corrected text first, then at most 3 short bullets on what changed and why. If nothing needed fixing, say so in one line.
5. Re-run the check on the corrected text if more than trivial edits were made.
6. A real name or school word keeps getting flagged? Add it to `~/writing-tools/styles/config/vocabularies/MyRules/accept.txt`, one per line.
