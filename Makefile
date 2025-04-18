.PHONY: clean all
.PHONY: apiaster apiaster_left apiaster_right
.PHONY: corne corne_left corne_right
.PHONY: ferris cradio_left cradio_right
.PHONY: lily58 lily58_left lily58_right
.PHONY: tern hummingbird
.PHONY: tester_rpi_pico
.PHONY: weejock
.PHONY: zaphod zaphod_lite
.PHONY: deploy_apiaster deploy_corne deploy_ferris deploy_lily58 deploy_tern deploy_weejock deploy_zaphod
.PHONY: transfer

APP_DIR := $(realpath ../zmk/app)
BUILD_DIR := ${APP_DIR}/build
ZMK_CONFIG_DIR := $(realpath ../zmk-config)
ZMK_HELPERS_DIR := $(realpath ../zmk-helpers)
ZMK_AUTO_LAYER_DIR := $(realpath ../zmk-auto-layer)
ZMK_TRI_STATE_DIR := $(realpath ../zmk-tri-state)
ZAPHOD_CONFIG_DIR := $(realpath ../zaphod-config)
WEEJOCK_CONFIG_DIR := $(realpath ../weejock-zmk)
TERN_CONFIG_DIR := $(realpath ../tern-zmk)
APIASTER_CONFIG_DIR := $(realpath ../zmk-apiaster-module)

EXTRA_MODULES := ${ZMK_HELPERS_DIR}

# Shenanigans for joining words with subst later.
EMPTY :=
SPACE := $(EMPTY) $(EMPTY)

XIAO_PATH := /media/${USER}/XIAO-SENSE
NANO_PATH := /media/${USER}/NICENANO
ZERO_PATH := /media/${USER}/RPI-RP2

WIN_DESKTOP := /mnt/c/Users/${USER}/Desktop
KBD_PARTS := apiaster_left apiaster_right \
	corne_left corne_right \
	cradio_left cradio_right \
	lily58_left lily58_right \
	promicro_cradio_left promicro_cradio_right \
	tern_ble \
	tester_rpi_pico \
	weejock \
	zaphod_lite

all: apiaster corne ferris weejock tern zaphod

apiaster: apiaster_left apiaster_right
	ls -l ${BUILD_DIR}/apiaster_*/zephyr/zmk.uf2
# apiaster_left: SNIPPETS = -S zmk-usb-logging
apiaster_left apiaster_right: EXTRA_MODULES += ${APIASTER_CONFIG_DIR}
apiaster_left apiaster_right:
	cd ${APP_DIR} && west build -d build/$@ -b seeeduino_xiao_ble ${SNIPPETS} -- -DSHIELD=$@ ${CMAKEFLAGS} -DZMK_CONFIG=${ZMK_CONFIG_DIR}/config -DZMK_EXTRA_MODULES="$(subst $(SPACE),;,$(EXTRA_MODULES))"

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
	cd ${APP_DIR} && west build -d build/promicro_$@ -b sparkfun_pro_micro_rp2040 ${SNIPPETS} -- -DSHIELD=$@ -DCONFIG_MAIN_STACK_SIZE=4096 -DZMK_CONFIG=${ZMK_CONFIG_DIR}/config -DZMK_EXTRA_MODULES="$(subst $(SPACE),;,$(EXTRA_MODULES))"

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

tern: tern_ble
tern_ble: EXTRA_MODULES += ${TERN_CONFIG_DIR} ${ZMK_AUTO_LAYER_DIR} ${ZMK_TRI_STATE_DIR}
tern_ble:
	cd ${APP_DIR} && west build -d build/$@ -b seeeduino_xiao_ble ${SNIPPETS} -- -DSHIELD=$@ -DZMK_CONFIG=${ZMK_CONFIG_DIR}/config -DZMK_EXTRA_MODULES="$(subst $(SPACE),;,$(EXTRA_MODULES))"

deploy_tern: tern
	@echo -n "Put $^ in update mode..."
	@until [ -d ${XIAO_PATH} ]; do sleep 1s; done
	@echo
	cp -v ${BUILD_DIR}/tern_ble/zephyr/zmk.uf2 ${XIAO_PATH}/

tester_rpi_pico: SNIPPETS = -S studio-rpc-usb-uart -S usb-logging
tester_rpi_pico:
	cd ${APP_DIR} && west build -d build/$@ -b rpi_pico ${SNIPPETS} -- -DSHIELD=$@ -DZMK_CONFIG=${ZMK_CONFIG_DIR}/config -DZMK_EXTRA_MODULES="$(subst $(SPACE),;,$(EXTRA_MODULES))"

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
