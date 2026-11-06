# Reference: https://skills.sh/

##@ Skills

SKILLSFILE ?= platforms/Skillsfile

.PHONY: skills-diff
skills-diff: ## Diff agent skills against Skillsfile
	@./scripts/skills-diff

.PHONY: skills-install
skills-install: ## Install agent skills from Skillsfile
	@./scripts/skills-install
