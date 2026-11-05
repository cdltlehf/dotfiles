# Reference: https://skills.sh/

##@ Skills

SKILLS_JSON ?= $(XDG_CONFIG_HOME)/agents/skills.json
SKILLS_LOCK ?= $(XDG_STATE_HOME)/skills/.skill-lock.json

.PHONY: skills-diff
skills-diff: ## Diff agent skills against skills.json
	@diff -u --color=auto \
		--label "skills.json" --label "installed" \
		<(jq . $(SKILLS_JSON) 2>/dev/null || echo "[]") \
		<(jq -r '.skills[].source // empty' $(SKILLS_LOCK) 2>/dev/null | sort -u | jq -nR '[inputs] | sort') || true
