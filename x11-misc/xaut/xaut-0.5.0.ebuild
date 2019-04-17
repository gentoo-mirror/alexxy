# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Control X from command line and find things on screen"
HOMEPAGE="http://xautomation.sourceforge.net/"
SRC_URI="mirror://sourceforge/xautomation/${P}.tar.gz"

LICENSE="PSTT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXtst
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
	dev-lang/swig
"
