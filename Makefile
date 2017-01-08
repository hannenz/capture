PRG = libdocklet-capture.so
CC = gcc
VALAC = valac
PKGCONFIG = $(shell which pkg-config)
PACKAGES = gtk+-3.0 plank granite libnotify posix
CFLAGS = `$(PKGCONFIG) --cflags $(PACKAGES)` 
LIBS = `$(PKGCONFIG) --libs $(PACKAGES)`
VALAFLAGS = $(patsubst %, --pkg %, $(PACKAGES)) --library=$(PRG) -X -fPIC -X -shared -X -w --enable-deprecated #--disable-warnings
SOURCES = src/CaptureDocklet.vala\
		src/CaptureDockItem.vala\
		src/CapturePreferences.vala\
		src/ScreenGrabber.vala\
		src/RegionSelect.vala\
		src/Countdown.vala\
		src/Sequence.vala\
		src/CapturePreview.vala\
		src/SettingsDialog.vala

UIFILES =

#Disable implicit rules by empty target .SUFFIXES
.SUFFIXES:

.PHONY: all clean distclean locale

all: $(PRG)
$(PRG): $(SOURCES) $(UIFILES)
	@glib-compile-resources capture.gresource.xml --target=resources.c --generate-source
	@$(VALAC) -X -DGETTEXT_PACKAGE="capture" -o $(PRG) $(SOURCES) resources.c $(VALAFLAGS)

install:
	cp $(PRG) /usr/lib/x86_64-linux-gnu/plank/docklets/

schema: de.hannenz.capture.gschema.xml
	cp de.hannenz.capture.gschema.xml /usr/share/glib-2.0/schemas/ && glib-compile-schemas /usr/share/glib-2.0/schemas/

pot:
	xgettext --language=C --keyword=_ --escape --sort-output -o po/capture.pot $(SOURCES)

po:
	msginit -l de_DE -o po/de_DE/LC_MESSAGES/capture.po -i po/capture.pot

mo:
	msgfmt --check --verbose -o po/de_DE/LC_MESSAGES/capture.mo po/de_DE/LC_MESSAGES/capture.po

clean:
	rm -f $(PRG)

distclean: clean
	rm -f src/*.vala.c

