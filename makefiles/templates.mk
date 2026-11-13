# Reference: https://www.gnu.org/software/diffutils/manual/diffutils.html

##@ Templates

.PHONY: templates-diff
# The root Makefile runs this repository rather than starting from the template.
templates-diff: EXCLUDE := Makefile
templates-diff: ## Diff the repository configs against their templates
	@for template in xdg-templates-dir/*; do \
		[[ -f "$${template}" ]] || continue; \
		file="$$(basename "$${template}")"; \
		[[ " $(EXCLUDE) " == *" $${file} "* ]] && continue; \
		diff -uN --color=auto "$${template}" "$${file/#dot_/.}" || true; \
	done
