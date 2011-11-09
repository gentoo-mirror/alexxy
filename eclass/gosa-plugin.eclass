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
SRC_URI="http://oss.gonicus.de/pub/gosa/${P}.tar.gz"
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

S="${WORKDIR}/gosa/${GOSA_COMPONENT}"

# @FUNCTION: gosa-plugin_src_install
# @DESCRIPTION:
# Default src_install function for gosa-plugins
gosa-plugin_src_install() {

	if [ -d etc ]; then
		insinto /etc/gosa
		doins -r etc/*
	fi

	if [ -d html ]; then
		insinto /usr/share/gosa/html/plugins/${GOSA_COMPONENT}/
		doins -r html/*
	fi

	insinto /usr/share/gosa/locale/plugins/${GOSA_COMPONENT}/
	doins -r locale/*

	insinto /usr/share/gosa/plugins
	if [ -d admin ]; then
		doins -r admin
	fi
	if [ -d personal ]; then
		doins -r personal
	fi
	if [ -d addons ]; then
		doins -r addons
	fi

	if [ -d help ]; then
		insinto /usr/share/gosa/doc/plugins/${GOSA_COMPONENT}/
		doins -r help/*
	fi

	if [ -d contrib ]; then
		insinto /usr/share/doc/${PF}
		doins -r contrib/*
	fi
}

# @FUNCTION: gosa-plugin_pkg_postinst()
# @DESCRIPTION:
# Default pkg_postinst function for gosa-plugins
gosa-plugin_pkg_postinst() {
	ebegin "Updating class cache and locales"
	"${EROOT}"usr/sbin/update-gosa
	eend $?
}
