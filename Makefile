#gem build lightbar.gemspec
#mv *.gem pkg

NAME    = lightbar
VERSION = 0.0.1

SRCDIR   = src
BUILDDIR = build
PKGDIR   = pkg
DESTDIR  =

UNIT_SOURCES = $(wildcard $(SRCDIR)/*.service)
#UNIT_DEST = $(DESTDIR)/lib/systemd/system

GEM_SPEC     = $(NAME).gemspec
GEM_SOURCES  = $(wildcard $(SRCDIR)/**/*.rb)
GEM_FILENAME = $(NAME)-$(VERSION).gem
GEM_PATH     = $(PKGDIR)/$(GEM_FILENAME)

GEM      = gem
INSTALL  = install
MKDIR    = mkdir -p
MV       = mv

CLEAN = $(BUILDDIR)

.PHONY: build install

build: $(GEM_PATH)

install:
	$(INSTALL) -D -m644 "share/lightbar.service"      "$(DESTDIR)/usr/lib/systemd/system/lightbar.service"
	$(INSTALL) -D -m644 "share/dbus.conf"             "$(DESTDIR)/etc/dbus-1/system.d/lightbar.conf"
	$(INSTALL) -D -m755 "bin/lightbar-msg"            "$(DESTDIR)/usr/bin/lightbar-msg"

$(GEM_PATH): $(GEM_SOURCES) $(UNIT_SOURCES) Makefile | $(PKGDIR)/
	$(GEM) build $(GEM_SPEC)
	$(MV) $(GEM_FILENAME) $(PKGDIR)

$(PKGDIR)/:
	$(MKDIR) $@

