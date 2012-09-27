# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools git-2

DESCRIPTION="A flexible OpenVPN plugin to handle user using a MySQL database backend"
HOMEPAGE="https://github.com/alexxy/openvpn-mysql-auth"
SRC_URI=""
EGIT_REPO_URI="
	git://github.com/alexxy/openvpn-mysql-auth.git
	https://github.com/alexxy/openvpn-mysql-auth.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	net-misc/openvpn
	virtual/mysql
"
RDEPEND="${DEPEND}"

src_prepare() {
	# disable -Werror
	sed -e 's:-Werror::g' \
		-i configure.in || die
	eautoreconf
}

src_configure() {
	default
}

src_compile() {
	default
}

src_install() {
	default
	dodoc -r example
}
