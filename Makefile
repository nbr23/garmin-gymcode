MONKEYC ?= monkeyc
JUNGLE ?= monkey.jungle
OUT ?= bin/GymCode.prg
KEY ?= developer_key
target ?= fr970

.DEFAULT_GOAL := build
.PHONY: build clean push help

build:
	"$(MONKEYC)" -d "$(target)" -f "$(JUNGLE)" -o "$(OUT)" -y "$(KEY)"

clean:
	rm -f -- "$(OUT)"

push: build
	./scripts/mtp-push.sh "$(OUT)"

help:
	@echo "  build   Build $(OUT) for target=$(target)"
	@echo "  clean   Remove build outputs"
	@echo "  push    Build and copy $(OUT) to the watch over MTP"
