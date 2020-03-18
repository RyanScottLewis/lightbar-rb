# Lightbar

Value tweening for PWM pins on Raspberry Pi, using [Pi-Blaster][pi-blaster], with [systemd][systemd]
services to fade in & out at boot & power off, respectively.

When daemonized, utilizes [D-Bus][dbus] to provide instant value changes, avoiding Ruby startup times
on lower end Raspberry Pi models.

Created to control an LED light strip connected a Raspberry Pi Zero W interfacing via an admittedly
primitive 3.3v to 12v inverting level shifter.

## Installation

> Note that `gem install` and `make install` methods might require `sudo`.
> These are written from the perspective of a root user.

### Manual

```sh
$ git clone https://github.com/RyanScottLewis/lightbar-rb.git
$ cd lightbar-rb
$ make
$ gem install pkg/lightbar-x-x-x.gem
$ make install
```

### Pacman

```sh
$ git clone https://github.com/RyanScottLewis/lightbar-pacman.git
$ cd lightbar-pacman
$ makepkg -i
```

## Post-Install

### Systemd Units

Enable both the lightbar and the ability to fade in on startup & fade out on shutdown:

```sh
$ systemctl enable --now lightbar lightbar-fade
```

### D-Bus

D-Bus is required when running as a daemon with the `--daemon` option and is run on the system bus.

A D-Bus policy is installed which allows the root user to create the D-Bus address on the system bus
as well as allows any user of the `lightbar` group to send messages to it.

So, if you'd like a user other than root to control the lightbar, simply add them to the `lightbar`
group.

If you intend to add a user to the `lightbar` group have them control the lightbar within the same
session, you need to reload the D-Bus configuration.  
You can do this by running: `systemctl reload dbus`

### Pi-Blaster Configuration

Pi-Blaster is required for use with Lightbar. The `lightbar` Systemd service requires Pi-Blaster as
a dependency. But, if you are not using Systemd, then be sure Pi-Blaster is running first.

Be sure the pin you are using for PWM is enabled to be used by Pi-Blaster. This can be set with the
`--gpio` option when running Pi-Blaster or if using it's Systemd service, creating the
`/etc/default/pi-blaster` file and adding `--gpio` to the `DAEMON_OPTS` variable:

```
DAEMON_OPTS="--gpio 4,17,18,27,21,22,23,24,25"
```

## Usage

### Simple

Tween PWM output value from 0 to 1 over 5 seconds through Pi-Blaster on BCM pin 18:

```sh
$ lightbar --from 0 --to 1 --duration 5 --pin 18
```

### Daemon

Run as daemon (to avoid Ruby startup times on slower systems):

```sh
$ lightbar --daemon
```

Then in another terminal (or same one if you CTRL+Z then run `bg` or run with a trailing `&`)

```sh
$ lightbar --from 0 --to 1 --duration 5
```

This causes the application to communicate with the daemon over the system D-Bus.

However, this still includes the same Ruby startup times, defeating the purpose of daemonizing.  
To get past that startup time hurdle, we ship with a shell script which simply calls the tweening
function over D-Bus directly, bypassing having to use Ruby to cause the tweening whatsoever.

For example, the above example is equivalent to the following:

```sh
$ dbus-send --system --print-reply --type=method_call --dest=org.Lightbar / org.Lightbar.tween double:0 double:1 double:5
```

For convienence, we profile the `lightbar-tween` script that provides the same functionality:

```sh
$ lightbar-tween 0 1 5
```

## Level Shifter

To provide the correct amount of power to the LED strip, we utilize a level shifter to convert from
the Pi's 3.3vdc PWM output to what the LED strip requires, which is 12vdc in this case.

```
                            +12v
                              |
Raspberry Pi   170 Ohm    Collector
  PWM Pin    - Resistor - Base (NPN)
  (BCM 18)                Emitter
                              |
                              0v
```

## Justification

This was originally written in Crystal, which worked very well. There was no startup times.  
However, building the application required cross-compiling to the ARMv6 platform (for Pi Zero W).  
This required maintaining a cross-compilation platform on the Pi which needed a Crystal re-compilation
after each Crystal version was pushed. This takes a long time on my poor little Zero W, where as
a single Ruby install is finished in no time and widely available. This could have easily been
written in Python, Lua, or any other widely available interpreted language. I just prefer Ruby.

[pi-blaster]: https://github.com/sarfata/pi-blaster
[systemd]: https://freedesktop.org/wiki/Software/systemd/
[dbus]: https://www.freedesktop.org/wiki/Software/dbus/

