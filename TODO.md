# TODO

* lightbar-tween should wait for incrementally longer times waiting for the bus to start (until a times limit is reached)
  * This is to avoid systemd service lightbar-fade from restarting on boot until it finds the bus,
    it should just wait for the bus and tween once it's found
* Add `gem install` to `make install`?
* Move the bulk of `Application#call` to a controller
  * Since there's multiple controllers, move `OptionsController` to `Controller::Options`
  * `Controller::LocalTween`
  * `Controller::StartDaemon`
  * Maybe rename `Controller` to `Operation`
* Allow different tweening curves
  * The change from 0.01 to 0.1 is about as much as 0.1 to 1
  * Squared or cubed
* Docs
  * LED inverting level shifter schematic
* D-bus
  * Allow passing exponent, pin, pi-blaster paths?
  * CamelCase method names?
  * Better process for checking for d-bus failures

