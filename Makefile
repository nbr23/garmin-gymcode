MONKEYC ?= monkeyc
JUNGLE ?= monkey.jungle
OUT ?= bin/GymCode.prg
KEY ?= developer_key
GENERATED = source/BuildConfig.mc
target ?= fr970

.DEFAULT_GOAL := build
.PHONY: build clean push help config

config:
	./scripts/gen-config.sh

build: config
	"$(MONKEYC)" -d "$(target)" -f "$(JUNGLE)" -o "$(OUT)" -y "$(KEY)"

clean:
	rm -f -- "$(OUT)" "$(GENERATED)"

push: build
	./scripts/mtp-push.sh "$(OUT)"

help:
	@echo "  build   Build $(OUT) for target=$(target)"
	@echo "  config  Generate $(GENERATED) from .env"
	@echo "  clean   Remove build outputs"
	@echo "  push    Build and copy $(OUT) to the watch over MTP"
