# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit linux-mod eutils autotools multilib

DESCRIPTION="Point-to-Point Tunnelling Protocol Client/Server for Linux"
SRC_URI="mirror://sourceforge/accel-pptp/${P}.tar.bz2"
HOMEPAGE="http://accel-pptp.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="tcpd server"

COMMON_DEPEND=">=net-dialup/ppp-2.4.2
	server? ( !net-dialup/pptpd )
	tcpd? ( sys-apps/tcp-wrappers )"
DEPEND="${COMMON_DEPEND}
	virtual/linux-sources"
RDEPEND="${COMMON_DEPEND}"

BUILD_TARGETS="all"
BUILD_PARAMS="KDIR=${KERNEL_DIR}"
CONFIG_CHECK="PPP PPPOE PPTP"
MODULESD_PPTP_ALIASES=("net-pf-24 pptp")

src_prepare() {
	use server && cd "${S}/pptpd-1.3.3" && eautoreconf
	cd "${S}/pppd_plugin" && eautoreconf

	#Match pptpd-logwtmp.so's version with pppd's version (#89895)
	local PPPD_VER=$(best_version net-dialup/ppp)
	PPPD_VER=${PPPD_VER#*/*-} #reduce it to ${PV}-${PR}
	PPPD_VER=${PPPD_VER%%[_-]*} # main version without beta/pre/patch/revision
	echo "#define VERSION \"${PPPD_VER}\"" > "${S}/pptpd-1.3.3/plugins/patchlevel.h"
	# Respect LDFLAGS
	sed -e "/^LDFLAGS/{s:=:+=:}" -i "${S}/pptpd-1.3.3/plugins/Makefile"
}

src_configure() {
	if use server; then
		cd "${S}/pptpd-1.3.3"
		# Define KDIR to build against userspace headers...
		KDIR='/usr' \
		    econf --enable-bcrelay \
				$(use_with tcpd libwrap)
	fi

	cd "${S}/pppd_plugin"
	KDIR='/usr' econf
}

src_compile() {
	if use server; then
		cd "${S}/pptpd-1.3.3"
	    emake COPTS="${CFLAGS}" || die "make failed"
	fi

	cd "${S}/pppd_plugin"
	emake COPTS="${CFLAGS}" || die "make failed"
}

src_install () {
	if use server; then
	    cd "${S}/pptpd-1.3.3"
	    einstall || die "make install failed"

	    insinto /etc
	    doins samples/pptpd.conf

	    insinto /etc/ppp
	    doins samples/options.pptpd

	    exeinto /etc/init.d
	    newexe "${FILESDIR}/pptpd-init" pptpd || die

	    insinto /etc/conf.d
	    newins "${FILESDIR}/pptpd-confd" pptpd || die
	fi

	cd "${S}/pppd_plugin/src/.libs"
	local PPPD_VER=$(best_version net-dialup/ppp)
	PPPD_VER=${PPPD_VER#*/*-} #reduce it to ${PV}-${PR}
	PPPD_VER=${PPPD_VER%%[_-]*} # main version without beta/pre/patch/revision
	insinto /usr/$(get_libdir)/pppd/${PPPD_VER}
	newins pptp.so.0.0.0 pptp.so || die
	doman "${S}"/pppd_plugin/src/pppd-pptp.8 || die

	cd "${S}"
	dodoc README || die
	cp -R example "${D}/usr/share/doc/${P}/example"
}
