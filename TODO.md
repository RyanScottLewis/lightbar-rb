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
* Rename `lightbar-tween` to `lightbar-msg`

