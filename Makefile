# GBA rom header
TITLE       := POKEMON EMER
GAME_CODE   := BPEE
MAKER_CODE  := 01
REVISION    := 0
MODERN      ?= 0
KEEP_TEMPS  ?= 0

# `File name`.gba ('_modern' will be appended to the modern builds)
FILE_NAME := pokeemerald
BUILD_DIR := build

# Builds the ROM using a modern compiler
MODERN      ?= 0
# Compares the ROM to a checksum of the original - only makes sense using when non-modern
COMPARE     ?= 0

ifeq (modern,$(MAKECMDGOALS))
  MODERN := 1
endif
ifeq (compare,$(MAKECMDGOALS))
  COMPARE := 1
endif

# Default make rule
all: rom

# Toolchain selection
TOOLCHAIN := $(DEVKITARM)
# don't use dkP's base_tools anymore
# because the redefinition of $(CC) conflicts
# with when we want to use $(CC) to preprocess files
# thus, manually create the variables for the bin
# files, or use arm-none-eabi binaries on the system
# if dkP is not installed on this system
ifneq (,$(TOOLCHAIN))
  ifneq ($(wildcard $(TOOLCHAIN)/bin),)
    export PATH := $(TOOLCHAIN)/bin:$(PATH)
  endif
endif

PREFIX := arm-none-eabi-
OBJCOPY := $(PREFIX)objcopy
OBJDUMP := $(PREFIX)objdump
AS := $(PREFIX)as
LD := $(PREFIX)ld

EXE :=
<<<<<<< HEAD
ifeq ($(OS),Windows_NT)
  EXE := .exe
=======
endif

TITLE        := POKEMON EMER
GAME_CODE    := BPEE
MAKER_CODE   := 01
REVISION     := 0
MODERN       ?= 1
TEST         ?= 0
ANALYZE      ?= 0
UNUSED_ERROR ?= 0

ifeq (agbcc,$(MAKECMDGOALS))
  MODERN := 0
endif

ifeq (check,$(MAKECMDGOALS))
  TEST := 1
>>>>>>> 889a02d263ddef7383666aa2d5df26ef159e64f0
endif

# use arm-none-eabi-cpp for macOS
# as macOS's default compiler is clang
# and clang's preprocessor will warn on \u
# when preprocessing asm files, expecting a unicode literal
# we can't unconditionally use arm-none-eabi-cpp
# as installations which install binutils-arm-none-eabi
# don't come with it
ifneq ($(MODERN),1)
  ifeq ($(shell uname -s),Darwin)
    CPP := $(PREFIX)cpp
  else
    CPP := $(CC) -E
  endif
else
  CPP := $(PREFIX)cpp
endif

<<<<<<< HEAD
ROM_NAME := $(FILE_NAME).gba
OBJ_DIR_NAME := $(BUILD_DIR)/emerald
MODERN_ROM_NAME := $(FILE_NAME)_modern.gba
MODERN_OBJ_DIR_NAME := $(BUILD_DIR)/modern

ELF_NAME := $(ROM_NAME:.gba=.elf)
MAP_NAME := $(ROM_NAME:.gba=.map)
=======
ROM_NAME := pokeemerald_agbcc.gba
ELF_NAME := $(ROM_NAME:.gba=.elf)
MAP_NAME := $(ROM_NAME:.gba=.map)
OBJ_DIR_NAME := build/emerald

MODERN_ROM_NAME := pokeemerald.gba
>>>>>>> 889a02d263ddef7383666aa2d5df26ef159e64f0
MODERN_ELF_NAME := $(MODERN_ROM_NAME:.gba=.elf)
MODERN_MAP_NAME := $(MODERN_ROM_NAME:.gba=.map)

# Pick our active variables
ifeq ($(MODERN),0)
  ROM := $(ROM_NAME)
  OBJ_DIR := $(OBJ_DIR_NAME)
else
  ROM := $(MODERN_ROM_NAME)
  OBJ_DIR := $(MODERN_OBJ_DIR_NAME)
endif
ELF := $(ROM:.gba=.elf)
MAP := $(ROM:.gba=.map)
SYM := $(ROM:.gba=.sym)

<<<<<<< HEAD
# Commonly used directories
=======
TEST_OBJ_DIR_NAME_MODERN := build/modern-test
TEST_OBJ_DIR_NAME_AGBCC := build/test

ifeq ($(MODERN),0)
TEST_OBJ_DIR_NAME := $(TEST_OBJ_DIR_NAME_AGBCC)
else
TEST_OBJ_DIR_NAME := $(TEST_OBJ_DIR_NAME_MODERN)
endif
TESTELF = $(ROM:.gba=-test.elf)
HEADLESSELF = $(ROM:.gba=-test-headless.elf)

>>>>>>> 889a02d263ddef7383666aa2d5df26ef159e64f0
C_SUBDIR = src
ASM_SUBDIR = asm
DATA_SRC_SUBDIR = src/data
DATA_ASM_SUBDIR = data
SONG_SUBDIR = sound/songs
MID_SUBDIR = sound/songs/midi
<<<<<<< HEAD
=======
SAMPLE_SUBDIR = sound/direct_sound_samples
CRY_SUBDIR = sound/direct_sound_samples/cries
TEST_SUBDIR = test
>>>>>>> 889a02d263ddef7383666aa2d5df26ef159e64f0

C_BUILDDIR = $(OBJ_DIR)/$(C_SUBDIR)
ASM_BUILDDIR = $(OBJ_DIR)/$(ASM_SUBDIR)
DATA_ASM_BUILDDIR = $(OBJ_DIR)/$(DATA_ASM_SUBDIR)
SONG_BUILDDIR = $(OBJ_DIR)/$(SONG_SUBDIR)
MID_BUILDDIR = $(OBJ_DIR)/$(MID_SUBDIR)
TEST_BUILDDIR = $(OBJ_DIR)/$(TEST_SUBDIR)

SHELL := bash -o pipefail

# Set flags for tools
ASFLAGS := -mcpu=arm7tdmi --defsym MODERN=$(MODERN)

INCLUDE_DIRS := include
INCLUDE_CPP_ARGS := $(INCLUDE_DIRS:%=-iquote %)
INCLUDE_SCANINC_ARGS := $(INCLUDE_DIRS:%=-I %)

O_LEVEL ?= 2
CPPFLAGS := $(INCLUDE_CPP_ARGS) -Wno-trigraphs -DMODERN=$(MODERN)
ifeq ($(MODERN),0)
  CPPFLAGS += -I tools/agbcc/include -I tools/agbcc -nostdinc -undef
  CC1 := tools/agbcc/bin/agbcc$(EXE)
  override CFLAGS += -mthumb-interwork -Wimplicit -Wparentheses -Werror -O$(O_LEVEL) -fhex-asm -g
  LIBPATH := -L ../../tools/agbcc/lib
  LIB := $(LIBPATH) -lgcc -lc -L../../libagbsyscall -lagbsyscall
else
<<<<<<< HEAD
  # Note: The makefile must be set up to not call these if modern == 0
  MODERNCC := $(PREFIX)gcc
  PATH_MODERNCC := PATH="$(PATH)" $(MODERNCC)
  CC1 := $(shell $(PATH_MODERNCC) --print-prog-name=cc1) -quiet
  override CFLAGS += -mthumb -mthumb-interwork -O$(O_LEVEL) -mabi=apcs-gnu -mtune=arm7tdmi -march=armv4t -fno-toplevel-reorder -Wno-pointer-to-int-cast
  LIBPATH := -L "$(dir $(shell $(PATH_MODERNCC) -mthumb -print-file-name=libgcc.a))" -L "$(dir $(shell $(PATH_MODERNCC) -mthumb -print-file-name=libnosys.a))" -L "$(dir $(shell $(PATH_MODERNCC) -mthumb -print-file-name=libc.a))"
  LIB := $(LIBPATH) -lc -lnosys -lgcc -L../../libagbsyscall -lagbsyscall
endif
# Enable debug info if set
ifeq ($(DINFO),1)
  override CFLAGS += -g
endif

# Variable filled out in other make files
AUTO_GEN_TARGETS :=
include make_tools.mk
# Tool executables
GFX       := $(TOOLS_DIR)/gbagfx/gbagfx$(EXE)
AIF       := $(TOOLS_DIR)/aif2pcm/aif2pcm$(EXE)
MID       := $(TOOLS_DIR)/mid2agb/mid2agb$(EXE)
SCANINC   := $(TOOLS_DIR)/scaninc/scaninc$(EXE)
PREPROC   := $(TOOLS_DIR)/preproc/preproc$(EXE)
RAMSCRGEN := $(TOOLS_DIR)/ramscrgen/ramscrgen$(EXE)
FIX       := $(TOOLS_DIR)/gbafix/gbafix$(EXE)
MAPJSON   := $(TOOLS_DIR)/mapjson/mapjson$(EXE)
JSONPROC  := $(TOOLS_DIR)/jsonproc/jsonproc$(EXE)

PERL := perl
SHA1 := $(shell { command -v sha1sum || command -v shasum; } 2>/dev/null) -c
=======
CC1              = $(shell $(PATH_MODERNCC) --print-prog-name=cc1) -quiet
override CFLAGS += -mthumb -mthumb-interwork -O2 -mabi=apcs-gnu -mtune=arm7tdmi -march=armv4t -fno-toplevel-reorder -Wno-pointer-to-int-cast -std=gnu17 -Werror -Wall -Wno-strict-aliasing -Wno-attribute-alias -Woverride-init
ifeq ($(ANALYZE),1)
override CFLAGS += -fanalyzer
endif
# Only throw an error for unused elements if its RH-Hideout's repo
ifeq ($(UNUSED_ERROR),0)
ifneq ($(GITHUB_REPOSITORY_OWNER),rh-hideout)
override CFLAGS += -Wno-error=unused-variable -Wno-error=unused-const-variable -Wno-error=unused-parameter -Wno-error=unused-function -Wno-error=unused-but-set-parameter -Wno-error=unused-but-set-variable -Wno-error=unused-value -Wno-error=unused-local-typedefs
endif
endif
ROM := $(MODERN_ROM_NAME)
OBJ_DIR := $(MODERN_OBJ_DIR_NAME)
LIBPATH := -L "$(dir $(shell $(PATH_MODERNCC) -mthumb -print-file-name=libgcc.a))" -L "$(dir $(shell $(PATH_MODERNCC) -mthumb -print-file-name=libnosys.a))" -L "$(dir $(shell $(PATH_MODERNCC) -mthumb -print-file-name=libc.a))"
LIB := $(LIBPATH) -lc -lnosys -lgcc -L../../libagbsyscall -lagbsyscall
endif

ifeq ($(TESTELF),$(MAKECMDGOALS))
  TEST := 1
endif

ifeq ($(TEST),1)
OBJ_DIR := $(TEST_OBJ_DIR_NAME)
endif

CPPFLAGS := -iquote include -iquote $(GFLIB_SUBDIR) -Wno-trigraphs -DMODERN=$(MODERN) -DTESTING=$(TEST)
ifneq ($(MODERN),1)
CPPFLAGS += -I tools/agbcc/include -I tools/agbcc -nostdinc -undef
endif

SHA1 := $(shell { command -v sha1sum || command -v shasum; } 2>/dev/null) -c
GFX := tools/gbagfx/gbagfx$(EXE)
AIF := tools/aif2pcm/aif2pcm$(EXE)
MID := tools/mid2agb/mid2agb$(EXE)
SCANINC := tools/scaninc/scaninc$(EXE)
PREPROC := tools/preproc/preproc$(EXE)
RAMSCRGEN := tools/ramscrgen/ramscrgen$(EXE)
FIX := tools/gbafix/gbafix$(EXE)
MAPJSON := tools/mapjson/mapjson$(EXE)
JSONPROC := tools/jsonproc/jsonproc$(EXE)
PATCHELF := tools/patchelf/patchelf$(EXE)
ROMTEST ?= $(shell { command -v mgba-rom-test || command -v tools/mgba/mgba-rom-test$(EXE); } 2>/dev/null)
ROMTESTHYDRA := tools/mgba-rom-test-hydra/mgba-rom-test-hydra$(EXE)
TRAINERPROC := tools/trainerproc/trainerproc$(EXE)

PERL := perl

# Inclusive list. If you don't want a tool to be built, don't add it here.
TOOLDIRS := tools/aif2pcm tools/bin2c tools/gbafix tools/gbagfx tools/jsonproc tools/mapjson tools/mid2agb tools/preproc tools/ramscrgen tools/rsfont tools/scaninc tools/trainerproc
CHECKTOOLDIRS = tools/patchelf tools/mgba-rom-test-hydra
TOOLBASE = $(TOOLDIRS:tools/%=%)
TOOLS = $(foreach tool,$(TOOLBASE),tools/$(tool)/$(tool)$(EXE))
>>>>>>> 889a02d263ddef7383666aa2d5df26ef159e64f0

MAKEFLAGS += --no-print-directory

# Clear the default suffixes
.SUFFIXES:
# Don't delete intermediate files
.SECONDARY:
# Delete files that weren't built properly
.DELETE_ON_ERROR:

<<<<<<< HEAD
RULES_NO_SCAN += libagbsyscall clean clean-assets tidy tidymodern tidynonmodern generated clean-generated
.PHONY: all rom modern compare
.PHONY: $(RULES_NO_SCAN)

infoshell = $(foreach line, $(shell $1 | sed "s/ /__SPACE__/g"), $(info $(subst __SPACE__, ,$(line))))

# Check if we need to scan dependencies based on the chosen rule OR user preference
NODEP ?= 0
# Check if we need to pre-build tools and generate assets based on the chosen rule.
SETUP_PREREQS ?= 1
# Disable dependency scanning for rules that don't need it.
ifneq (,$(MAKECMDGOALS))
  ifeq (,$(filter-out $(RULES_NO_SCAN),$(MAKECMDGOALS)))
    NODEP := 1
    SETUP_PREREQS := 0
=======
# Secondary expansion is required for dependency variables in object rules.
.SECONDEXPANSION:

.PHONY: all rom clean compare tidy tools check-tools mostlyclean clean-tools clean-check-tools $(TOOLDIRS) $(CHECKTOOLDIRS) libagbsyscall agbcc modern tidymodern tidynonmodern check history

infoshell = $(foreach line, $(shell $1 | sed "s/ /__SPACE__/g"), $(info $(subst __SPACE__, ,$(line))))

# Build tools when building the rom
# Disable dependency scanning for clean/tidy/tools
# Use a separate minimal makefile for speed
# Since we don't need to reload most of this makefile
ifeq (,$(filter-out all rom compare agbcc modern check libagbsyscall syms $(TESTELF),$(MAKECMDGOALS)))
$(call infoshell, $(MAKE) -f make_tools.mk)
else
NODEP ?= 1
endif

# check if we need to scan dependencies based on the rule
ifeq (,$(MAKECMDGOALS))
  SCAN_DEPS ?= 1
else
  # clean, tidy, tools, check-tools, mostlyclean, clean-tools, clean-check-tools, $(TOOLDIRS), $(CHECKTOOLDIRS), tidymodern, tidynonmodern, tidycheck don't even build the ROM
  # libagbsyscall does its own thing
  ifeq (,$(filter-out clean tidy tools mostlyclean clean-tools $(TOOLDIRS) clean-check-tools $(CHECKTOOLDIRS) tidymodern tidynonmodern tidycheck libagbsyscall,$(MAKECMDGOALS)))
    SCAN_DEPS ?= 0
  else
    SCAN_DEPS ?= 1
>>>>>>> 889a02d263ddef7383666aa2d5df26ef159e64f0
  endif
endif

ifeq ($(SETUP_PREREQS),1)
  # If set on: Default target or a rule requiring a scan
  # Forcibly execute `make tools` since we need them for what we are doing.
  $(call infoshell, $(MAKE) -f make_tools.mk)
  # Oh and also generate mapjson sources before we use `SCANINC`.
  $(call infoshell, $(MAKE) generated)
endif

# Collect sources
C_SRCS_IN := $(wildcard $(C_SUBDIR)/*.c $(C_SUBDIR)/*/*.c $(C_SUBDIR)/*/*/*.c)
C_SRCS := $(foreach src,$(C_SRCS_IN),$(if $(findstring .inc.c,$(src)),,$(src)))
C_OBJS := $(patsubst $(C_SUBDIR)/%.c,$(C_BUILDDIR)/%.o,$(C_SRCS))

<<<<<<< HEAD
C_ASM_SRCS := $(wildcard $(C_SUBDIR)/*.s $(C_SUBDIR)/*/*.s $(C_SUBDIR)/*/*/*.s)
=======
TEST_SRCS_IN := $(wildcard $(TEST_SUBDIR)/*.c $(TEST_SUBDIR)/*/*.c $(TEST_SUBDIR)/*/*/*.c)
TEST_SRCS := $(foreach src,$(TEST_SRCS_IN),$(if $(findstring .inc.c,$(src)),,$(src)))
TEST_OBJS := $(patsubst $(TEST_SUBDIR)/%.c,$(TEST_BUILDDIR)/%.o,$(TEST_SRCS))
TEST_OBJS_REL := $(patsubst $(OBJ_DIR)/%,%,$(TEST_OBJS))

GFLIB_SRCS := $(wildcard $(GFLIB_SUBDIR)/*.c)
GFLIB_OBJS := $(patsubst $(GFLIB_SUBDIR)/%.c,$(GFLIB_BUILDDIR)/%.o,$(GFLIB_SRCS))

C_ASM_SRCS += $(wildcard $(C_SUBDIR)/*.s $(C_SUBDIR)/*/*.s $(C_SUBDIR)/*/*/*.s)
>>>>>>> 889a02d263ddef7383666aa2d5df26ef159e64f0
C_ASM_OBJS := $(patsubst $(C_SUBDIR)/%.s,$(C_BUILDDIR)/%.o,$(C_ASM_SRCS))

ASM_SRCS := $(wildcard $(ASM_SUBDIR)/*.s)
ASM_OBJS := $(patsubst $(ASM_SUBDIR)/%.s,$(ASM_BUILDDIR)/%.o,$(ASM_SRCS))

# get all the data/*.s files EXCEPT the ones with specific rules
REGULAR_DATA_ASM_SRCS := $(filter-out $(DATA_ASM_SUBDIR)/maps.s $(DATA_ASM_SUBDIR)/map_events.s, $(wildcard $(DATA_ASM_SUBDIR)/*.s))

DATA_ASM_SRCS := $(wildcard $(DATA_ASM_SUBDIR)/*.s)
DATA_ASM_OBJS := $(patsubst $(DATA_ASM_SUBDIR)/%.s,$(DATA_ASM_BUILDDIR)/%.o,$(DATA_ASM_SRCS))

SONG_SRCS := $(wildcard $(SONG_SUBDIR)/*.s)
SONG_OBJS := $(patsubst $(SONG_SUBDIR)/%.s,$(SONG_BUILDDIR)/%.o,$(SONG_SRCS))

MID_SRCS := $(wildcard $(MID_SUBDIR)/*.mid)
MID_OBJS := $(patsubst $(MID_SUBDIR)/%.mid,$(MID_BUILDDIR)/%.o,$(MID_SRCS))

OBJS     := $(C_OBJS) $(C_ASM_OBJS) $(ASM_OBJS) $(DATA_ASM_OBJS) $(SONG_OBJS) $(MID_OBJS)
OBJS_REL := $(patsubst $(OBJ_DIR)/%,%,$(OBJS))

SUBDIRS  := $(sort $(dir $(OBJS) $(dir $(TEST_OBJS))))
$(shell mkdir -p $(SUBDIRS))

<<<<<<< HEAD
# Pretend rules that are actually flags defer to `make all`
modern: all
compare: all

# Other rules
=======
AUTO_GEN_TARGETS :=

all: history rom

history:
	@bash ./check_history.sh

tools: $(TOOLDIRS)

check-tools: $(CHECKTOOLDIRS)

syms: $(SYM)

$(TOOLDIRS):
	@$(MAKE) -C $@

$(CHECKTOOLDIRS):
	@$(MAKE) -C $@

>>>>>>> 889a02d263ddef7383666aa2d5df26ef159e64f0
rom: $(ROM)
ifeq ($(COMPARE),1)
	@$(SHA1) rom.sha1
endif

syms: $(SYM)

<<<<<<< HEAD
clean: tidy clean-tools clean-generated clean-assets
	@$(MAKE) clean -C libagbsyscall

clean-assets:
=======
clean: mostlyclean clean-tools clean-check-tools

clean-tools:
	@$(foreach tooldir,$(TOOLDIRS),$(MAKE) clean -C $(tooldir);)

clean-check-tools:
	@$(foreach tooldir,$(CHECKTOOLDIRS),$(MAKE) clean -C $(tooldir);)

mostlyclean: tidynonmodern tidymodern tidycheck
	find sound -iname '*.bin' -exec rm {} +
>>>>>>> 889a02d263ddef7383666aa2d5df26ef159e64f0
	rm -f $(MID_SUBDIR)/*.s
	rm -f $(DATA_ASM_SUBDIR)/layouts/layouts.inc $(DATA_ASM_SUBDIR)/layouts/layouts_table.inc
<<<<<<< HEAD
	rm -f $(DATA_ASM_SUBDIR)/maps/connections.inc $(DATA_ASM_SUBDIR)/maps/events.inc $(DATA_ASM_SUBDIR)/maps/groups.inc $(DATA_ASM_SUBDIR)/maps/headers.inc
	find sound -iname '*.bin' -exec rm {} +
	find . \( -iname '*.1bpp' -o -iname '*.4bpp' -o -iname '*.8bpp' -o -iname '*.gbapal' -o -iname '*.lz' -o -iname '*.rl' -o -iname '*.latfont' -o -iname '*.hwjpnfont' -o -iname '*.fwjpnfont' \) -exec rm {} +
=======
	rm -f $(DATA_ASM_SUBDIR)/maps/connections.inc $(DATA_ASM_SUBDIR)/maps/events.inc $(DATA_ASM_SUBDIR)/maps/groups.inc $(DATA_ASM_SUBDIR)/maps/headers.inc $(DATA_SRC_SUBDIR)/map_group_count.h
>>>>>>> 889a02d263ddef7383666aa2d5df26ef159e64f0
	find $(DATA_ASM_SUBDIR)/maps \( -iname 'connections.inc' -o -iname 'events.inc' -o -iname 'header.inc' \) -exec rm {} +

tidy: tidynonmodern tidymodern tidycheck

tidynonmodern:
	rm -f $(ROM_NAME) $(ELF_NAME) $(MAP_NAME)
	rm -rf $(OBJ_DIR_NAME)

tidymodern:
	rm -f $(MODERN_ROM_NAME) $(MODERN_ELF_NAME) $(MODERN_MAP_NAME)
	rm -rf $(MODERN_OBJ_DIR_NAME)

<<<<<<< HEAD
# Other rules
=======
tidycheck:
	rm -f $(TESTELF) $(HEADLESSELF)
	rm -rf $(TEST_OBJ_DIR_NAME_MODERN)
	rm -rf $(TEST_OBJ_DIR_NAME_AGBCC)


ifneq ($(MODERN),0)
$(C_BUILDDIR)/berry_crush.o: override CFLAGS += -Wno-address-of-packed-member
endif

>>>>>>> 889a02d263ddef7383666aa2d5df26ef159e64f0
include graphics_file_rules.mk
include map_data_rules.mk
include spritesheet_rules.mk
include json_data_rules.mk
include audio_rules.mk

generated: $(AUTO_GEN_TARGETS)

%.s:   ;
%.png: ;
%.pal: ;
%.aif: ;

<<<<<<< HEAD
%.1bpp:   %.png  ; $(GFX) $< $@
%.4bpp:   %.png  ; $(GFX) $< $@
%.8bpp:   %.png  ; $(GFX) $< $@
%.gbapal: %.pal  ; $(GFX) $< $@
%.gbapal: %.png  ; $(GFX) $< $@
%.lz:     %      ; $(GFX) $< $@
%.rl:     %      ; $(GFX) $< $@

# NOTE: Tools must have been built prior (FIXME)
generated: tools $(AUTO_GEN_TARGETS)
clean-generated:
	-rm -f $(AUTO_GEN_TARGETS)
=======
%.1bpp: %.png  ; $(GFX) $< $@
%.4bpp: %.png  ; $(GFX) $< $@
%.8bpp: %.png  ; $(GFX) $< $@
%.gbapal: %.pal ; $(GFX) $< $@
%.gbapal: %.png ; $(GFX) $< $@
%.lz: % ; $(GFX) $< $@
%.rl: % ; $(GFX) $< $@

$(CRY_SUBDIR)/uncomp_%.bin: $(CRY_SUBDIR)/uncomp_%.aif ; $(AIF) $< $@
$(CRY_SUBDIR)/%.bin: $(CRY_SUBDIR)/%.aif ; $(AIF) $< $@ --compress
sound/%.bin: sound/%.aif ; $(AIF) $< $@

COMPETITIVE_PARTY_SYNTAX := $(shell PATH="$(PATH)"; echo 'COMPETITIVE_PARTY_SYNTAX' | $(CPP) $(CPPFLAGS) -imacros include/global.h | tail -n1)
ifeq ($(COMPETITIVE_PARTY_SYNTAX),1)
%.h: %.party tools ; $(CPP) $(CPPFLAGS) -traditional-cpp - < $< | $(TRAINERPROC) -o $@ -i $< -
endif
>>>>>>> 889a02d263ddef7383666aa2d5df26ef159e64f0

ifeq ($(MODERN),0)
$(C_BUILDDIR)/libc.o: CC1 := $(TOOLS_DIR)/agbcc/bin/old_agbcc$(EXE)
$(C_BUILDDIR)/libc.o: CFLAGS := -O2
$(C_BUILDDIR)/siirtc.o: CFLAGS := -mthumb-interwork
$(C_BUILDDIR)/agb_flash.o: CFLAGS := -O -mthumb-interwork
$(C_BUILDDIR)/agb_flash_1m.o: CFLAGS := -O -mthumb-interwork
$(C_BUILDDIR)/agb_flash_mx.o: CFLAGS := -O -mthumb-interwork
$(C_BUILDDIR)/m4a.o: CC1 := tools/agbcc/bin/old_agbcc$(EXE)
$(C_BUILDDIR)/record_mixing.o: CFLAGS += -ffreestanding
$(C_BUILDDIR)/librfu_intr.o: CC1 := $(TOOLS_DIR)/agbcc/bin/agbcc_arm$(EXE)
$(C_BUILDDIR)/librfu_intr.o: CFLAGS := -O2 -mthumb-interwork -quiet
else
$(C_BUILDDIR)/librfu_intr.o: CFLAGS := -mthumb-interwork -O2 -mabi=apcs-gnu -mtune=arm7tdmi -march=armv4t -fno-toplevel-reorder -Wno-pointer-to-int-cast
<<<<<<< HEAD
$(C_BUILDDIR)/berry_crush.o: override CFLAGS += -Wno-address-of-packed-member
=======
$(C_BUILDDIR)/pokedex_plus_hgss.o: CFLAGS := -mthumb -mthumb-interwork -O2 -mabi=apcs-gnu -mtune=arm7tdmi -march=armv4t -Wno-pointer-to-int-cast -std=gnu17 -Werror -Wall -Wno-strict-aliasing -Wno-attribute-alias -Woverride-init
# Annoyingly we can't turn this on just for src/data/trainers.h
$(C_BUILDDIR)/data.o: CFLAGS += -fno-show-column -fno-diagnostics-show-caret
>>>>>>> 889a02d263ddef7383666aa2d5df26ef159e64f0
endif

# Dependency rules (for the *.c & *.s sources to .o files)
# Have to be explicit or else missing files won't be reported.

# As a side effect, they're evaluated immediately instead of when the rule is invoked.
# It doesn't look like $(shell) can be deferred so there might not be a better way (Icedude_907: there is soon).

# For C dependencies.
# Args: $1 = Output file without extension (build/assets/src/data), $2 = Input file (src/data.c)
define C_DEP
$(call C_DEP_IMPL,$1,$2,$1)
endef
# Internal implementation details.
# $1: Output file without extension, $2 input file, $3 temp path (if keeping)
define C_DEP_IMPL
$1.o: $2
ifneq ($(KEEP_TEMPS),1)
	@echo "$$(CC1) <flags> -o $$@ $$<"
	@$$(CPP) $$(CPPFLAGS) $$< | $$(PREPROC) -i $$< charmap.txt | $$(CC1) $$(CFLAGS) -o - - | cat - <(echo -e ".text\n\t.align\t2, 0") | $$(AS) $$(ASFLAGS) -o $$@ -
else
	@$$(CPP) $$(CPPFLAGS) $$< -o $3.i
	@$$(PREPROC) $3.i charmap.txt | $$(CC1) $$(CFLAGS) -o $3.s
	@echo -e ".text\n\t.align\t2, 0\n" >> $3.s
	$$(AS) $$(ASFLAGS) -o $$@ $3.s
endif
$1.d: $2
	$(SCANINC) -M $1.d $(INCLUDE_SCANINC_ARGS) -I tools/agbcc/include $2
ifneq ($(NODEP),1)
$1.o: $1.d
-include $1.d
endif
endef

# Create generic rules if no dependency scanning, else create the real rules
ifeq ($(NODEP),1)
$(eval $(call C_DEP,$(C_BUILDDIR)/%,$(C_SUBDIR)/%.c))
else
$(foreach src,$(C_SRCS),$(eval $(call C_DEP,$(OBJ_DIR)/$(basename $(src)),$(src))))
endif

# Similar methodology for Assembly files
# $1: Output path without extension, $2: Input file (`*.s`)
define ASM_DEP
$1.o: $2
	$$(AS) $$(ASFLAGS) -o $$@ $$<
$(call ASM_SCANINC,$1,$2)
endef
# As above but first doing a preprocessor pass
define ASM_DEP_PREPROC
$1.o: $2
	$$(PREPROC) $$< charmap.txt | $$(CPP) $(INCLUDE_SCANINC_ARGS) - | $$(PREPROC) -ie $$< charmap.txt | $$(AS) $$(ASFLAGS) -o $$@
$(call ASM_SCANINC,$1,$2)
endef

define ASM_SCANINC
ifneq ($(NODEP),1)
$1.o: $1.d
$1.d: $2
	$(SCANINC) -M $1.d $(INCLUDE_SCANINC_ARGS) -I "" $2
-include $1.d
endif
endef

# Dummy rules or real rules
ifeq ($(NODEP),1)
$(eval $(call ASM_DEP,$(ASM_BUILDDIR)/%,$(ASM_SUBDIR)/%.s))
$(eval $(call ASM_DEP_PREPROC,$(C_BUILDDIR)/%,$(C_SUBDIR)/%.s))
$(eval $(call ASM_DEP_PREPROC,$(DATA_ASM_BUILDDIR)/%,$(DATA_ASM_SUBDIR)/%.s))
else
$(foreach src, $(ASM_SRCS), $(eval $(call ASM_DEP,$(src:%.s=$(OBJ_DIR)/%),$(src))))
$(foreach src, $(C_ASM_SRCS), $(eval $(call ASM_DEP_PREPROC,$(src:%.s=$(OBJ_DIR)/%),$(src))))
$(foreach src, $(REGULAR_DATA_ASM_SRCS), $(eval $(call ASM_DEP_PREPROC,$(src:%.s=$(OBJ_DIR)/%),$(src))))
endif

$(OBJ_DIR)/sym_bss.ld: sym_bss.txt
	$(RAMSCRGEN) .bss $< ENGLISH > $@

$(OBJ_DIR)/sym_common.ld: sym_common.txt $(C_OBJS) $(wildcard common_syms/*.txt)
	$(RAMSCRGEN) COMMON $< ENGLISH -c $(C_BUILDDIR),common_syms > $@

$(OBJ_DIR)/sym_ewram.ld: sym_ewram.txt
	$(RAMSCRGEN) ewram_data $< ENGLISH > $@

<<<<<<< HEAD
# Linker script
=======
# NOTE: Depending on event_scripts.o is hacky, but we want to depend on everything event_scripts.s depends on without having to alter scaninc
$(DATA_SRC_SUBDIR)/pokemon/teachable_learnsets.h: $(DATA_ASM_BUILDDIR)/event_scripts.o
	python3 tools/learnset_helpers/teachable.py

# NOTE: Based on C_DEP above, but without NODEP and KEEP_TEMPS handling.
define TEST_DEP
$1: $2 $$(shell $(SCANINC) -I include -I tools/agbcc/include -I gflib $2)
	@echo "$$(CC1) <flags> -o $$@ $$<"
	@$$(CPP) $$(CPPFLAGS) $$< | $$(PREPROC) -i $$< charmap.txt | $$(CC1) $$(CFLAGS) -o - - | cat - <(echo -e ".text\n\t.align\t2, 0") | $$(AS) $$(ASFLAGS) -o $$@ -
endef
$(foreach src, $(TEST_SRCS), $(eval $(call TEST_DEP,$(patsubst $(TEST_SUBDIR)/%.c,$(TEST_BUILDDIR)/%.o,$(src)),$(src),$(patsubst $(TEST_SUBDIR)/%.c,%,$(src)))))

>>>>>>> 889a02d263ddef7383666aa2d5df26ef159e64f0
ifeq ($(MODERN),0)
LD_SCRIPT := ld_script.ld
LD_SCRIPT_DEPS := $(OBJ_DIR)/sym_bss.ld $(OBJ_DIR)/sym_common.ld $(OBJ_DIR)/sym_ewram.ld
else
LD_SCRIPT := ld_script_modern.ld
LD_SCRIPT_DEPS :=
endif

<<<<<<< HEAD
# Final rules
=======
$(OBJ_DIR)/ld_script.ld: $(LD_SCRIPT) $(LD_SCRIPT_DEPS)
	cd $(OBJ_DIR) && sed "s#tools/#../../tools/#g" ../../$(LD_SCRIPT) > ld_script.ld

LDFLAGS = -Map ../../$(MAP)
$(ELF): $(OBJ_DIR)/ld_script.ld $(OBJS) libagbsyscall
	@echo "cd $(OBJ_DIR) && $(LD) $(LDFLAGS) -T ld_script.ld -o ../../$@ <objects> <lib>"
	@cd $(OBJ_DIR) && $(LD) $(LDFLAGS) -T ld_script.ld --print-memory-usage -o ../../$@ $(OBJS_REL) $(LIB) | cat
	$(FIX) $@ -t"$(TITLE)" -c$(GAME_CODE) -m$(MAKER_CODE) -r$(REVISION) --silent

$(ROM): $(ELF)
	$(OBJCOPY) -O binary $< $@
	$(FIX) $@ -p --silent

# Uncomment the next line, and then comment the 4 lines after it to reenable agbcc.
#agbcc: all
agbcc:
	@echo "'make agbcc' is deprecated as of pokeemerald-expansion 1.9 and will be removed in 1.10."
	@echo "Search for 'agbcc: all' in Makefile to reenable agbcc."
	@exit 1

modern: all
>>>>>>> 889a02d263ddef7383666aa2d5df26ef159e64f0

LD_SCRIPT_TEST := ld_script_test.ld

$(OBJ_DIR)/ld_script_test.ld: $(LD_SCRIPT_TEST) $(LD_SCRIPT_DEPS)
	cd $(OBJ_DIR) && sed "s#tools/#../../tools/#g" ../../$(LD_SCRIPT_TEST) > ld_script_test.ld

$(TESTELF): $(OBJ_DIR)/ld_script_test.ld $(OBJS) $(TEST_OBJS) libagbsyscall tools check-tools
	@echo "cd $(OBJ_DIR) && $(LD) -T ld_script_test.ld -o ../../$@ <objects> <test-objects> <lib>"
	@cd $(OBJ_DIR) && $(LD) $(TESTLDFLAGS) -T ld_script_test.ld -o ../../$@ $(OBJS_REL) $(TEST_OBJS_REL) $(LIB)
	$(FIX) $@ -t"$(TITLE)" -c$(GAME_CODE) -m$(MAKER_CODE) -r$(REVISION) -d0 --silent
	$(PATCHELF) $(TESTELF) gTestRunnerArgv "$(TESTS)\0"

ifeq ($(GITHUB_REPOSITORY_OWNER),rh-hideout)
TEST_SKIP_IS_FAIL := \x01
else
TEST_SKIP_IS_FAIL := \x00
endif

check: $(TESTELF)
	@cp $< $(HEADLESSELF)
	$(PATCHELF) $(HEADLESSELF) gTestRunnerHeadless '\x01' gTestRunnerSkipIsFail "$(TEST_SKIP_IS_FAIL)"
	$(ROMTESTHYDRA) $(ROMTEST) $(OBJCOPY) $(HEADLESSELF)

libagbsyscall:
	@$(MAKE) -C libagbsyscall TOOLCHAIN=$(TOOLCHAIN) MODERN=$(MODERN)

# Elf from object files
$(ELF): $(LD_SCRIPT) $(LD_SCRIPT_DEPS) $(OBJS) libagbsyscall
	@cd $(OBJ_DIR) && $(LD) $(LDFLAGS) -T ../../$< --print-memory-usage -o ../../$@ $(OBJS_REL) $(LIB) | cat
	$(FIX) $@ -t"$(TITLE)" -c$(GAME_CODE) -m$(MAKER_CODE) -r$(REVISION) --silent

# Builds the rom from the elf file
$(ROM): $(ELF)
	$(OBJCOPY) -O binary $< $@
	$(FIX) $@ -p --silent

# Symbol file (`make syms`)
$(SYM): $(ELF)
	$(OBJDUMP) -t $< | sort -u | grep -E "^0[2389]" | $(PERL) -p -e 's/^(\w{8}) (\w).{6} \S+\t(\w{8}) (\S+)$$/\1 \2 \3 \4/g' > $@
