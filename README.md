# Tablet mode detection and setup scripts for linux

## What it does

It uses `libinput debug-events` to detect switches to normal and tablet mode,
and executes commands for switching into that mode, which are specified in
a config file. Generally you would put there commands to disable/enable a
keyboard/touchpad/trackpoint, show/hide an on-screen keyboard, toggle some desktop
environment panels, and the like.

## Supported device

- Minisforum v3 With Bazzite

To check if your device is supported, run `stdbuf -oL libinput debug-events|grep switch`, flip your laptop between
normal and tablet mode, and see if it printed anything. If you don't see any switch events, your device will
not work with these scripts.

## Installation

1. Add your user to the `input` group (`sudo gpasswd --add username input`) and relogin to apply group membership.
2. Install rbenv with brew, and configure a default global ruby
3. Clone this repo somewhere, and optionally symlink `watch_tablet` into any directory in your $PATH
4. Copy a config file into `~/.config/watch_tablet.yml`
5. Adjust the config (see below)
6. Test it by running `watch_tablet` in a terminal and flipping your laptop to tablet and back. You should see commands from the config being executed. Press Ctrl+C to terminate it.
7. After you confirmed that everything works, add `watch_tablet &` to your `~/.xinitrc`
8. Restart your desktop session and enjoy

## Configuration

`input_device` is a path to the device that provides the tablet mode switch. To find it you
may run `stdbuf -oL libinput debug-events|grep switch` and notice something like `event4` in
the leftmost column. That would correspond to /dev/input/event4. Device numbers may be unstable
across reboots, so you may consider doing `ls -lh /dev/input/by-path` and finding a symlink to
that device. For X1 Yoga Gen2 it's `/dev/input/by-path/platform-thinkpad_acpi-event`.

`modes.laptop`, `modes.tablet` - this contain commands that will be executed when mode changes.
Most likely this will contain `xinput enable` and `xinput disable` commands to enable/disable
kb/touchpad/trackpoint (just run `xinput` to look them up). You may use any other commands
to adjust your desktop environment (e.g. hide or show additional panels, increase button size,
hide/show onscreen keyboard etc.)

Example:

```yaml
input_device: /dev/input/by-path/platform-thinkpad_acpi-event
modes:
  laptop:
    # - xinput enable "Wacom Pen and multitouch sensor Finger"
    - xinput enable "AT Translated Set 2 keyboard"
    - xinput enable "SynPS/2 Synaptics TouchPad"
    - xinput enable "TPPS/2 IBM TrackPoint"
  tablet:
    # - xinput disable "Wacom Pen and multitouch sensor Finger"
    - xinput disable "AT Translated Set 2 keyboard"
    - xinput disable "SynPS/2 Synaptics TouchPad"
    - xinput disable "TPPS/2 IBM TrackPoint"
```
