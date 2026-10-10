# approval-chime

Chimes while a 1Password approval dialog is waiting for you.

When a coding agent (or you, in another window) runs something that needs your
1Password approval (a signed `git commit`, `git push` over the 1Password SSH
agent, `op run` / `op read`, or a `.env` mounted with 1Password's local env
file), the command stops and waits for Touch ID. If you are away from the
screen, nothing tells you, and the command eventually fails. approval-chime
watches for that dialog and chimes every few seconds until it is gone.

macOS only. Not affiliated with 1Password.

## Install

```bash
brew install snaka/tap/approval-chime
brew services start approval-chime
```

It runs as a LaunchAgent in your login session. It needs no permissions: it
reads only each window's owner, layer and size, never its title or contents.

## How it recognises the dialog

1Password raises the same dialog for every caller: a 400-point-wide window at
layer 101. Quick Access shares the layer but is wider, and the main window
sits at layer 0. The dialog has to stay up for 3 seconds before the first
chime, so approving at once stays silent.

This is a heuristic on 1Password's current window geometry. If an update to
1Password changes it, approval-chime goes silent rather than chiming at the
wrong window. Its log records "dialog shown" / "dialog closed", which tells
you whether it still sees the dialog:

```bash
tail -f "$(brew --prefix)/var/log/approval-chime.log"
```

## Settings

```bash
defaults write approval-chime delay -float 5                           # seconds before the first chime (default 3)
defaults write approval-chime sound /System/Library/Sounds/Ping.aiff   # default Glass.aiff
brew services restart approval-chime
```

## Only need git?

[git-approval-chime](https://github.com/snaka/git-approval-chime) covers git
alone, without a resident process, by timing git's signer and ssh command
directly. It does not depend on 1Password's window geometry. Use one or the
other: with both active, a git approval chimes twice.

## Test

```bash
swiftc -o /tmp/matcher-test Sources/Matcher.swift test/main.swift && /tmp/matcher-test
```

## License

MIT
