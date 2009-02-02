# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/psi/psi-0.12.ebuild,v 1.7 2008/09/20 10:05:57 armin76 Exp $

EAPI="2"

inherit eutils qt4 multilib git

DESCRIPTION="Qt4 Jabber client, with Licq-like interface"
HOMEPAGE="http://psi-im.org/"
EGIT_REPO_URI="git://git.psi-im.org/psi.git"

IUSE="crypt dbus debug doc kernel_linux spell ssl xscreensaver"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS=""
RESTRICT="test"

COMMON_DEPEND="x11-libs/qt-gui:4[qt3support,dbus]
			app-crypt/qca:2
			spell? ( app-text/aspell )
			xscreensaver? ( x11-libs/libXScrnSaver )"

DEPEND="${COMMON_DEPEND}
	doc? ( app-doc/doxygen )"

RDEPEND="${COMMON_DEPEND}
		crypt? ( >=app-crypt/qca-gnupg-2.0.0_beta2 )
		ssl? ( >=app-crypt/qca-ossl-2.0.0_beta2 )"

src_configure() {
	# disable growl as it is a MacOS X extension only
	local myconf="--prefix=/usr --qtdir=/usr"
	myconf="${myconf} --disable-growl --disable-bundled-qca"
	use debug && myconf="${myconf} --enable-debug"
	use dbus || myconf="${myconf} --disable-qdbus"
	use kernel_linux || myconf="${myconf} --disable-dnotify"
	use spell || myconf="${myconf} --disable-aspell"
	use xscreensaver || myconf="${myconf} --disable-xss"

	# cannot use econf because of non-standard configure script
	./configure ${myconf} || die "configure failed"

	eqmake4 ${PN}.pro
}

src_compile() {
	SUBLIBS="-L/usr/${get_libdir}/qca2" emake || die "emake failed"

	if use doc; then
		cd doc
		make api_public || die "make api_public failed"
	fi
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"

	# this way the docs will be installed in the standard gentoo dir
	newdoc iconsets/roster/README README.roster
	newdoc iconsets/system/README README.system
	newdoc certs/README README.certs
	dodoc README

	if use doc; then
		cd doc
		dohtml -r api || die "dohtml failed"
	fi
}
