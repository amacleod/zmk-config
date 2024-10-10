.PHONY: clean all
.PHONY: corne ferris zaphod
.PHONY: deploy_corne deploy_ferris deploy_zaphod

APP_DIR := $(realpath ../zmk/app)
BUILD_DIR := ${APP_DIR}/build
ZMK_CONFIG_DIR := $(realpath ../zmk-config)
ZMK_HELPERS_DIR := $(realpath ../zmk-helpers)
ZAPHOD_CONFIG_DIR := $(realpath ../zaphod-config)

EXTRA_MODULES := ${ZMK_HELPERS_DIR}

# Shenanigans for joining words with subst later.
EMPTY :=
SPACE := $(EMPTY) $(EMPTY)

XIAO_PATH := /media/${USER}/XIAO-SENSE
NANO_PATH := /media/${USER}/NICENANO

# Uncomment WESTFLAGS and CMAKEFLAGS if using ZMK Studio.
#WESTFLAGS := -S studio-rpc-usb-uart
#CMAKEFLAGS := -DCONFIG_ZMK_STUDIO=y

CORNE_DEPS := config/corne.*
FERRIS_DEPS := config/cradio.*
LILY58_DEPS := config/lily58.*
ZAPHOD_DEPS := config/zaphod_lite.*

all: corne zaphod

corne: ${BUILD_DIR}/corne_left/zephyr/zmk.uf2 ${BUILD_DIR}/corne_right/zephyr/zmk.uf2
${BUILD_DIR}/corne_left/zephyr/zmk.uf2: ${CORNE_DEPS}
	cd ${APP_DIR} && west build -d build/corne_left -b nice_nano_v2 ${WESTFLAGS} -- -DSHIELD=corne_left ${CMAKEFLAGS} -DZMK_CONFIG=${ZMK_CONFIG_DIR}/config -DZMK_EXTRA_MODULES="$(subst $(SPACE),;,$(EXTRA_MODULES))"
${BUILD_DIR}/corne_right/zephyr/zmk.uf2: ${CORNE_DEPS}
	cd ${APP_DIR} && west build -d build/corne_right -b nice_nano_v2 -- -DSHIELD=corne_right -DZMK_CONFIG=${ZMK_CONFIG_DIR}/config -DZMK_EXTRA_MODULES="$(subst $(SPACE),;,$(EXTRA_MODULES))"

deploy_corne: corne
	@echo -n "Put corne_left in update mode..."
	@until [ -d ${NANO_PATH} ]; do sleep 1s; done
	@echo
	cp -v ${BUILD_DIR}/corne_left/zephyr/zmk.uf2 ${NANO_PATH}/
	@echo -n "Put corne_right in update mode..."
	@until [ -d ${NANO_PATH} ]; do sleep 1s; done
	@echo
	cp -v ${BUILD_DIR}/corne_right/zephyr/zmk.uf2 ${NANO_PATH}/

ferris: ${BUILD_DIR}/ferris_left/zephyr/zmk.uf2 ${BUILD_DIR}/ferris_right/zephyr/zmk.uf2
${BUILD_DIR}/ferris_left/zephyr/zmk.uf2: ${FERRIS_DEPS}
	cd ${APP_DIR} && west build -d build/ferris_left -b nice_nano_v2 -- -DSHIELD=cradio_left -DZMK_CONFIG=${ZMK_CONFIG_DIR}/config -DZMK_EXTRA_MODULES="$(subst $(SPACE),;,$(EXTRA_MODULES))"
${BUILD_DIR}/ferris_right/zephyr/zmk.uf2: ${FERRIS_DEPS}
	cd ${APP_DIR} && west build -d build/ferris_right -b nice_nano_v2 -- -DSHIELD=cradio_left -DZMK_CONFIG=${ZMK_CONFIG_DIR}/config -DZMK_EXTRA_MODULES="$(subst $(SPACE),;,$(EXTRA_MODULES))"

deploy_ferris: ferris
	@echo -n "Put ferris_left in update mode..."
	@until [ -d ${NANO_PATH} ]; do sleep 1s; done
	@echo
	cp -v ${BUILD_DIR}/ferris_left/zephyr/zmk.uf2 ${NANO_PATH}/
	@echo -n "Put ferris_right in update mode..."
	@until [ -d ${NANO_PATH} ]; do sleep 1s; done
	@echo
	cp -v ${BUILD_DIR}/ferris_right/zephyr/zmk.uf2 ${NANO_PATH}/

zaphod: EXTRA_MODULES += ${ZAPHOD_CONFIG_DIR}
zaphod: ${ZAPHOD_DEPS}
	cd ${APP_DIR} && west build -d build/zaphod -b seeeduino_xiao_ble -- -DSHIELD=zaphod_lite -DZMK_CONFIG=${ZMK_CONFIG_DIR}/config -DZMK_EXTRA_MODULES="$(subst $(SPACE),;,$(EXTRA_MODULES))"

deploy_zaphod: zaphod
	@echo -n "Put zaphod_lite in update mode..."
	@until [ -d ${XIAO_PATH} ]; do sleep 1s; done
	@echo
	cp -v ${BUILD_DIR}/zaphod/zephyr/zmk.uf2 ${XIAO_PATH}/

clean:
	rm -rf ${BUILD_DIR}
