##@ Diagnostics

.PHONY: doctor
doctor: ## Check tool health
	./scripts/doctor

.PHONY: trace
trace: ## Trace startup order
	@printf "POSIX sh:\n"
	@./scripts/trace sh -l -i
	@printf "\nBash:\n"
	@./scripts/trace bash -l -i
	@printf "\nZsh:\n"
	@./scripts/trace zsh -l -i
