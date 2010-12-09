# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit qt4-r2 versionator multilib
#pam

MY_PV=$(replace_version_separator 2 -)
DESCRIPTION="Use Fingerprint Devices with Linux"
HOMEPAGE="http://www.n-view.net/Appliance/fingerprint/"
SRC_URI="http://www.n-view.net/Appliance/fingerprint/download/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="upekbsapi"

DEPEND="
	!sys-auth/pam_fprint
	!sys-auth/fprintd
	!sys-auth/thinkfinger
	>=sys-auth/libfprint-0.1.0_pre2
	x11-libs/libfakekey
	>=app-crypt/qca-2.0.0
	>=app-crypt/qca-ossl-2.0.0_beta3
	sys-auth/upekbsapi-bin[headers]
	x11-libs/qt-core:4
	x11-libs/qt-gui:4
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}"

src_configure() {
	eqmake4 PREFIX="$EROOT/usr" LIB="$(get_libdir)" || die "qmake4 failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" DESTDIR="${D}" install || die "emake install failed"
	domenu bin/fingerprint-gui/fingerprint-gui.desktop
	dodoc CHANGELOG README IMPORTANT-UPGRADE-INFORMATION.txt \
		Hacking.html \
		"${FILESDIR}/Install-step-by-step.html"
}

pkg_postinst() {
	elog "1) You may want to add the followingline to the first of /etc/pam.d/system-auth"
	elog "   auth        sufficient  pam_fingerprint-gui.so"
	elog "2) You must be in the plugdev group to use fingerprint"
	if use upekbsapi; then
		elog "3) You select to install upeks bsapi library, it's not open-sourced."
		elog "   Use it in your own risk."
	fi
	elog "*) Please see /usr/share/doc/${P}/Install-step-by-step.* to configure your device"
}