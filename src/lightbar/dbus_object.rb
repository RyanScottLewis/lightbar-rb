require 'forwardable'
require 'dbus'

module Lightbar

  class DBusObject < DBus::Object

    extend Forwardable

    def initialize(publisher, path)
      @publisher = publisher

      super(path)
    end

    def_delegators :@publisher, :publish

    dbus_interface "org.Lightbar" do

      dbus_method :tween, "in from:d, in to:d, in duration:d" do |from, to, duration|
        publish(Event::Tween, from, to, duration)
      end

      dbus_method :tween_to, "in to:d, in duration:d" do |to, duration|
        publish(Event::Tween, nil, to, duration)
      end

    end

  end

end

