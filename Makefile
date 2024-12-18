.PHONY: clean all
.PHONY: corne corne_left corne_right
.PHONY: ferris cradio_left cradio_right
.PHONY: lily58 lily58_left lily58_right
.PHONY: lotus58 lotus58_ble lotus58_ble_left lotus58_ble_right
.PHONY: tern hummingbird
.PHONY: weejock
.PHONY: zaphod zaphod_lite
.PHONY: deploy_corne deploy_ferris deploy_lily58 deploy_lotus58 deploy_tern deploy_weejock deploy_zaphod
.PHONY: transfer

# Basic paths for ZMK and my own config.
APP_DIR := $(realpath ../zmk/app)
BUILD_DIR := ${APP_DIR}/build
ZMK_CONFIG_DIR := $(realpath ../zmk-config)
# Third party ZMK module paths.
ZMK_HELPERS_DIR := $(realpath ../zmk-helpers)
ZMK_AUTO_LAYER_DIR := $(realpath ../zmk-auto-layer)
ZMK_TRI_STATE_DIR := $(realpath ../zmk-tri-state)
# Keyboard-specific config directory paths.
LOTUS58_BLE_CONFIG_DIR := $(realpath ../lotus58-ble-zmk)
TERN_CONFIG_DIR := $(realpath ../tern-zmk)
WEEJOCK_CONFIG_DIR := $(realpath ../weejock-zmk)
ZAPHOD_CONFIG_DIR := $(realpath ../zaphod-config)

EXTRA_MODULES := ${ZMK_HELPERS_DIR}

# Shenanigans for joining words with subst later.
EMPTY :=
SPACE := $(EMPTY) $(EMPTY)

XIAO_PATH := /media/${USER}/XIAO-SENSE
NANO_PATH := /media/${USER}/NICENANO
UF2B_PATH := /media/${USER}/UF2BOOT

WIN_DESKTOP := /mnt/c/Users/${USER}/Desktop
KBD_PARTS := corne_left corne_right cradio_left cradio_right lily58_left lily58_right tern_ble weejock zaphod_lite

all: corne ferris weejock zaphod

corne: corne_left corne_right
	ls -l ${BUILD_DIR}/corne_*/zephyr/zmk.uf2
corne_left corne_right:
	cd ${APP_DIR} && west build -d build/$@ -b nice_nano_v2 -- -DSHIELD=$@ ${CMAKEFLAGS} -DZMK_CONFIG=${ZMK_CONFIG_DIR}/config -DZMK_EXTRA_MODULES="$(subst $(SPACE),;,$(EXTRA_MODULES))"

deploy_corne: corne
	@echo -n "Put corne_left in update mode..."
	@until [ -d ${NANO_PATH} ]; do sleep 1s; done
	@echo
	cp -v ${BUILD_DIR}/corne_left/zephyr/zmk.uf2 ${NANO_PATH}/
	@echo -n "Put corne_right in update mode..."
	@until [ -d ${NANO_PATH} ]; do sleep 1s; done
	@echo
	cp -v ${BUILD_DIR}/corne_right/zephyr/zmk.uf2 ${NANO_PATH}/

ferris: cradio_left cradio_right
cradio_left: SNIPPETS = -S zmk-usb-logging
cradio_left cradio_right:
	cd ${APP_DIR} && west build -d build/$@ -b nice_nano_v2 ${SNIPPETS} -- -DSHIELD=$@ -DZMK_CONFIG=${ZMK_CONFIG_DIR}/config -DZMK_EXTRA_MODULES="$(subst $(SPACE),;,$(EXTRA_MODULES))"

deploy_ferris: ferris
	@echo -n "Put ferris_left in update mode..."
	@until [ -d ${NANO_PATH} ]; do sleep 1s; done
	@echo
	cp -v ${BUILD_DIR}/cradio_left/zephyr/zmk.uf2 ${NANO_PATH}/
	@echo -n "Put ferris_right in update mode..."
	@until [ -d ${NANO_PATH} ]; do sleep 1s; done
	@echo
	cp -v ${BUILD_DIR}/cradio_right/zephyr/zmk.uf2 ${NANO_PATH}/

lily58: lily58_left lily58_right
lily58_left: # SNIPPETS = -S zmk-usb-logging
lily58_left lily58_right:
	cd ${APP_DIR} && west build -d build/$@ -b nice_nano_v2 ${SNIPPETS} -- -DSHIELD="$@ nice_view_adapter nice_view" -DZMK_CONFIG=${ZMK_CONFIG_DIR}/config -DZMK_EXTRA_MODULES="$(subst $(SPACE),;,$(EXTRA_MODULES))"

deploy_lily58: lily58
	@echo -n "Put lily58_left in update mode..."
	@until [ -d ${NANO_PATH} ]; do sleep 1s; done
	@echo
	cp -v ${BUILD_DIR}/$^_left/zephyr/zmk.uf2 ${NANO_PATH}/
	@echo -n "Put lily58_right in update mode..."
	@until [ -d ${NANO_PATH} ]; do sleep 1s; done
	@echo
	cp -v ${BUILD_DIR}/$^_right/zephyr/zmk.uf2 ${NANO_PATH}/

lotus58: lotus58_ble
lotus58_ble: lotus58_ble_left lotus58_ble_right
lotus58_ble_left lotus58_ble_right: EXTRA_MODULES += ${LOTUS58_BLE_CONFIG_DIR}
lotus58_ble_left lotus58_ble_right:
	cd ${APP_DIR} && west build -d build/$@ -b $@ ${SNIPPETS} -- -DZMK_CONFIG=${ZMK_CONFIG_DIR}/config -DZMK_EXTRA_MODULES="$(subst $(SPACE),;,$(EXTRA_MODULES))"

deploy_lotus58: lotus58_ble
	@echo -n "Put lotus58_ble_left in update mode..."
	@until [ -d ${NANO_PATH} ]; do sleep 1s; done
	@echo
	cp -v ${BUILD_DIR}/$^_left/zephyr/zmk.uf2 ${UF2B_PATH}/
	@echo -n "Put lotus58_ble_right in update mode..."
	@until [ -d ${NANO_PATH} ]; do sleep 1s; done
	@echo
	cp -v ${BUILD_DIR}/$^_right/zephyr/zmk.uf2 ${UF2B_PATH}/

tern: tern_ble
tern_ble: EXTRA_MODULES += ${TERN_CONFIG_DIR} ${ZMK_AUTO_LAYER_DIR} ${ZMK_TRI_STATE_DIR}
tern_ble:
	cd ${APP_DIR} && west build -d build/$@ -b seeeduino_xiao_ble ${SNIPPETS} -- -DSHIELD=$@ -DZMK_CONFIG=${ZMK_CONFIG_DIR}/config -DZMK_EXTRA_MODULES="$(subst $(SPACE),;,$(EXTRA_MODULES))"

deploy_tern: tern
	@echo -n "Put $^ in update mode..."
	@until [ -d ${XIAO_PATH} ]; do sleep 1s; done
	@echo
	cp -v ${BUILD_DIR}/tern_ble/zephyr/zmk.uf2 ${XIAO_PATH}/

weejock: EXTRA_MODULES += ${WEEJOCK_CONFIG_DIR}
weejock:
	cd ${APP_DIR} && west build -d build/$@ -b seeeduino_xiao_ble -S studio-rpc-usb-uart -- -DSHIELD=$@ -DCONFIG_ZMK_STUDIO=y -DZMK_CONFIG=${ZMK_CONFIG_DIR}/config -DZMK_EXTRA_MODULES="$(subst $(SPACE),;,$(EXTRA_MODULES))"

zaphod: zaphod_lite
zaphod_lite: EXTRA_MODULES += ${ZAPHOD_CONFIG_DIR} ${ZMK_AUTO_LAYER_DIR} ${ZMK_TRI_STATE_DIR}
zaphod_lite:
	cd ${APP_DIR} && west build -d build/$@ -b seeeduino_xiao_ble -- -DSHIELD=$@ -DZMK_CONFIG=${ZMK_CONFIG_DIR}/config -DZMK_EXTRA_MODULES="$(subst $(SPACE),;,$(EXTRA_MODULES))"

deploy_zaphod: zaphod_lite
	@echo -n "Put zaphod_lite in update mode..."
	@until [ -d ${XIAO_PATH} ]; do sleep 1s; done
	@echo
	cp -v ${BUILD_DIR}/zaphod_lite/zephyr/zmk.uf2 ${XIAO_PATH}/

# For getting UF2s from WSL to the Windows desktop.
transfer:
	@for x in ${KBD_PARTS}; do \
	if [ -d ${BUILD_DIR}/$${x} ]; then cp -v ${BUILD_DIR}/$${x}/zephyr/zmk.uf2 ${WIN_DESKTOP}/$${x}.uf2 ; fi \
	done

clean:
	rm -rf ${BUILD_DIR}
