# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#inherit some_eclass another_eclass

DESCRIPTION="tangoGPS is a lightweight and fast mapping application."
HOMEPAGE="http://www.tangogps.org/"
SRC_URI="http://www.tangogps.org/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gps"

RDEPEND=""
DEPEND="sys-devel/gettext
        x11-libs/gtk+
        sys-apps/dbus
        gnome-base/gconf
        net-misc/curl
        gps? ( >=sci-geosciences/gpsd-2.34 )"

src_install() {
	emake install DESTDIR="${D}" || die "Install failed"
	dodoc NEWS README* AUTHORS ChangeLog
}

