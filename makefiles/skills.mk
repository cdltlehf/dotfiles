# Reference: https://skills.sh/

##@ Skills

.PHONY: skills-diff
skills-diff: ## Diff agent skills against skills.json
	@./scripts/skills-diff
