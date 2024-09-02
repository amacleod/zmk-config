.PHONY: clean all
.PHONY: zaphod

BUILD_DIR := ${HOME}/zmk/app/build

all: zaphod

zaphod:
	cd ~/zmk/app && west build -d build/zaphod -b seeeduino_xiao_ble -- -DSHIELD=zaphod_lite -DZMK_CONFIG=${HOME}/zmk-config -DZMK_EXTRA_MODULES=${HOME}/zaphod-config

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
