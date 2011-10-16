# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

MY_PN="${PN/-/_}"
MY_PN="${MY_PN/35/}"
MY_PV="3.5_${PV}"
MY_P="${MY_PN}-${MY_PV}"

FN="${MY_P}.tar.gz"
DESCRIPTION="Firmware flasher for Maemo"
HOMEPAGE="http://www.maemo.org"
SRC_URI="${FN}"

LICENSE="Nokia-EULA"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="fetch strip"

DEPEND="virtual/libc"
RDEPEND="${DEPEND}"

pkg_nofetch() {
	elog "Please obtain ${FN} from
	http://tablets-dev.nokia.com/maemo-dev-env-downloads.php
	and place it in ${DISTDIR}"
}

S="${WORKDIR}"/${MY_P}

src_install() {
	newbin flasher-3.5 flasher || die
	newman man/man1/flasher-3.5.1 flasher.1 || die
	dodoc doc/changelog doc/README.Debian || die
}
