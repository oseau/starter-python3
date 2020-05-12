NAME := dev-python3

.PHONY: dev
dev: ## start a dev docker
	@$(MAKE) log.info MSG="starting dev docker"
	@docker run -it --rm --name $(NAME) -v $(shell pwd):/app -w /app $(shell docker build -q .) /app/start

.PHONY: login
login: ## login dev docker
	@$(MAKE) log.info MSG="login dev docker"
	@docker exec -it $(NAME) /bin/sh

.PHONY: dev-install-dependencies
dev-install-dependencies: ## install dependencies to use in IDE
	@$(MAKE) log.info MSG="start installing"
	@rm -rf .venv && python -m venv .venv && source .venv/bin/activate && pip install -i https://mirrors.cloud.tencent.com/pypi/simple --upgrade pip && pip install -r requirements.txt && deactivate

# Absolutely awesome: http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help

# https://github.com/zephinzer/godev/blob/62012ce006df8a3131ee93a74bcec2066405fb60/Makefile#L220
## blue logs
log.debug:
	-@printf -- "\033[0;36m_ [DEBUG] ${MSG}\033[0m\n"

## green logs
log.info:
	-@printf -- "\033[0;32m> [INFO] ${MSG}\033[0m\n"

## yellow logs
log.warn:
	-@printf -- "\033[0;33m? [WARN] ${MSG}\033[0m\n"

## red logs (die mf)
log.error:
	-@printf -- "\033[0;31m! [ERROR] ${MSG}\033[0m\n"
