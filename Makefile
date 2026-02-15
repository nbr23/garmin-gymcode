# Usage:
#   make build target=DEVICE_ID

MONKEYC=monkeyc
JUNGLE=monkey.jungle
OUT=bin/GymCode.prg
KEY=developer_key
target?=fenix7pro

.PHONY: build clean help push

build:
	@if grep -q 'MEMBERSHIP_ID = ""' source/gymcodeview.mc; then \
		echo "Error: MEMBERSHIP_ID is not set in source/gymcodeview.mc"; \
		echo "Please set your membership ID before building."; \
		exit 1; \
	fi
	$(MONKEYC) -d $(target) -f $(JUNGLE) -o $(OUT) -y $(KEY)

clean:
	rm -f ./bin

push: build
	./scripts/mtp-push.sh $(OUT)

help:
	@echo "Makefile targets:"
	@echo "  build target=DEVICE_ID  Build for specified target (default: fenix7pro)"
	@echo "  clean                   Remove built files"
	@echo "  push                    Build and push to watch via libmtp"
	@echo "  help                    Show this help message"

.DEFAULT_GOAL := build
