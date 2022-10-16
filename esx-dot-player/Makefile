rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))
SOURCES=$(call rwildcard,src,*.asm) version.def
DEST=nmfplay
VERSION=$(shell cat version.def)

$(DEST): $(SOURCES)
	sjasmplus src/main.asm -DV=$(VERSION)

release:
	rm $(DEST)
	VERSION=$(expr "$(cat version.def)" + 1)
	echo $VERSION >version.def
	sjasmplus src/main.asm -DV=$(VERSION)

all: $(DEST)

clean:
	rm $(DEST)