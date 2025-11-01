sources = python/nodoka tests

default: help

.PHONY: help
help:
	@echo "\033[1;32mNodoka Makefile\033[0m"
	@echo ""
	@echo "\033[1;32mUsage:\033[0m \033[1;36mmake <target>\033[0m"
	@echo ""
	@echo "\033[1;32mAvailable targets:\033[0m"
	@grep -E '^[a-zA-Z0-9 _-]+:.*#' Makefile | \
		while read -r line; do \
		name=$$(echo $$line | cut -d':' -f1); \
		desc=$$(echo $$line | cut -d'#' -f2-); \
		printf "  \033[1;36m%-15s\033[0m %s\n" "$${name}" "$$desc"; \
	done

# Nodoka Project

.PHONY: sync
.SILENT: sync
sync: # Install package dependencies
	uv sync --all-extras --all-packages --group dev

.PHONY: build-dev  
build-dev: # Build the development version of the package
	@rm -f python/nodoka/*.so
	uv run maturin develop --uv

.PHONY: build-prod  
build-prod: # Build the production version of the package
	@rm -f python/nodoka/*.so
	uv run maturin develop --uv --release

.PHONY: format
.SILENT: format
format: # Format the code python and rust
	uv run ruff check --fix $(sources)
	uv run ruff format $(sources)
	cargo fmt

.PHONY: lint-python
.SILENT: lint-python
lint-python: # Lint python source files
	uv run ruff check $(sources)
	uv run ruff format --check $(sources)

.PHONY: lint-rust
.SILENT: lint-rust
lint-rust: # Lint rust source files
	cargo fmt --version
	cargo fmt --all -- --check
	cargo clippy --version
	cargo clippy --tests -- -D warnings

.PHONY: lint
.SILENT: lint
lint: lint-python lint-rust # Lint python and rust source files

.PHONY: ty
.SILENT: ty
ty: # Perform type checks with ty
	uv run ty check $(sources)

# .PHONY: mypy
# .SILENT: mypy
# mypy: # Perform type checks with mypy
# 	uv run mypy $(sources)

.PHONY: tests
.SILENT: tests
tests: # Run all tests
	uv run pytest

# utils

.PHONY: clean
.SILENT: clean
clean: # Clear local caches and build artifacts
	rm -rf `find . -name __pycache__`
	rm -f `find . -type f -name '*.py[co]' `
	rm -f `find . -type f -name '*~' `
	rm -f `find . -type f -name '.*~' `
	rm -rf *.egg-info
	rm -rf build
	rm -rf perf.data*
	rm -rf python/nodoka/*.so