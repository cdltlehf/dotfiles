# Reference: https://www.gnu.org/software/diffutils/manual/diffutils.html

##@ Templates

# The root tracks copies of the top-level files of xdg-templates-dir, with
# dot_ replaced by a leading dot, so that this repository can differ where
# it must. Change a template first, then copy it. prek.toml and REFERENCES
# differ on purpose.
.PHONY: templates-diff
templates-diff: ## Diff the repository configs against their templates
	@for template in xdg-templates-dir/*; do \
		[[ -f "$${template}" ]] || continue; \
		file="$$(basename "$${template}")"; \
		diff -uN --color=auto "$${template}" "$${file/#dot_/.}" || true; \
	done
