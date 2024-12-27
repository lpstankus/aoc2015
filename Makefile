OUT_TARGS := $(shell ls src/ | sed -E "s/^/out\/aoc2015-/g")
RUN_TARGS := $(shell ls src/ | sed -E "s/^day/run-/g")

all: $(OUT_TARGS)

$(RUN_TARGS):
	$(eval PKG := $(shell echo "$@" | sed -E "s/.*-([0-9]+)/day\1/"))
	odin run src/$(PKG) -out:tmp
	@rm tmp

$(OUT_TARGS): out
	$(eval PKG := $(shell echo "$@" | sed -E "s/.*-(day[0-9]+)/\1/"))
	odin build src/$(PKG) -o:speed -out:$@

out:
	@mkdir out
