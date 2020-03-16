#gem build lightbar.gemspec
#mv *.gem pkg

NAME    = lightbar
VERSION = 0.0.1

SRCDIR   = src
BUILDDIR = build
PKGDIR   = pkg
DESTDIR  =

UNIT_SRC  = $(SRCDIR)/*.service
UNIT_DEST = $(DESTDIR)/lib/systemd/system

GEM_SPEC    = $(NAME).gemspec
GEM_SOURCES = $(wildcard $(SRCDIR)/**/*.rb)
GEM_PATH    = $(PKGDIR)/$(NAME)-$(VERSION).gem

GEM     = gem
INSTALL = install
MKDIR   = mkdir -p
MV      = mv

CLEAN = $(BUILDDIR)

.PHONY: build install

build: $(GEM_PATH)

install:
	$(INSTALL) -D -m644 "share/lightbar.service"          "$(DESTDIR)/usr/lib/systemd/system/lightbar.service"
	$(INSTALL) -D -m644 "share/lightbar-fade-in.service"  "$(DESTDIR)/usr/lib/systemd/system/lightbar-fade-in.service"
	$(INSTALL) -D -m644 "share/lightbar-fade-out.service" "$(DESTDIR)/usr/lib/systemd/system/lightbar-fade-out.service"
	$(INSTALL) -D -m644 "bin/lightbar-tween"              "$(DESTDIR)/usr/bin/lightbar-tween"

$(GEM_PATH): $(GEM_SOURCES) | $(PKGDIR)/
	$(GEM) build $(GEM_SPEC)
	$(MV) *.gem pkg

$(PKGDIR)/:
	$(MKDIR) $@

