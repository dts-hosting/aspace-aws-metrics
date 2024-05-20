SHELL:=/bin/bash

.PHONY: lint
lint: ## make lint # Run all linters
	@gem install --quiet --silent standard
	@standardrb --fix
