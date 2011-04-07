# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit subversion autotools

DESCRIPTION="LibTorrent is a BitTorrent library written in C++ for *nix."
HOMEPAGE="http://libtorrent.rakshasa.no"
ESVN_REPO_URI="svn://rakshasa.no/libtorrent/trunk/libtorrent"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug ipv6"

DEPEND="${RDEPEND}
		dev-util/pkgconfig"
RDEPEND="
		>=dev-libs/libsigc++-2.2.2"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug debug werror) \
		$(use_enable ipv6)
}

src_install() {
	emake docdir="/usr/share/doc/${PN}" DESTDIR="${D}" install \
		|| die "emake install failed"
}
