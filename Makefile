EXEC ?= Application
BUILD_CONFIGURATION ?= release

all: help

build:
	@echo "→ Building (configuration=$(BUILD_CONFIGURATION))"
	@swift build -c $(BUILD_CONFIGURATION)

run:
	@echo "→ Running $(EXEC)"
	@swift run $(EXEC)

format:
	@echo "→ Running formatter"
	@swift format --in-place --recursive .

lint:
	@echo "→ Running linter"
	@swift format lint --recursive .

clean:
	@echo "→ Cleaning build artifacts"
	@swift package clean
	@rm -rf .output .build

help:
	@printf "\nSwift Makefile — targets:\n\n"
	@printf "  %-10s %s\n" "make build" "Build release"
	@printf "  %-10s %s\n" "make run" "Run the executable"
	@printf "  %-10s %s\n" "make format" "Format code"
	@printf "  %-10s %s\n" "make lint" "Lint with swift lint"
	@printf "  %-10s %s\n" "make clean" "Clean build artifacts"
	@printf "  %-10s %s\n\n" "make help" "Show this help\n"
