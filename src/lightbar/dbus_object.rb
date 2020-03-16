require 'forwardable'
require 'dbus'

module Lightbar

  class DBusObject < DBus::Object

    extend Forwardable

    def initialize(application, path)
      @application = application

      super(path)
    end

    def_delegators :@application, :publish

    dbus_interface "org.Lightbar" do

      dbus_method :tween, "in from:d, in to:d, in duration:d" do |from, to, duration|
        publish(Event::Tween, from, to, duration)
      end

    end

  end

end

