# Basics zum Makefile:
#	https://makefiletutorial.com/#getting-started
#
# You can set these variables from the command line.
# BUILDDIR      = _build

.PHONY: help clean deploy finalize

.DEFAULT_GOAL := help

# NOTE: Developers need to install sassc by the platform-dependent package
#       manager or npm.
SASSC ?= sassc

# Install via npm: npm -g i uglify-js
UGLIFYJS ?= uglifyjs
UGLIFYJS_FLAGS = --compress --mangle --comments '/^!/'

# BUILD_FOLDER=.theme
BUILD_FOLDER=/Volumes/Distribution/.themes

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
	@echo "    Auf der Serverseite: (in /srv/dist)"
	@echo "                         rm -rf .theme1 && cp -a /srv/share/NginxTheme/theme1/ .theme1 && chgrp -R www-data .theme1"

# Clean the build directory.
clean:
	rm -rf ${BUILD_FOLDER} layout/*.d

# Generate the build directory if it doesn't exist yet.
build:
	mkdir -p ${BUILD_FOLDER}/theme1/js ${BUILD_FOLDER}/theme2/js

#${BUILD_FOLDER}/theme1/%.css: layout/theme1/%.scss build
#	#mkdir -p $(dir $@)
#	@echo "-- "$<", $(dir $@) > $@"
#	$(SASSC) -M $< $@

# The following definitions will be used to generate CSS files from the
# corresponding SASS files.
#
${BUILD_FOLDER}/theme1/%.css: layout/theme1/%.scss build
	$(SASSC) -M $< $@ > layout/$*.d
	$(SASSC) $(SASSC_FLAGS) ${} $< $@

${BUILD_FOLDER}/theme2/%.css: layout/theme2/%.scss build
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
${BUILD_FOLDER}/js/%.js: layout/js/%.js build
	$(UGLIFYJS) $(UGLIFYJS_FLAGS) ${} -- $< > ${BUILD_FOLDER}/theme1/js/$(notdir $<)
	$(UGLIFYJS) $(UGLIFYJS_FLAGS) ${} -- $< > ${BUILD_FOLDER}/theme2/js/$(notdir $<)


#${BUILD_FOLDER}/images/%.ico: layout/images/%.ico build
##   @echo "$< > $@"
#	cp $< $@

# Most of the files just need to be copied into the build directory. This rule
# will match all files, that are not matched by any other (specialized) rule
# above.
${BUILD_FOLDER}/%: layout/% build
	cp $< $@

deploy: all

all: ${BUILD_FOLDER}/js/list.js        \
     ${BUILD_FOLDER}/js/breadcrumbs.js \
     ${BUILD_FOLDER}/theme1/favicon.png \
     ${BUILD_FOLDER}/theme1/header.html \
     ${BUILD_FOLDER}/theme1/footer.html \
     ${BUILD_FOLDER}/theme1/style.css \
     ${BUILD_FOLDER}/theme2/favicon.png \
     ${BUILD_FOLDER}/theme2/header.html \
     ${BUILD_FOLDER}/theme2/footer.html \
     ${BUILD_FOLDER}/theme2/style.css \
     finalize

finalize:
	# chmod -R 644 ${BUILD_FOLDER}/theme1/*.ico
	# find ${BUILD_FOLDER} -type d -exec chmod 755 {} \;
	# find ${BUILD_FOLDER} -type f -exec chmod 644 {} \;




