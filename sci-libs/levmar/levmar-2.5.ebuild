# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libexif/libexif-0.6.12-r4.ebuild,v 1.8 2006/01/07 11:43:17 eradicator Exp $

EAPI="3"

inherit eutils

DESCRIPTION="A C++ implementation of the Levenberg-Marquardt non-linear regression"
HOMEPAGE="http://www.ics.forth.gr/~lourakis/levmar/"
SRC_URI="http://www.ics.forth.gr/~lourakis/levmar/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="nosingle nodouble examples"

RDEPEND="virtual/lapack"
DEPEND="${RDEPEND}
		>=dev-util/cmake-2.6"

src_prepare() {
	epatch "${FILESDIR}/cmakeusage-2.5.patch"
}

src_compile() {
	local CMAKE_VARIABLES=""
	CMAKE_VARIABLES="${CMAKE_VARIABLES} -DCMAKE_INSTALL_PREFIX:PATH=/usr"

	if use nosingle; then
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DSUPPORT_SINGLE_PRECICION:BOOL=OFF"
	else
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DSUPPORT_SINGLE_PRECICION:BOOL=ON"
	fi

	if use nodouble; then
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DSUPPORT_DOUBLE_PRECICION:BOOL=OFF"
	else
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DSUPPORT_DOUBLE_PRECICION:BOOL=ON"
	fi

	if use examples; then
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DBUILD_EXAMPLE:BOOL=ON"
	else
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DBUILD_EXAMPLE:BOOL=OFF"
	fi

	cmake ${CMAKE_VARIABLES} . || die "cmake configuration failed"

	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc README.txt

	if use examples; then
		dodir /usr/share/${P}/examples/ || die "Failed to create examples directory"
		cp "lmdemo.c" "${D}/usr/share/${P}/examples/" || die "Failed to copy example files"
	fi
}
