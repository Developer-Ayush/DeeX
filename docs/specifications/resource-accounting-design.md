# DeeX Kernel Resource Accounting and Policy Design

- **Status**: Draft
- **Date**: 2025-05-16
- **Owning Module**: DeeX Kernel
- **Master Plan Sections**: 4.3, 4.4, 7.5, 7.6, 14.5, 15.7, 17

---

## 1. System Overview & Core Objectives

The DeeX Kernel resource accounting subsystem provides continuous, system-wide measurement and policy enforcement for CPU, RAM, and IO utilization. The core objectives are:
1. Guarantee resource availability for essential system services and active foreground operations.
2. Prevent background ordinary accounts from consuming excessive CPU/RAM or starving critical OS tasks.
3. Provide resource-aware execution hooks for background storage sanitization in the Lifecycle module.
4. Strictly respect hardware and vendor firmware thermal limits without attempting to override thermal protections.

---

## 2. Resource Measurement & Kernel Facilities

Accounting relies strictly on standard Linux kernel mechanisms as documented in upstream AOSP and Linux kernel documentation [Primary Source: Linux Kernel Cgroup v2 Documentation, `https://www.kernel.org/doc/html/latest/admin-guide/cgroup-v2.html`, Access Date: 2025-05-16, Confidence: `VERIFIED`]:

### 2.1 Cgroups v2 Single Hierarchy
- **`cpu` controller**: Measures CPU usage in microseconds (`cpu.stat`) and enforces CPU weights (`cpu.weight`) and max bandwidth limits (`cpu.max`).
- **`memory` controller**: Tracks cgroup page usage (`memory.current`), swap usage, and page cache, enforcing memory limits (`memory.high`, `memory.max`) and pressure notifications (`memory.pressure`).
- **`io` controller**: Tracks block IO read/write bytes and IOPS (`io.stat`), enforcing weight-based disk bandwidth throttles (`io.weight`).

### 2.2 eBPF Resource Probes
- **Kernel eBPF Probes**: Kernel eBPF programs attached to cgroup socket and scheduler tracepoints gather real-time per-cgroup CPU, memory, and network metrics without kernel patch modifications [Primary Source: AOSP eBPF Architecture, `https://source.android.com/docs/core/architecture/kernel/bpf`, Access Date: 2025-05-16, Confidence: `VERIFIED`].

---

## 3. Separation of System vs. Account Processes

The resource accounting system distinguishes process categories via Linux cgroup v2 paths and Android process profiles:

```text
/sys/fs/cgroup/
├── system.slice/                <-- Essential System Processes
│   ├── init (PID 1)
│   ├── vold, keystore2, installd
│   ├── system_server, surfaceflinger
│   └── deex-system-services (Vault, Identity, Policy)
└── account.slice/               <-- Ordinary Account Processes
    ├── account_01/ (Foreground / Background apps for Account 1)
    ├── account_02/ (Background apps for Account 2)
    └── ...
```

### Process Isolation Rules
1. **Essential System Processes**: Placed under `/sys/fs/cgroup/system.slice/`. Configured with high CPU weight (`cpu.weight = 200`) and guaranteed RAM reservation (`memory.min`).
2. **Account Processes**: Placed under `/sys/fs/cgroup/account.slice/account_<id>/`. Configured with default CPU weight (`cpu.weight = 100`) and strict upper limits (`cpu.max`, `memory.high`).

---

## 4. Initial Design Targets & Policy Rules

Per Master Plan Section 4.3, 4.4, and project owner confirmation, the following initial design targets apply (treated as **design targets, not absolute hardware guarantees**):

### 4.1 System CPU Safety Threshold (`RULE-001` / `KERN-008`)
- **Target Value**: System-wide total CPU utilization MUST NOT exceed approximately **80–90%** for sustained periods (> 5 seconds).
- **Enforcement Action**: When system CPU utilization exceeds 85%, kernel cgroup policy throttles non-active background account slices (`cpu.max` restricted to 20%), prioritizing the active foreground session and system services.

### 4.2 System RAM Reserve (`RULE-002` / `KERN-008`)
- **Target Value**: Approximately **10–20%** of total system RAM (approx. 800MB–1.6GB on 8GB Pixel 8) MUST be permanently reserved for the kernel and essential system services (`system.slice`).
- **Enforcement Action**: If available RAM falls below 15%, the Android Low Memory Killer Daemon (`lmkd`) and cgroup memory pressure notifications terminate background ordinary account processes before system services face memory starvation.

### 4.3 Background Sanitization Execution Window (`RULE-019` / `KERN-009`)
- **Target Value**: Background storage sanitization (managed by the DeeX Lifecycle module) MUST execute only when total system CPU utilization is below approximately **40–50%**.
- **Enforcement Action**: The sanitization task is assigned to `/sys/fs/cgroup/sanitization.slice` with `cpu.weight = 10`. If system CPU exceeds 50%, the process is immediately paused or throttled via cgroup v2 freezer/weight controls.

---

## 5. Thermal Protection Boundary Assertion

Per Master Plan Section 4.3, project owner confirmation, and official AOSP thermal documentation [Primary Source: AOSP Thermal Mitigation, `https://source.android.com/docs/core/power/thermal-mitigation`, Access Date: 2025-05-16, Confidence: `VERIFIED`]:

1. **CPU/RAM Thresholds ARE NOT Thermal Protection**: System CPU and RAM utilization metrics cannot predict or guarantee physical device junction temperatures.
2. **Hardware Thermal Safety Boundary**: Hardware thermal diodes, SoC firmware, and Linux kernel thermal zone governors (`cpufreq` DVFS) retain full authority over thermal mitigation.
3. **No Override Rule**: DeeX resource accounting mechanisms **MUST NEVER override, disable, or modify hardware thermal safety limits or vendor thermal throttling governors**.

---

## 6. Threshold Exceeded Response Policies

| Metric Event | Trigger Condition | System Action | Essential Service Impact |
|---|---|---|---|
| **High CPU Utilization** | System CPU > 85% for 5s | Throttle background account cgroups (`cpu.max`); defer background tasks | **Zero Impact** (High priority slice guaranteed) |
| **High Memory Pressure** | Free RAM < 15% | Pause non-active account sessions; trigger `lmkd` on inactive accounts | **Zero Impact** (`system.slice` protected via `memory.min`) |
| **High System Load** | Active account sessions exceed system resource capacity | Refuse initiation of new ordinary user sessions with resource limit prompt | **Zero Impact** (Root and emergency access retained) |
| **CPU Load Spike during Sanitization** | System CPU > 50% while sanitizing | Pause sanitization slice via cgroup freezer | **Zero Impact** (Sanitization immediately yields) |

---

## 7. Open Decisions for Project Owner

1. **Session Limits**: Maximum number of concurrently mounted/active ordinary account sessions permitted before blocking session initiation (`UNKNOWN — decision required`).
2. **eBPF Accounting Policy**: Whether eBPF accounting probes should run in strict user-space monitoring mode or register kernel cgroup socket filters (`UNKNOWN — decision required`).
