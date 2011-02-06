# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/nm-applet/nm-applet-0.8.2.ebuild,v 1.1 2010/11/10 13:05:32 dagger Exp $

EAPI="2"

inherit gnome2 autotools

MY_PN="${PN/nm-applet/network-manager-applet}"

DESCRIPTION="Gnome applet for NetworkManager."
HOMEPAGE="http://projects.gnome.org/NetworkManager/"

LICENSE="GPL-2"
SLOT="0"
IUSE="bluetooth"
if [[ ${PV} = 9999 ]]; then
	inherit git
	EGIT_REPO_URI="git://git.gnome.org/${MY_PN}"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="${SRC_URI//${PN}/${MY_PN}}"
	KEYWORDS="~amd64 ~ppc ~x86"
fi

# FIXME: bluetooth is automagic
RDEPEND=">=dev-libs/glib-2.16
	>=dev-libs/dbus-glib-0.74
	>=sys-apps/dbus-1.2.6
	>=x11-libs/gtk+-2.20:2
	>=gnome-base/gconf-2.20
	>=x11-libs/libnotify-0.3
	>=gnome-base/gnome-keyring-2.20
	>=dev-libs/libnl-1.1
	>=net-misc/networkmanager-${PV}
	>=net-wireless/wireless-tools-28_pre9
	>=net-wireless/wpa_supplicant-0.5.7
	net-misc/mobile-broadband-provider-info
	bluetooth? ( >=net-wireless/gnome-bluetooth-2.27.6 )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=dev-util/intltool-0.35"

DOCS="AUTHORS ChangeLog NEWS README"
# USE_DESTDIR="1"

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
		gtkdocize
		intltoolize --force
		eautoreconf
}

pkg_setup() {
	G2CONF="${G2CONF}
		--with-gtk2
		--disable-more-warnings
		--localstatedir=/var"
}
