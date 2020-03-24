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

      dbus_method :tween, "in from:d, in to:d" do |from, to|
        publish(Event::Tween, from, to)
      end

      dbus_method :tween_to, "in to:d" do |to|
        publish(Event::Tween, nil, to)
      end

    end

  end

end

