# Reference: https://www.gnu.org/software/diffutils/manual/diffutils.html

##@ Templates

.PHONY: templates-diff
# The root Makefile runs this repository rather than starting from the template.
# AGENTS.md adds a section for this repository after the part it shares with
# the template, so only the shared part is compared.
templates-diff: EXCLUDE := Makefile
templates-diff: ## Diff the repository configs against their templates
	@for template in xdg-templates-dir/*; do \
		[[ -f "$${template}" ]] || continue; \
		file="$$(basename "$${template}")"; \
		[[ " $(EXCLUDE) " == *" $${file} "* ]] && continue; \
		file="$${file/#dot_/.}"; \
		if [[ "$${file}" == AGENTS.md ]]; then \
			diff -uN --color=auto --label "$${template}" --label "$${file}" "$${template}" \
				<(awk '/^## This repository$$/ { exit } { print }' "$${file}" | sed '$$ { /^$$/d; }') || true; \
		else \
			diff -uN --color=auto "$${template}" "$${file}" || true; \
		fi; \
	done
