# Reference: https://www.gnu.org/software/diffutils/manual/diffutils.html

##@ Templates

.PHONY: templates-diff
templates-diff: ## Diff the repository configs against their templates
	@for template in xdg-templates-dir/*; do \
		[[ -f "$${template}" ]] || continue; \
		file="$$(basename "$${template}")"; \
		diff -uN --color=auto "$${template}" "$${file/#dot_/.}" || true; \
	done
