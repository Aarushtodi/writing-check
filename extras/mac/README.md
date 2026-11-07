# Mac only extras

Not needed for `/check`, and `install.sh` does not install them. Run the main install first. These were copied from a working setup but have not been installed fresh from this repo.

- `report.py`: plain language report on a file.
- `fix.py`: sends the text and the flags to `claude -p`, then copies the fixed text to your clipboard.
- `check_selection.sh`, `fix_selection.sh`: open those reports in TextEdit.
- `Check Writing.workflow`, `Check Clipboard.workflow`, `Fix Writing.workflow`: Quick Actions that call those scripts.
- `watcher.py`, `writing_watch`, `com.writingcheck.writingwatch.plist`: optional clipboard watcher. Runs Vale and Harper when you copy prose, with one notification if it finds errors. It stays local and never reads keystrokes. It needs Python with PyObjC.

To install:

1. Copy the `.py` and `.sh` files into `~/writing-tools`.
2. Copy the `.workflow` folders into `~/Library/Services`.
3. Set hotkeys in System Settings > Keyboard > Keyboard Shortcuts > Services.
4. For the watcher, put `writing_watch` on your PATH. Replace `__HOME__` in the plist with your home folder, then copy it to `~/Library/LaunchAgents`.
