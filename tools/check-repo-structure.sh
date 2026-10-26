#!/bin/sh
# POSIX shell script to verify DeeX repository structure and hygiene rules

set -e

ERRORS=0

log_error() {
    echo "[ERROR] $1"
    ERRORS=$((ERRORS + 1))
}

log_info() {
    echo "[OK] $1"
}

# 1. Check required directories and their README.md files
REQUIRED_DIRS="
docs
docs/architecture
docs/specifications
docs/threat-model
docs/testing
docs/decisions
docs/build-records
device/target-device
vendor/target-device
packages/apps
system/deex
system/deex/identity
system/deex/vault
system/deex/isolation
system/deex/bridge
system/deex/connectivity
system/deex/policy
tests
build
build/templates
release
tools
"

for dir in $REQUIRED_DIRS; do
    if [ ! -d "$dir" ]; then
        log_error "Missing directory: $dir"
    elif [ ! -f "$dir/README.md" ]; then
        log_error "Missing README.md in directory: $dir"
    else
        log_info "Directory and README present: $dir"
    fi
done

# 2. Check required top-level files
REQUIRED_FILES="
README.md
AGENTS.md
CONTRIBUTING.md
SECURITY.md
LICENSE-NOTES.md
.gitignore
.gitattributes
.editorconfig
docs/architecture/00-overview.md
docs/architecture/module-template.md
docs/specifications/requirements-index.md
docs/threat-model/README.md
docs/testing/README.md
docs/testing/test-record-template.md
docs/decisions/README.md
docs/decisions/ADR-template.md
docs/decisions/open-decisions.md
docs/decisions/ADR-0001-chunked-development.md
build/templates/build-record.md
build/templates/source-manifest.md
build/templates/third-party-dependency-record.md
build/templates/release-manifest.md
docs/build-records/CHANGELOG-chunks.md
docs/build-records/build-configurations.md
"

for file in $REQUIRED_FILES; do
    if [ ! -f "$file" ]; then
        log_error "Missing required file: $file"
    else
        log_info "Required file present: $file"
    fi
done

# 3. Check .gitignore rules
GITIGNORE=".gitignore"
if [ -f "$GITIGNORE" ]; then
    for rule in "\*.key" "\*.pem" "\*.keystore" "out/" "\.repo/"; do
        # Strip backslashes for grep matching
        search_pattern=$(echo "$rule" | sed 's/\\//g')
        if grep -q "$search_pattern" "$GITIGNORE"; then
            log_info ".gitignore contains pattern: $search_pattern"
        else
            log_error ".gitignore missing pattern: $search_pattern"
        fi
    done
else
    log_error ".gitignore file missing"
fi

if [ $ERRORS -gt 0 ]; then
    echo "Repository structure verification failed with $ERRORS error(s)."
    exit 1
else
    echo "Repository structure verification succeeded. All checks passed."
    exit 0
fi
