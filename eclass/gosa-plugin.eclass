# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# @ECLASS: gosa-plugin.eclass
# @AUTHOR:
# Original Author: Alexey Shvetsov <alexxy@gentoo.org>
# @BLURB: Simplify working with gosa plugins

inherit base eutils

EXPORT_FUNCTIONS src_install pkg_postinst

HOMEPAGE="https://oss.gonicus.de/labs/gosa/wiki/WikiStart"
SRC_URI="http://oss.gonicus.de/pub/gosa/${P}.tar.bz2"
LICENSE="GPL-3"
SLOT="0"

DEPEND=""
RDEPEND="
	~net-nds/gosa-core-${PV}
	"

if [[ ${PN} != gosa-plugin-systems ]] ; then
	RDEPEND="${RDEPEND}
		~net-nds/gosa-plugin-systems-${PV}
		"
fi

# @ECLASS-VARIABLE: GOSA_COMPONENT
# @DESCRIPTION:
# Defines GOSA component name

GOSA_COMPONENT="${PN/gosa-plugin-}"

# @FUNCTION: gosa-plugin_src_install
# @DESCRIPTION:
# Default src_install function for gosa-plugins
gosa-plugin_src_install() {
	insinto /usr/share/gosa/html/plugins/${GOSA_COMPONENT}/
	doins -r html/*

	insinto /usr/share/gosa/locale/plugins/${GOSA_COMPONENT}/
	doins -r locale/*

	insinto /usr/share/gosa/plugins
	doins -r admin personal

	insinto /usr/share/gosa/doc/plugins/${GOSA_COMPONENT}/
	doins -r help/*

	dodoc contrib/*
}

# @FUNCTION: gosa-plugin_pkg_postinst()
# @DESCRIPTION:
# Default pkg_postinst function for gosa-plugins
gosa-plugin_pkg_postinst() {
	ebegin "Updating class cache and locales"
	"${EROOT}"usr/sbin/update-gosa
	eend $?
}
