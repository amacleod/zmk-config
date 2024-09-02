.PHONY: clean all
.PHONY: zaphod

APP_DIR := $(realpath ../zmk/app)
BUILD_DIR := $(realpath ${APP_DIR}/build)
ZMK_CONFIG_DIR := $(realpath ../zmk-config)
ZMK_HELPERS_DIR := $(realpath ../zmk-helpers)
ZAPHOD_CONFIG_DIR := $(realpath ../zaphod-config)

CONFIGFLAGS := -DZMK_CONFIG=${ZMK_CONFIG_DIR}/config
EXTRA_MODFLAGS := -DZMK_EXTRA_MODULES="${ZAPHOD_CONFIG_DIR}"

all: zaphod

zaphod:
	cd ${APP_DIR} && west build -d build/zaphod -b seeeduino_xiao_ble -- -DSHIELD=zaphod_lite ${CONFIGFLAGS} ${EXTRA_MODFLAGS}

clean:
	rm -rf ${BUILD_DIR}

# #!/bin/bash -e
# source ~/.virtualenvs/zmk/bin/activate
# cd ~/src/zmk/app

# WEST_ARGS="-DZMK_CONFIG=$HOME/src/zmk-config/config -DZMK_EXTRA_MODULES=$HOME/src/zmk-helpers;$HOME/src/zaphod-config"
# DRIVEPATH=/media/amacleod/XIAO-SENSE
# BUILDDIR=build/zaphod

# west build -d $BUILDDIR -b seeeduino_xiao_ble -- -DSHIELD=zaphod_lite $WEST_ARGS

# echo -n "Put zaphod_lite in update mode..."
# until [ -d $DRIVEPATH ]; do sleep 1s; done
# echo
# cp -v ~/src/zmk/app/$BUILDDIR/zephyr/zmk.uf2 $DRIVEPATH/
