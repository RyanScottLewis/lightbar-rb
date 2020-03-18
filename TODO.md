# TODO

* Allow to leave out FROM argument (in CLI and D-Bus interface) when daemonized to tween from the current value
* lightbar-tween should wait for incrementally longer times waiting for the bus to start (until a times limit is reached)
  * This is to avoid systemd service lightbar-fade from restarting on boot until it finds the bus,
    it should just wait for the bus and tween once it's found
* Add `gem install` to `make install`?

