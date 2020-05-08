###############################################################################
###                          MAKEFILE TEMPLATE                              ###
###############################################################################
# This Makefile template can be used to qickly generate help messages for make.
# It is based on dynamic variables (see make manual)
#
# THIS MAKEFILE NEEDS TO BE INCLUDED AFTER ALL DECLARATIONS!
#
# predefined targets:
#   default: is executed when no target is specified
#   all: executes all steps
#   check: check if targets can run
#   setup: modify/setup environment
#   build: build project
#   test:  run project tests
#   clean: remove generated files
#   distclean: remove everything that was created by the toolchain
#
# to add your own targets to these predefined targets,
# just append your target name to the corresponding variable.
# I.e. to add your target 'build' to 'default' and 'all', do
# TARGET_all     += build-foo
# TARGET_default += build-foo
#
# own targets should be added to the 'TARGET' variable, so help can find them.
# I.e. to add your target 'bar', do
# TARGET += bar
#
# if a target has subtargets, you can add them to the 'TARGET_<target>' to
# indicate them as subtarget.
# I.e. to add your subtarget 'bar-lib' of 'bar', do
# TARGET_bar += bar-lib
#
# to set the help text you have to set the variable 'HELP_<target>'
# I.e to add the helptext for our 'build' target, do
# HELP_bar := build bar
#
# if you want to define variables, just add them to 'VARIABLE'
# I.e to add the variable 'CXX', do
# VARIABLE += CXX
# HELP_CXX := what compiler to use
#
# if you want to add custom variable topics, just add them to VARIABLE_TOPIC
# I.e to add the topic BUILDOPTION, do
# VARIABLE_TOPIC += BUILDOPTION
# VARIABLE_TOPIC_BUILDOPTION := build options
# you can now use the new topic instead of the generic VARIABLE one
# BUILDOPTION += OPTION_XY
#
# you may set the HELP variable to print a header in the help output
# I.e HELP := This Makefile does something

.DEFAULT_GOAL=default

HELP_default = run make $(TARGET_default)
.PHONY: default
default: $(TARGET_default)

HELP_all = run make $(TARGET_all)
.PHONY: all
all: $(TARGET_all)

HELP_check = run make $(TARGET_check)
.PHONY: check
check: $(TARGET_check)

HELP_setup = run make $(TARGET_setup)
.PHONY: setup
setup: $(TARGET_setup)

HELP_build = run make $(TARGET_build)
.PHONY: build
build: $(TARGET_build)

HELP_test = run make $(TARGET_test)
.PHONY: test
test: $(TARGET_test)

HELP_clean = run make $(TARGET_clean)
.PHONY: clean
clean: $(TARGET_clean)

HELP_distclean = run make clean $(TARGET_distclean)
.PHONY: distclean
distclean: clean $(TARGET_distclean)

VARIABLE_TOPIC_VARIABLE := variables
VARIABLE_TOPIC += VARIABLE

.PHONY: help
help:
	@echo "--- help ---"
	@[ -n "$(HELP)" ]             && echo -e "$(HELP)\n"                           || true;
	@[ -n "$(TARGET_default)" ]   && echo -e "make          \n\t$(HELP_default)"   || true;
	@[ -n "$(TARGET_all)" ]       && echo -e "make all      \n\t$(HELP_all)"       || true;
	@[ -n "$(TARGET_check)" ]     && echo -e "make check    \n\t$(HELP_check)"     || true;
	@[ -n "$(TARGET_setup)" ]     && echo -e "make setup    \n\t$(HELP_setup)"     || true;
	@[ -n "$(TARGET_build)" ]     && echo -e "make build    \n\t$(HELP_build)"     || true;
	@[ -n "$(TARGET_test)" ]      && echo -e "make test     \n\t$(HELP_test)"      || true;
	@[ -n "$(TARGET_clean)" ]     && echo -e "make clean    \n\t$(HELP_clean)"     || true;
	@[ -n "$(TARGET_distclean)" ] && echo -e "make distclean\n\t$(HELP_distclean)" || true;
	@[ -n "$(TARGET)" ]           && echo                                          || true;
	@$(foreach \
		target, \
		$(TARGET), \
		echo "make $(target)"; \
		[ -n "$(HELP_$(target))" ] && echo -e "\t$(HELP_$(target))" || true; \
	)
	@$(foreach \
		target, \
		$(TARGET), \
		[ -n "$(TARGET_$(target))" ] && echo -e "\n--- $(target) sub targets ---"  || true; \
		$(foreach \
			subtarget, \
			$(TARGET_$(target)), \
				echo "make $(subtarget)"; \
				[ -n "$(HELP_$(subtarget))" ] && echo -e "\t$(HELP_$(subtarget))" || true; \
		) \
	)
	@$(foreach \
		main, \
		check setup build test clean distclean, \
		[ -n "$(TARGET_$(main))" ] && echo -e "\n--- $(main) sub targets ---"  || true; \
		$(foreach \
			target, \
			$(TARGET_$(main)), \
			echo "make $(target)"; \
			[ -n "$(HELP_$(target))" ] && echo -e "\t$(HELP_$(target))" || true; \
		) \
	)
	@$(foreach \
		TOPIC, \
		$(VARIABLE_TOPIC), \
		[ -n "$($(TOPIC))" ] && echo -e "\n--- $(VARIABLE_TOPIC_$(TOPIC)) ---"  || true; \
		$(foreach \
			variable, \
			$($(TOPIC)), \
			echo "$(variable)"; \
			[ -n "$(HELP_$(variable))" ] && echo -e "\t$(HELP_$(variable))" || true; \
			echo -e "\t(currently: $($(variable)))"; \
		) \
	)
