.PHONY: clean all
.PHONY: apiaster apiaster_left apiaster_right
.PHONY: bykeeb bykeeb_left bykeeb_right
.PHONY: corne corne_left corne_right
.PHONY: ferris cradio_left cradio_right
.PHONY: lily58 lily58_left lily58_right
.PHONY: tern hummingbird
.PHONY: weejock
.PHONY: zaphod zaphod_lite
.PHONY: deploy_apiaster deploy_bykeeb deploy_corne deploy_ferris deploy_lily58 deploy_tern deploy_weejock deploy_zaphod
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
BYKEEB_CONFIG_DIR := $(realpath ../zmk-fingerpunch-keyboards)
VIK_MODULE_DIR := $(realpath ../zmk-fingerpunch-vik)
FINGERPUNCH_DIR := $(realpath ../zmk-fingerpunch-controllers)
STRATAGUM_CONFIG_DIR := $(realpath ../stratagum-zmk)

EXTRA_MODULES := ${ZMK_HELPERS_DIR}

# Shenanigans for joining words with subst later.
EMPTY :=
SPACE := $(EMPTY) $(EMPTY)

MEDIA_BASE := $(shell test -d /run/media/${USER} && echo /run/media/${USER} || echo /media/${USER})
XIAO_PATH := ${MEDIA_BASE}/XIAO-SENSE
NANO_PATH := ${MEDIA_BASE}/NICENANO
ZERO_PATH := ${MEDIA_BASE}/RPI-RP2

# $(1): label  $(2): mount path  $(3): uf2 source
define flash_part
	@echo -n "Put $(1) in update mode..."
	@until [ -d $(2) ]; do sleep 1s; done
	@echo
	cp -v $(3) $(2)/
	@sync
	@until [ ! -d $(2) ]; do sleep 1s; done
endef

WIN_DESKTOP := /mnt/c/Users/${USER}/Desktop
KBD_PARTS := apiaster_left apiaster_right \
	bykeeb_left bykeeb_right \
	corne_left corne_right \
	cradio_left cradio_right \
	lily58_left lily58_right \
	promicro_cradio_left promicro_cradio_right \
	stratagum \
	tern_ble \
	weejock \
	zaphod_lite

all: apiaster bykeeb corne ferris weejock tern zaphod

apiaster: apiaster_left apiaster_right
	ls -l ${BUILD_DIR}/apiaster_*/zephyr/zmk.uf2
# apiaster_left: SNIPPETS = -S zmk-usb-logging
apiaster_left apiaster_right: EXTRA_MODULES += ${APIASTER_CONFIG_DIR}
apiaster_left apiaster_right:
	cd ${APP_DIR} && west build -d build/$@ -b xiao_ble ${SNIPPETS} -- -DSHIELD=$@ ${CMAKEFLAGS} -DZMK_CONFIG=${ZMK_CONFIG_DIR}/config -DZMK_EXTRA_MODULES="$(subst $(SPACE),;,$(EXTRA_MODULES))"

bykeeb: bykeeb_left bykeeb_right
bykeeb_left bykeeb_right: EXTRA_MODULES += ${BYKEEB_CONFIG_DIR} ${VIK_MODULE_DIR} ${FINGERPUNCH_DIR} ${ZMK_AUTO_LAYER_DIR} ${ZMK_TRI_STATE_DIR}
bykeeb_left bykeeb_right:
	cd ${APP_DIR} && west build -d build/$@ -b xiao_ble ${SNIPPETS} -- -DSHIELD=$@ ${CMAKEFLAGS} -DZMK_CONFIG=${ZMK_CONFIG_DIR}/config -DZMK_EXTRA_MODULES="$(subst $(SPACE),;,$(EXTRA_MODULES))"

corne: corne_left corne_right
	ls -l ${BUILD_DIR}/corne_*/zephyr/zmk.uf2
corne_left corne_right:
	cd ${APP_DIR} && west build -d build/$@ -b nice_nano_v2 -- -DSHIELD=$@ ${CMAKEFLAGS} -DZMK_CONFIG=${ZMK_CONFIG_DIR}/config -DZMK_EXTRA_MODULES="$(subst $(SPACE),;,$(EXTRA_MODULES))"

deploy_apiaster: apiaster
	$(call flash_part,apiaster_left,${XIAO_PATH},${BUILD_DIR}/apiaster_left/zephyr/zmk.uf2)
	$(call flash_part,apiaster_right,${XIAO_PATH},${BUILD_DIR}/apiaster_right/zephyr/zmk.uf2)

deploy_corne: corne
	$(call flash_part,corne_left,${NANO_PATH},${BUILD_DIR}/corne_left/zephyr/zmk.uf2)
	$(call flash_part,corne_right,${NANO_PATH},${BUILD_DIR}/corne_right/zephyr/zmk.uf2)

ferris: cradio_left cradio_right
cradio_left: SNIPPETS = -S zmk-usb-logging
cradio_left cradio_right:
	cd ${APP_DIR} && west build -d build/$@ -b nice_nano_v2 ${SNIPPETS} -- -DSHIELD=$@ -DZMK_CONFIG=${ZMK_CONFIG_DIR}/config -DZMK_EXTRA_MODULES="$(subst $(SPACE),;,$(EXTRA_MODULES))"
	cd ${APP_DIR} && west build -d build/promicro_$@ -b sparkfun_pro_micro_rp2040 ${SNIPPETS} -- -DSHIELD=$@ -DCONFIG_MAIN_STACK_SIZE=4096 -DZMK_CONFIG=${ZMK_CONFIG_DIR}/config -DZMK_EXTRA_MODULES="$(subst $(SPACE),;,$(EXTRA_MODULES))"

deploy_ferris: ferris
	$(call flash_part,ferris_left,${NANO_PATH},${BUILD_DIR}/cradio_left/zephyr/zmk.uf2)
	$(call flash_part,ferris_right,${NANO_PATH},${BUILD_DIR}/cradio_right/zephyr/zmk.uf2)

lily58: lily58_left lily58_right
lily58_left: # SNIPPETS = -S zmk-usb-logging
lily58_left lily58_right:
	cd ${APP_DIR} && west build -d build/$@ -b nice_nano_v2 ${SNIPPETS} -- -DSHIELD="$@ nice_view_adapter nice_view" -DZMK_CONFIG=${ZMK_CONFIG_DIR}/config -DZMK_EXTRA_MODULES="$(subst $(SPACE),;,$(EXTRA_MODULES))"

deploy_lily58: lily58
	$(call flash_part,lily58_left,${NANO_PATH},${BUILD_DIR}/lily58_left/zephyr/zmk.uf2)
	$(call flash_part,lily58_right,${NANO_PATH},${BUILD_DIR}/lily58_right/zephyr/zmk.uf2)

stratagum: EXTRA_MODULES += ${STRATAGUM_CONFIG_DIR}
stratagum:
	cd ${APP_DIR} && west build -d build/$@ -b rp2040_zero ${SNIPPETS} -- -DSHIELD=$@ ${CMAKEFLAGS} -DZMK_CONFIG=${ZMK_CONFIG_DIR}/config -DZMK_EXTRA_MODULES="$(subst $(SPACE),;,$(EXTRA_MODULES))"

tern: tern_ble
tern_ble: EXTRA_MODULES += ${TERN_CONFIG_DIR} ${ZMK_AUTO_LAYER_DIR} ${ZMK_TRI_STATE_DIR}
tern_ble:
	cd ${APP_DIR} && west build -d build/$@ -b xiao_ble ${SNIPPETS} -- -DSHIELD=$@ -DZMK_CONFIG=${ZMK_CONFIG_DIR}/config -DZMK_EXTRA_MODULES="$(subst $(SPACE),;,$(EXTRA_MODULES))"

deploy_tern: tern
	$(call flash_part,tern_ble,${XIAO_PATH},${BUILD_DIR}/tern_ble/zephyr/zmk.uf2)

weejock: EXTRA_MODULES += ${WEEJOCK_CONFIG_DIR}
weejock:
	cd ${APP_DIR} && west build -d build/$@ -b xiao_ble -S studio-rpc-usb-uart -- -DSHIELD=$@ -DCONFIG_ZMK_STUDIO=y -DZMK_CONFIG=${ZMK_CONFIG_DIR}/config -DZMK_EXTRA_MODULES="$(subst $(SPACE),;,$(EXTRA_MODULES))"

zaphod: zaphod_lite
zaphod_lite: EXTRA_MODULES += ${ZAPHOD_CONFIG_DIR} ${ZMK_AUTO_LAYER_DIR} ${ZMK_TRI_STATE_DIR}
zaphod_lite:
	cd ${APP_DIR} && west build -d build/$@ -b xiao_ble -- -DSHIELD=$@ -DZMK_CONFIG=${ZMK_CONFIG_DIR}/config -DZMK_EXTRA_MODULES="$(subst $(SPACE),;,$(EXTRA_MODULES))"

deploy_weejock: weejock
	$(call flash_part,weejock,${XIAO_PATH},${BUILD_DIR}/weejock/zephyr/zmk.uf2)

deploy_zaphod: zaphod_lite
	$(call flash_part,zaphod_lite,${XIAO_PATH},${BUILD_DIR}/zaphod_lite/zephyr/zmk.uf2)

# For getting UF2s from WSL to the Windows desktop.
transfer:
	@for x in ${KBD_PARTS}; do \
	if [ -d ${BUILD_DIR}/$${x} ]; then cp -v ${BUILD_DIR}/$${x}/zephyr/zmk.uf2 ${WIN_DESKTOP}/$${x}.uf2 ; fi \
	done

clean:
	rm -rf ${BUILD_DIR}
