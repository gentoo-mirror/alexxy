# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils git-r3 linux-mod udev

DESCRIPTION="FlashCache is a general purpose writeback block cache for Linux"
HOMEPAGE="https://github.com/facebook/flashcache"
EGIT_REPO_URI="https://github.com/facebook/flashcache.git"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dracut"

DEPEND="virtual/linux-sources"
RDEPEND=""

CONFIG_CHECK="BLK_DEV_DM"

MODULE_NAMES="
	flashcache(kernel/drivers/block:${S}:${S}/src)"

src_compile() {
	set_arch_to_kernel
	emake KERNEL_TREE="${KERNEL_DIR}" || die
}

src_install() {
	linux-mod_src_install

	cd "${S}/src/utils"
	dosbin flashcache_create flashcache_destroy flashcache_load || die
	if use dracut; then
		cd src/dracut-flashcache-0.3
		insinto /usr/lib/dracut/modules.d
		doins -r 90flashcache
		dosbin fc_scan
		udev_dorules 10-flashcache.rules
	fi
}
