# TODO

* lightbar-msg should wait for incrementally longer times waiting for the bus to start (until a times limit is reached)
  * This is to avoid systemd service lightbar-fade from restarting on boot until it finds the bus,
    it should just wait for the bus and tween once it's found
* Add `gem install` to `make install`?
* Docs
  * LED inverting level shifter schematic
* D-bus
  * CamelCase method names?
  * Better process for checking for d-bus failures
* Locking
  * Since everything is threaded now, running `lightbar-msg` returns immediently
  * 2 tweens can happen simultaniously

