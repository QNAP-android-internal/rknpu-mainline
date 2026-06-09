# SPDX-License-Identifier: GPL-2.0
# Out-of-tree build of the Rockchip RKNPU driver for the mainline kernel.
#
# The in-tree build selected features via Kconfig (CONFIG_ROCKCHIP_RKNPU_*).
# Out-of-tree those symbols are not in the kernel's autoconf.h, so define the
# minimal-viable set here (matches the validated in-tree config):
#   - DRM-GEM memory manager
#   - debugfs
# Left off: DVFS (devfreq), SRAM, fence, dma-heap, procfs, NO_GKI.

# --- kbuild fragment (read when invoked as `make -C $KDIR M=$PWD`) ---
obj-m += rknpu.o

rknpu-y += rknpu_drv.o
rknpu-y += rknpu_reset.o
rknpu-y += rknpu_job.o
rknpu-y += rknpu_debugger.o
rknpu-y += rknpu_iommu.o
rknpu-y += rknpu_gem.o

ccflags-y += -I$(src)/include
ccflags-y += -DCONFIG_ROCKCHIP_RKNPU_DRM_GEM=1
ccflags-y += -DCONFIG_ROCKCHIP_RKNPU_DEBUG_FS=1

# --- top-level targets (used by module.bbclass / a plain `make`) ---
SRC := $(shell pwd)
KERNEL_SRC ?= /lib/modules/$(shell uname -r)/build

all:
	$(MAKE) -C $(KERNEL_SRC) M=$(SRC) modules

modules_install:
	$(MAKE) -C $(KERNEL_SRC) M=$(SRC) modules_install

clean:
	rm -f *.o *~ core .depend .*.cmd *.ko *.mod *.mod.c
	rm -f Module.markers Module.symvers modules.order
	rm -rf .tmp_versions
