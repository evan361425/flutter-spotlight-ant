SHELL := /usr/bin/env bash -o errexit -o pipefail -o nounset

.PHONY: help
help: ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-23s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Development
.PHONY: format
format: ## Format code
	dart format --set-exit-if-changed --line-length 120 .

.PHONY: test
test: ## Run tests
	flutter test

.PHONY: test-coverage
test-coverage: ## Run tests with coverage
	flutter test --coverage
	genhtml coverage/lcov.info -o coverage/html

.PHONY: build-example
build-example: ## Compile for GithHub Pages
	cd example && \
		flutter build web --release \
		--base-href "/flutter-spotlight-ant/"

.PHONY: serve-example
serve-example: ## Serve example in local
	@rm -rf example/build/flutter-spotlight-ant
	@mv example/build/web example/build/flutter-spotlight-ant
	cd example/build && python3 -m http.server

##@ Build
.PHONY: bump
bump: install-bumper ## Bump version
	bumper \
		--hook-repl[]paths[] 'pubspec.yaml' \
		--hook-repl[]pattern '^version: .+' \
		--hook-repl[]repl 'version: {version.noPrefix}' \

##@ Tools
.PHONY: install-bumper
install-bumper: ## Install bumper
	@if ! command -v bumper &> /dev/null; then \
		npm i --global @evan361425/version-bumper; \
	fi
