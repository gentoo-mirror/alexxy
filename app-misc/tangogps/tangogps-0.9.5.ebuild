# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="tangoGPS is a lightweight and fast mapping application."
HOMEPAGE="http://www.tangogps.org/"
SRC_URI="http://www.tangogps.org/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gps nls"

RDEPEND=""
DEPEND="x11-libs/gtk+
		sys-apps/dbus
		gnome-base/gconf
		net-misc/curl
		gps? ( >=sci-geosciences/gpsd-2.34 )
		nls? ( sys-devel/gettext )"

src_install() {
	emake install DESTDIR="${D}" || die "Install failed"
	dodoc NEWS README* AUTHORS ChangeLog
}

