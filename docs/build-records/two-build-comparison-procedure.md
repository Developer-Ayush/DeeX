Status: Draft
Date: 2025-05-16
Master Plan Sections: 2.4, 16.2, 17.7

# Two-Build Comparison and Reproducibility Procedure

## 1. Overview & Policy

Per Master Plan Section 2.4 and `docs/specifications/reproducibility-policy.md`, changes and builds must be reviewable and reproducible.

**Untested Procedure Notice:**
This comparison procedure is defined theoretically and is **untested** until the project owner executes two independent clean builds on their build host(s) and evaluates the comparison output.

**Fundamental Rule of Reproducibility Claims:**
- **No build or image shall be called "reproducible" until a documented comparison procedure shows identical binary cryptographic digests for all in-scope output artifacts.**

---

## 2. Requirements for the Two Comparison Builds

To perform a valid two-build comparison, the owner must complete two separate build runs (Build A and Build B):

1. **Identical Inputs**:
   - Exact same pinned AOSP manifest (`build/manifests/aosp-pinned.xml` tag `android-15.0.0_r1`).
   - Exact same DeeX repository commit hash.
   - Exact same vendor binary driver packages (`AP3A.240905.015.A2`).
   - Exact same build configuration (`build/configs/development.md`).
   - Exact same container image digest (from `build/env/Dockerfile`).

2. **Clean Environment Execution**:
   - **Build A**: Executed in clean work directory `WORK_DIR_A` (`/path/to/work_a`).
   - **Build B**: Executed in clean work directory `WORK_DIR_B` (`/path/to/work_b`) on either the same build host or a secondary comparison build host.

---

## 3. Comparison Execution Steps

1. Run Build A following `docs/build-records/baseline-build-procedure.md` and generate build record `build-record-A.md`.
2. Run Build B in a completely clean directory/environment and generate build record `build-record-B.md`.
3. Execute the comparison tool from the DeeX repository root:
   ```sh
   sh tools/compare-builds.sh --dir-a "$WORK_DIR_A/out/target/product/shiba" --dir-b "$WORK_DIR_B/out/target/product/shiba"
   ```

---

## 4. Evaluation & Difference Recording

The `tools/compare-builds.sh` script evaluates output image files (such as `boot.img`, `system.img`, `vendor.img`, `product.img`, `system_ext.img`, `vbmeta.img`, `super.img`) and prints a comparative report detailing:
- **Identical Artifacts**: Output files matching exact SHA-256 digests.
- **Differing Artifacts**: Output files with divergent SHA-256 digests.
- **Missing / Extra Artifacts**: Output files present in only one build directory.

If any differing files are found, `tools/compare-builds.sh` exits with a non-zero exit code.

### Required Handling of Differences:
- The owner must **never** hide or ignore differences.
- Common upstream sources of non-reproducibility in default AOSP builds include: embedded UTC build timestamps, dynamic build numbers, zip file entry timestamps, and host build path variations.
- Every difference must be recorded in the build comparison notes section of the results intake form.
- The build report must explicitly list whether Build A and Build B achieved 100% bit-for-bit reproducibility or document the specific non-deterministic files identified for future toolchain deterministic hardening.
