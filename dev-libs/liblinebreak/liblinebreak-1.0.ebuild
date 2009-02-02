# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="Line breaking library"
HOMEPAGE="http://vimgadgets.sourceforge.net/liblinebreak/"
SRC_URI="mirror://sourceforge/vimgadgets/${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

PATCHES=( "${FILESDIR}/${P}-respect-flags.patch" )

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
}
