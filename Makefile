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
# pyo3, maturin, uv, ruff

.PHONY: py-sync
.SILENT: py-sync
py-sync: # Install dependencies (python)
	uv sync --all-extras --all-packages --group dev

.PHONY: py-lint
.SILENT: py-lint
py-lint: # Run the linter (python)
	uv run ruff check src/nodoka tests examples
	uv run ruff format --check src/nodoka tests examples

.PHONY: py-format
.SILENT: py-format
py-format: # Format the code (python)
	uv run ruff check --fix
	uv run ruff format

.PHONY: py-format-check
.SILENT: py-format-check
py-format-check: # Check code formatting (python)
	uv run ruff format --check

.PHONY: py-check
.SILENT: py-check
py-check: py-format-check py-lint tests # Run all checks (python)

# TODO: rust targets
