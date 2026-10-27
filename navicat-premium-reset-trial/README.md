# navicat-premium-reset-trial

This script allows you to reset the remaining trial days for Navicat Premium versions 15, 16, and 17 on macOS.

## Warning

This script is intended for educational purposes only. Please support the developers by purchasing a Navicat license from the [official website](https://www.navicat.com/).

## Scheduled execution on James's Macs

`run-scheduled.sh` runs the existing script without interactive input, skips
execution while Navicat is open, and logs the exit status. It does not change
or verify the original script's trial-reset behavior.

`com.james.navicat-maintenance.plist` schedules it every 518400 seconds (six
days) in the logged-in user's session. The interval restarts when the agent
is loaded, including after logging in. A skipped run waits for the next
interval. Output goes to `~/Library/Logs/navicat-maintenance.log`.

The plist uses James's `/Users/james/Documents/dottofiles` path. Pulling the
repository onto another Mac does not activate the schedule. To install it
on a Mac where it should run:

```sh
mkdir -p ~/Library/LaunchAgents ~/Library/Logs
ln -s ~/Documents/dottofiles/navicat-premium-reset-trial/com.james.navicat-maintenance.plist ~/Library/LaunchAgents/com.james.navicat-maintenance.plist
launchctl bootstrap "gui/$(id -u)" ~/Library/LaunchAgents/com.james.navicat-maintenance.plist
```

If the agent is already installed, unload it before replacing its plist or
reloading it. Installation does not run the script immediately.

## License

This project is licensed under the terms of the [GNU General Public License v3.0](https://github.com/tuxity/navicat-premium-reset-trial/blob/main/LICENSE).

## Note for Windows Users

If you are using Windows, please refer to [navicat-refresh](https://github.com/wctsai20002/navicat-refresh) made by [@wctsai20002](https://github.com/wctsai20002).
