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
device/target-device/candidates
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
build/manifests
build/env
build/configs
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

# 2. Check required top-level files and Chunk 1, 2, 3 deliverables
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
docs/decisions/device-selection-criteria.md
docs/decisions/device-candidates.md
docs/decisions/device-gap-analysis.md
docs/decisions/ADR-0002-target-device.md
docs/decisions/ADR-0003-aosp-release.md
device/target-device/hardware-facts-worksheet.md
build/templates/build-record.md
build/templates/source-manifest.md
build/templates/third-party-dependency-record.md
build/templates/release-manifest.md
build/manifests/README.md
build/manifests/deex-local-manifest.xml
build/manifests/pin-log.md
build/manifests/CHANGES.md
build/env/README.md
build/env/Dockerfile
build/env/packages.lock.md
build/env/host-requirements.md
build/configs/README.md
build/configs/development.md
build/configs/testing.md
build/configs/release.md
docs/specifications/key-and-signing-policy.md
docs/specifications/reproducibility-policy.md
docs/build-records/licence-and-dependency-inventory.md
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

# Check pinned manifest or template existence
if [ -f "build/manifests/aosp-pinned.xml" ] || [ -f "build/manifests/aosp-pinned.xml.template" ]; then
    log_info "AOSP manifest (pinned or template) present"
else
    log_error "Neither aosp-pinned.xml nor aosp-pinned.xml.template present in build/manifests/"
fi

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

# 4. Check for prohibited signing key or certificate files in repo
KEY_FILES=$(find . -path ./.git -prune -o \( -name "*.key" -o -name "*.pem" -o -name "*.keystore" -o -name "*.pk8" \) -print || true)
if [ -n "$KEY_FILES" ]; then
    log_error "Found prohibited cryptographic key/certificate file(s) in repository: $KEY_FILES"
else
    log_info "No cryptographic key or certificate files found in repository"
fi

# 5. Check ADR-0002 status
ADR2_FILE="docs/decisions/ADR-0002-target-device.md"
if [ -f "$ADR2_FILE" ]; then
    if grep -q "ACCEPTED" "$ADR2_FILE" || grep -q "UNDECIDED" "$ADR2_FILE"; then
        log_info "ADR-0002 status verified (ACCEPTED or UNDECIDED)"
    else
        log_error "ADR-0002 does not contain required status string 'ACCEPTED' or 'UNDECIDED'"
    fi
else
    log_error "Missing ADR-0002 file"
fi

# 6. Check ADR-0003 status
ADR3_FILE="docs/decisions/ADR-0003-aosp-release.md"
if [ -f "$ADR3_FILE" ]; then
    if grep -q "UNDECIDED" "$ADR3_FILE" || grep -q "Confirmed AOSP Release:" "$ADR3_FILE"; then
        log_info "ADR-0003 status verified (contains UNDECIDED or confirmed release decision)"
    else
        log_error "ADR-0003 does not contain required status string 'UNDECIDED' or owner confirmation block"
    fi
else
    log_error "Missing ADR-0003 file"
fi

if [ $ERRORS -gt 0 ]; then
    echo "Repository structure verification failed with $ERRORS error(s)."
    exit 1
else
    echo "Repository structure verification succeeded. All checks passed."
    exit 0
fi
