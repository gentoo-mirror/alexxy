# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-nds/gosa-plugin-systems/gosa-plugin-systems-2.6.12-r1.ebuild,v 1.1 2011/04/13 12:41:05 dev-zero Exp $

EAPI=4

DESCRIPTION="GOsa plugin for common systems integration"
HOMEPAGE="https://oss.gonicus.de/labs/gosa/wiki/WikiStart."
SRC_URI="http://oss.gonicus.de/pub/gosa/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="~net-nds/gosa-core-${PV}"

GOSA_COMPONENT="${PN/gosa-plugin-}"

src_install() {
	insinto /usr/share/gosa/html/plugins/${GOSA_COMPONENT}/
	doins -r html/*

	insinto /usr/share/gosa/locale/plugins/${GOSA_COMPONENT}/
	doins -r locale/*

	insinto /usr/share/gosa/plugins
	doins -r admin

	insinto /usr/share/gosa/doc/plugins/${GOSA_COMPONENT}/
	doins -r help/*
}

pkg_postinst() {
	ebegin "Updating class cache and locales"
	"${EROOT}"usr/sbin/update-gosa
	eend $?
}
