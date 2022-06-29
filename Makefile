# Basics zum Makefile:
#	https://makefiletutorial.com/#getting-started
#
# You can set these variables from the command line.
# BUILDDIR      = _build

.PHONY: help clean deploy

.DEFAULT_GOAL := help

# NOTE: Developers need to install sassc by the platform-dependent package
#       manager or npm.
SASSC ?= sassc

# Install via npm: npm -g i uglify-js
UGLIFYJS ?= uglifyjs
UGLIFYJS_FLAGS = --compress --mangle --comments '/^!/'

help:
	@echo
	@echo "Please use 'make <${YELLOW}target${RESET}>' where <target> is one of"
	@echo
	@echo "    ${YELLOW}help          ${GREEN}This help message${RESET}"
	@echo "    ${YELLOW}clean         ${GREEN}Cleans up all unnecessary files and dirs${RESET}"
	@echo "    ${YELLOW}build         ${GREEN}Build your application package${RESET}"
	@echo "    ${YELLOW}deploy        ${GREEN}Builds package and deploys it to ${TARGET_SSH_HOST}-Server${RESET}"
	@echo
	@echo "${BLUE}Hints:${NC}"
	@echo

# Clean the build directory.
clean:
	rm -rf build layout/*.d

# Generate the build directory if it doesn't exist yet.
build:
	mkdir -p build/js build/images

# The following definitions will be used to generate CSS files from the
# corresponding SASS files.
#
build/%.css: layout/%.scss build
	$(SASSC) -M $< $@ > layout/$*.d
	$(SASSC) $(SASSC_FLAGS) ${} $< $@

# Include the generated dependency list of the main less file to regenerate the
# CSS file, if one of its imported files is touched.
-include layout/theme.d

# The following definitions will be used to minify the JavaScript files of the
# theme.
#
# NOTE: Developers need to install uglifyjs by the platform-dependent package
#       manager or npm.
build/js/%.js: layout/js/%.js build
	$(UGLIFYJS) $(UGLIFYJS_FLAGS) ${} -- $< > $@

build/images/%.ico: layout/images/%.ico build
#   @echo "$< > $@"
	cp $< $@

# Most of the files just need to be copied into the build directory. This rule
# will match all files, that are not matched by any other (specialized) rule
# above.
build/%: layout/% build
	cp $< $@

deploy: all
	 chmod -R 644 build/images/*.ico

all: build/theme.css      \
     build/js/list.js        \
     build/js/breadcrumbs.js \
     build/header.html       \
     build/footer.html       \
     build/images/favicon.ico 




