# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools

DESCRIPTION="C++ bindings of libcurl"
HOMEPAGE="http://rrette.com/textpattern/index.php?s=cURLpp"
SRC_URI="http://rrette.com/files/curlpp/curlpp-0.7/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="net-misc/curl"

src_unpack() {
	sed -i -e "s:@CURLPP_CFLAGS@:@CURLPP_CXXFLAGS@:" curlpp-config.in
	epatch "${FILESDIR}/disable-examples-build.patch" #example18 doesnt build
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc CHANGES AUTHORS TODO doc/guide.pdf
	insinto "/usr/share/${P}"
	doins examples/*
}
