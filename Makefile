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
	@if [ ! -d example/build/flutter-spotlight-ant ]; then \
		mv example/build/web example/build/flutter-spotlight-ant; \
	fi
	cd example/build && python3 -m http.server

##@ Build
.PHONY: bump
bump: install-bumper ## Bump version
	@current=$$(grep '^version:' pubspec.yaml | head -n1 | cut -d' ' -f2); \
	read -p "Enter new version (current is $$current): " version; \
	if [[ ! $$version =~ ^[0-9]+\.[0-9]+\.[0-9]+$$ ]]; then \
		echo "Version must be in x.x.x format"; \
		exit 1; \
	fi; \
	if [[ $$(echo -e "$$version\n$$current" | sort -V | head -n1) == $$version ]]; then \
		echo "Version must be above $$current"; \
		exit 1; \
	fi; \
	sed -i.bk '3s/version: *.*.*/version: '$$version'/' pubspec.yaml; \
	rm pubspec.yaml.bk; \
	bumper --latestVersion=v$$version \
		--repoLink https://github.com/evan361425/flutter-spotlight-ant \
		--tagNames production \
		--tagPatterns 'v[0-9]+.[0-9]+.[0-9]+$$' \
		--changelogTemplate '{content}'

##@ Tools
.PHONY: install-bumper
install-bumper: ## Install bumper
	@if ! command -v bumper &> /dev/null; then \
		npm i --global @evan361425/version-bumper; \
	fi
