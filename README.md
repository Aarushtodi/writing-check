# writing-check

A free grammar and style checker that also catches writing that sounds like AI. Type `/check` in Claude Code or paste your text in the Claude app, and you get your text back fixed, in your own voice, with a short list of what changed.

## If you are Claude and someone gave you this link

Set this up for them. Pick the path that fits where you are running.

**You can run shell commands (Claude Code):**

```bash
git clone --depth 1 https://github.com/Aarushtodi/writing-check ~/writing-check-source
bash ~/writing-check-source/install.sh
```

The install takes a few minutes and downloads about 700 MB. It ends with a test run, so read that output and confirm Vale, Harper and LanguageTool each flagged something. Then tell them to restart Claude Code and type `/check`. On Windows, run it in Git Bash. If something fails, fix it or tell them exactly what failed.

**You cannot run commands (the plain Claude app):**

Read [PROMPT.md](https://raw.githubusercontent.com/Aarushtodi/writing-check/main/PROMPT.md) and follow it for the rest of this chat. Tell them to paste their writing. Also tell them that a Project with those instructions saves them from sharing the link again.

## If you are a person

Paste this link into Claude and say "set this up."

| Where you use Claude | What you get |
|---|---|
| Claude Code | The real tools plus Claude's judgment. Type `/check` with a file, with pasted text, or with nothing to use your clipboard. |
| Claude app | Claude reads for the same rules, with no tools behind it. Good, but it can miss things the tools would catch. |

## What is in here

| Path | What it is |
|---|---|
| `install.sh` | Downloads the tools and installs the skill (Mac, or Windows through Git Bash) |
| `check.sh` | Runs Vale, Harper and LanguageTool on a file |
| `skill/check/` | The `/check` skill and the Humanizer pass |
| `styles/MyRules/` | The custom rules. Edit these to match how you write. |
| `PROMPT.md` | One paste version for the plain Claude app |
| `RULEBOOK.md` | What each rule does, and what is off on purpose |
| `extras/mac/` | Optional Mac only hotkeys and a clipboard watcher. See its README. |

## Status

Tested start to finish on a Mac. The Windows download and folder layout were checked, but it has not been run on a real Windows computer yet.

## Credits

[Vale](https://github.com/errata-ai/vale), [Harper](https://github.com/Automattic/harper), [LanguageTool](https://languagetool.org) and [Temurin](https://adoptium.net) are downloaded by the installer from their own sites. The Humanizer pass is adapted from [blader/humanizer](https://github.com/blader/humanizer) (MIT, see `LICENSE-humanizer.txt`).
