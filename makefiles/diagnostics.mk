##@ Diagnostics

BASH_BIN := $(shell command -v bash)
ZSH_BIN := $(shell command -v zsh)

.PHONY: doctor
doctor: ## Check tool health
	./scripts/doctor

.PHONY: trace
trace: ## Trace startup order
ifneq ($(BASH_BIN),)
	@printf "\033[36m==> $(BASH_BIN) -l -i\033[0m\n"
	@printf "%b\n" "$(subst :,\n,$(shell ./scripts/trace $(BASH_BIN) -l -i))"
	@printf "\n\033[36m==> $(BASH_BIN) -i\033[0m\n"
	@printf "%b\n" "$(subst :,\n,$(shell ./scripts/trace $(BASH_BIN) -i))"
endif
ifneq ($(ZSH_BIN),)
	@printf "\n\033[36m==> $(ZSH_BIN) -l -i\033[0m\n"
	@printf "%b\n" "$(subst :,\n,$(shell ./scripts/trace $(ZSH_BIN) -l -i))"
	@printf "\n\033[36m==> $(ZSH_BIN) -i\033[0m\n"
	@printf "%b\n" "$(subst :,\n,$(shell ./scripts/trace $(ZSH_BIN) -i))"
endif
