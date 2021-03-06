# Makefile for use in deploying stable releases to sites.
# To use this, cd to the chapter site, then run `make -f path/to/this/file`.
# If the chapter has a custom branch, or local changes that can't be rebased,
# the script will exit, and you'll need to fix it up then run "make finish".
# TODO(benkraft): at some point maybe we'll want a proper automation framework
# like puppet or chef or whatever.
SHELL=/bin/bash
SITE:=$(notdir $(PWD))
STASH:=$(shell sudo -u www-data git diff HEAD --quiet || echo true)

sr-8: NEWBRANCH=stable-release-8
sr-8: OLDBRANCH=stable-release-7
sr-8: pre src finish

pre:
	@echo "Backing things up and fixing permissions."
	sudo -u postgres pg_dump $(SITE)_django | gzip > $(SITE)_$(shell date +"%Y%m%d").sql.gz
	-sudo chown -RL "www-data:www-data" .

src:
	@echo "Attempting to do the git stuff automatically; if this fails for any reason, fix it up and run 'make finish'."
	[ "$$(git rev-parse --abbrev-ref HEAD)" = "$(OLDBRANCH)" ]  # Assert we're on OLDBRANCH
	if [ "$(STASH)" = "true" ] ; then sudo -u www-data git stash ; fi
	sudo -u www-data git fetch origin
	sudo -u www-data git remote prune origin
	sudo -u www-data git checkout $(NEWBRANCH)
	if [ "$(STASH)" = "true" ] ; then sudo -u www-data git stash pop ; fi

finish:
	@echo "Updating the site; if this fails for any reason, fix it up and (re-)run 'make finish'."
	esp/update_deps.sh
	sudo -u www-data esp/manage.py update
	sudo -u www-data touch esp.wsgi
	@echo "Done! Go test some things."

.PHONY: pre src finish
