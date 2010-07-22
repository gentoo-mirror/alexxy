# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit linux-info multilib

DESCRIPTION="Intel WiMAX daemon used to interface to the hardware"
HOMEPAGE="http://www.linuxwimax.org/"
SRC_URI="http://www.linuxwimax.org/Download?action=AttachFile&do=get&target=${P}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-libs/libnl-1.1
	>=sys-kernel/linux-headers-2.6.34"
RDEPEND="${DEPEND}
	net-wireless/wimax-tools
	net-wireless/wpa_supplicant[wimax]"

src_configure() {
	econf \
		--with-libwimaxll=/usr/$(get_libdir) \
		--with-i2400m=/usr || die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	doinitd "${FILESDIR}"/wimax || die "failed to place the init daemon"
	dodoc README || die "Failed to find README"
}
