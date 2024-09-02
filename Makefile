.PHONY: clean all
.PHONY: zaphod

APP_DIR := $(realpath ../zmk/app)
BUILD_DIR := $(realpath ${APP_DIR}/build)
ZMK_CONFIG_DIR := $(realpath ../zmk-config)
ZMK_HELPERS_DIR := $(realpath ../zmk-helpers)
ZAPHOD_CONFIG_DIR := $(realpath ../zaphod-config)

EXTRA_MODULES := ${ZMK_HELPERS_DIR}

# Shenanigans for joining words with subst later.
EMPTY :=
SPACE := $(EMPTY) $(EMPTY)

all: zaphod

zaphod: EXTRA_MODULES += ${ZAPHOD_CONFIG_DIR}
zaphod:
	cd ${APP_DIR} && west build -d build/zaphod -b seeeduino_xiao_ble -- -DSHIELD=zaphod_lite -DZMK_CONFIG=${ZMK_CONFIG_DIR}/config -DZMK_EXTRA_MODULES="$(subst $(SPACE),;,$(EXTRA_MODULES))"

clean:
	rm -rf ${BUILD_DIR}
