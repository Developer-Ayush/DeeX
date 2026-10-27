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

# 2. Check required top-level files and Chunk 1 to 4 deliverables
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
build/manifests/aosp-pinned.xml
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
docs/build-records/baseline-build-procedure.md
docs/build-records/vendor-binaries-procedure.md
docs/build-records/two-build-comparison-procedure.md
docs/build-records/troubleshooting.md
docs/build-records/results-intake-template.md
docs/build-records/measurements.md
tools/baseline-sync.sh
tools/baseline-build.sh
tools/make-build-record.sh
tools/compare-builds.sh
tools/verify-vendor-binaries.sh
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

# 5. Check script hygiene rules (no sudo, no hardcoded absolute paths outside WORK_DIR, no dangerous rm -rf)
for script in tools/*.sh; do
    if [ -f "$script" ] && [ "$script" != "tools/check-repo-structure.sh" ]; then
        if grep -q '\bsudo\b' "$script"; then
            log_error "Script $script contains prohibited 'sudo' command."
        else
            log_info "Script $script free of 'sudo'."
        fi

        if grep -q 'rm -rf \$[a-zA-Z0-9_]*' "$script" | grep -v '"\$'; then
            log_error "Script $script contains unquoted rm -rf variable."
        else
            log_info "Script $script free of unquoted rm -rf variables."
        fi

        if grep -Eq '(/usr/|/var/|/opt/|/etc/|/tmp/)' "$script"; then
            log_error "Script $script contains hard-coded system absolute path outside WORK_DIR."
        else
            log_info "Script $script free of hard-coded system absolute paths."
        fi
    fi
done

if [ $ERRORS -gt 0 ]; then
    echo "Repository structure verification failed with $ERRORS error(s)."
    exit 1
else
    echo "Repository structure verification succeeded. All checks passed."
    exit 0
fi
