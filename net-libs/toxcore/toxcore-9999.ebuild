# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-r3 autotools-utils

AUTOTOOLS_AUTORECONF="1"

DESCRIPTION="The future of online communications"
HOMEPAGE="https://tox.im"
SRC_URI=""
EGIT_REPO_URI=" git://github.com/irungentoo/toxcore
				https://github.com/irungentoo/toxcore"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="+av logging daemon static-libs"

DEPEND="
	dev-libs/libsodium
	av? ( media-libs/libvpx media-libs/opus )
	daemon? ( dev-libs/libconfig )"
RDEPEND="${DEPEND}"

src_configure() {
	local myeconfargs=(
		$(use_enable av)
		$(use_enable logging)
		$(use_enable daemon)
		$(use_enable static-libs static)
		--disable-tests
		--disable-testing
		--program-transform-name='s:DHT_bootstrap:tox-dht-daemon:g'
		)
		autotools-utils_src_configure
}
