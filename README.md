# rknpu-mainline

Out-of-tree build of the Rockchip **RKNPU** NPU driver, ported to the **mainline
Linux kernel** (validated on v7.1-rc4, RK3588 / IEI WAFER-RK3588).

It binds the `rockchip,rk3588-rknpu` device tree node and exposes a DRM render
node (`/dev/dri/renderD*`) used by the closed-source `librkllmrt.so` (rkllm) and
RKNN userspace. This is the driver path for **LLM inference on the NPU**; the
upstream `drm/accel/rocket` driver targets the same hardware for CNN/RKNN via
Mesa Teflon but is a separate stack.

## Status / scope

Minimal-viable configuration:

- DRM-GEM memory manager (`CONFIG_ROCKCHIP_RKNPU_DRM_GEM`)
- debugfs (`/sys/kernel/debug/rknpu/`)
- **non-IOMMU** for now (uses contiguous/CMA buffers — size CMA accordingly)
- disabled: DVFS/devfreq, SRAM, fence, dma-heap, procfs

Vendor BSP-only kernel APIs were replaced (see `include/rknpu_compat.h`) and the
6.1→7.1 kernel API deltas fixed (drm_driver fields, `hrtimer_setup`,
`sg_dma_is_bus_address`, `iommu_map*` gfp arg, platform `.remove` returning void,
`MODULE_IMPORT_NS("DMA_BUF")`, pfn_t removal, …).

## Build (out-of-tree)

```sh
make -C /path/to/kernel/build M=$PWD modules
# or via the standard wrapper target:
make KERNEL_SRC=/path/to/kernel/build
```

On device:

```sh
modprobe rknpu
dmesg | grep -i rknpu          # "using non-iommu mode" + Initialized rknpu
ls /dev/dri/                   # renderD12x appears
```

## License

GPL-2.0-only. See [LICENSE](LICENSE).
