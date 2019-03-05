.PHONY: tree
tree:
	@tree -I vendor

.PHONY: clean
clean:
	@git status --ignored --short | grep '^!! ' | sed 's/!! //' | xargs rm -rf