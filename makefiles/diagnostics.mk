##@ Diagnostics

.PHONY: doctor
doctor: ## Check tool health
	./scripts/doctor

.PHONY: trace
trace: ## Trace startup order
	@printf "\033[36m==> Bash\033[0m\n"
	@printf "%b\n" "$(subst :,\n,$(shell ./scripts/trace bash))"
	@printf "\n\033[36m==> Zsh\033[0m\n"
	@printf "%b\n" "$(subst :,\n,$(shell ./scripts/trace zsh))"
