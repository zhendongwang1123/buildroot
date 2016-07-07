################################################################################
#
# openmpi
#
################################################################################

OPENMPI_VERSION_MAJOR = 1.10
OPENMPI_VERSION = $(OPENMPI_VERSION_MAJOR).2
OPENMPI_SITE = https://www.open-mpi.org/software/ompi/v$(OPENMPI_VERSION_MAJOR)/downloads
OPENMPI_SOURCE = openmpi-$(OPENMPI_VERSION).tar.bz2
OPENMPI_LICENSE = BSD-3c
OPENMPI_LICENSE_FILES = LICENSE
OPENMPI_INSTALL_STAGING = YES
OPENMPI_CONF_OPTS = --disable-vt

# Enabling Fortran support requires pre-seeding the configure script
# with various values that cannot be guessed, so we provide cache
# files for various architectures.

ifeq ($(BR2_TOOLCHAIN_HAS_FORTRAN),y)
ifeq ($(BR2_mips)$(BR2_mipsel),y)
OPENMPI_FORTRAN_CONF_CACHE = package/openmpi/openmpi-mips32-fortran.cache
endif
endif

ifneq ($(OPENMPI_FORTRAN_CONF_CACHE),)
define OPENMPI_COPY_FORTRAN_CACHE
	cp $(OPENMPI_FORTRAN_CONF_CACHE) $(@D)/openmpi-config.cache
endef

OPENMPI_POST_PATCH_HOOKS += OPENMPI_COPY_FORTRAN_CACHE
OPENMPI_CONF_OPTS += \
	--enable-mpi-fortran=yes \
	--cache-file=$(@D)/openmpi-config.cache
else
OPENMPI_CONF_OPTS += --enable-mpi-fortran=no
endif

$(eval $(autotools-package))
