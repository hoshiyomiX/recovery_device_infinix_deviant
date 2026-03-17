#!/bin/bash
# ============================================
# ORANGEFOX PRE-BUILD HOOK
# ============================================
# This script runs BEFORE building to patch OrangeFox source
# Target: Reduce boot.img size to fit 32MB partition
# Reference: https://gitlab.com/OrangeFox
# ============================================
# Usage: source pre_build_hook.sh <ORANGEFOX_SOURCE_PATH>
# ============================================

set -e

# Check argument
if [ -z "$1" ]; then
    echo "ERROR: OrangeFox source path not provided"
    echo "Usage: source pre_build_hook.sh <ORANGEFOX_SOURCE_PATH>"
    exit 1
fi

FOX_SRC="$1"

echo "=============================================="
echo "ORANGEFOX PRE-BUILD HOOK"
echo "=============================================="
echo "OrangeFox Source: $FOX_SRC"
echo ""

# Verify OrangeFox source exists
if [ ! -d "$FOX_SRC" ]; then
    echo "ERROR: OrangeFox source directory not found: $FOX_SRC"
    exit 1
fi

# ============================================
# 1. REMOVE EXTRA COLOR THEMES (Save ~5 MB)
# Keep only Default color theme
# DO NOT remove layout themes (portrait_hdpi, etc.)
# ============================================
THEME_DIR="$FOX_SRC/bootable/recovery/gui/theme"

if [ -d "$THEME_DIR" ]; then
    echo "=== REMOVING EXTRA COLOR THEMES ==="
    echo "Theme directory: $THEME_DIR"
    echo "Before: $(du -sh "$THEME_DIR" 2>/dev/null | cut -f1)"

    # Keep layout themes (portrait_hdpi, landscape_hdpi, etc.) and common
    # Remove only COLOR THEMES inside each layout theme
    # Color themes: Default, Black, Light, etc.

    cd "$THEME_DIR"
    for layout_theme in */; do
        layout_name="${layout_theme%/}"
        if [ -d "$layout_name" ]; then
            echo "  Processing layout: $layout_name"
            cd "$layout_name"

            # Keep only Default color theme, remove others
            for color_theme in */; do
                color_name="${color_theme%/}"
                if [ "$color_name" != "Default" ] && [ "$color_name" != "common" ] && [ -d "$color_name" ]; then
                    echo "    Removing color theme: $color_name"
                    rm -rf "$color_name"
                fi
            done

            cd ..
        fi
    done
    cd - > /dev/null

    echo "After:  $(du -sh "$THEME_DIR" 2>/dev/null | cut -f1)"
    echo ""
fi

# ============================================
# 2. REMOVE EXTRA LANGUAGES (Save ~800 KB)
# ============================================
LANG_DIR="$FOX_SRC/bootable/recovery/gui/language"

if [ -d "$LANG_DIR" ]; then
    echo "=== REMOVING EXTRA LANGUAGES ==="
    echo "Language directory: $LANG_DIR"
    echo "Before: $(du -sh "$LANG_DIR" 2>/dev/null | cut -f1)"

    # Keep only English
    KEEP_LANG="en"

    cd "$LANG_DIR"
    for lang in */; do
        lang_name="${lang%/}"
        if [ "$lang_name" != "$KEEP_LANG" ]; then
            echo "  Removing language: $lang_name"
            rm -rf "$lang"
        fi
    done
    cd - > /dev/null

    echo "After:  $(du -sh "$LANG_DIR" 2>/dev/null | cut -f1)"
    echo ""
fi

# ============================================
# 3. REMOVE EXTRA FONTS (Save ~260 KB)
# ============================================
FONT_DIR="$FOX_SRC/bootable/recovery/gui/font"

if [ -d "$FONT_DIR" ]; then
    echo "=== REMOVING EXTRA FONTS ==="
    echo "Font directory: $FONT_DIR"
    echo "Before: $(du -sh "$FONT_DIR" 2>/dev/null | cut -f1)"

    # Keep only Roboto-Regular (used by default theme)
    KEEP_FONTS="Roboto-Regular"

    cd "$FONT_DIR"
    for font in *.ttf *.ttc *.otf; do
        if [ -f "$font" ]; then
            KEEP=false
            for keep in $KEEP_FONTS; do
                if [[ "$font" == *"$keep"* ]]; then
                    KEEP=true
                    break
                fi
            done

            if [ "$KEEP" = "false" ]; then
                echo "  Removing font: $font"
                rm -f "$font"
            fi
        fi
    done
    cd - > /dev/null

    echo "After:  $(du -sh "$FONT_DIR" 2>/dev/null | cut -f1)"
    echo ""
fi

# ============================================
# 4. REMOVE EXTRA TERMINFO (Save ~11 MB uncompressed, ~3.5 MB compressed)
# Keep only essential terminal definitions for recovery operation
# ============================================
TERMINFO_DIR="$FOX_SRC/system/etc/terminfo"

if [ -d "$TERMINFO_DIR" ]; then
    echo "=== REDUCING TERMINFO DATABASE ==="
    echo "Terminfo directory: $TERMINFO_DIR"
    echo "Before: $(du -sh "$TERMINFO_DIR" 2>/dev/null | cut -f1)"

    # Essential terminals for OrangeFox Recovery:
    # - linux: Linux console framebuffer (required for recovery UI)
    # - vt100, vt102, vt220, vt320: Basic terminal compatibility
    # - xterm, xterm-256color, xterm-color: ADB shell and external access
    # - screen, screen-256color: Screen multiplexer support
    # - ansi: ANSI terminal compatibility
    # - dumb: Minimal terminal fallback
    # - rxvt, rxvt-256color: Common terminal emulator
    KEEP_TERMINALS="linux vt100 vt102 vt220 vt320 xterm xterm-256color xterm-color screen screen-256color ansi dumb rxvt rxvt-256color"

    # Find and remove all terminals NOT in keep list
    find "$TERMINFO_DIR" -type f | while read -r termfile; do
        termname=$(basename "$termfile")
        KEEP=false

        for keep in $KEEP_TERMINALS; do
            if [ "$termname" = "$keep" ]; then
                KEEP=true
                break
            fi
        done

        if [ "$KEEP" = "false" ]; then
            rm -f "$termfile"
        fi
    done

    # Remove empty directories
    find "$TERMINFO_DIR" -type d -empty -delete 2>/dev/null || true

    echo "After:  $(du -sh "$TERMINFO_DIR" 2>/dev/null | cut -f1)"
    echo ""
    echo "Kept essential terminals: $KEEP_TERMINALS"
    echo ""
fi

# ============================================
# 5. REMOVE ICU LIBRARIES (Save ~4.4 MB)
# Optional: Uncomment if single language only
# ============================================
# ICU_DIR="$FOX_SRC/external/icu"
# if [ -d "$ICU_DIR" ]; then
#     echo "=== REMOVING ICU LIBRARIES ==="
#     echo "WARNING: This may break non-ASCII text display"
#     rm -rf "$ICU_DIR"
#     echo "ICU removed"
#     echo ""
# fi

# ============================================
# SUMMARY
# ============================================
echo "=============================================="
echo "PRE-BUILD HOOK COMPLETE"
echo "=============================================="
echo ""
echo "Size reduction applied to OrangeFox source:"
echo "  - Extra themes removed (keep only Default)"
echo "  - Extra languages removed (keep only English)"
echo "  - Extra fonts removed (keep only Roboto-Regular)"
echo "  - Extra terminfo removed (keep only essential terminals)"
echo ""
echo "Proceeding with build..."
