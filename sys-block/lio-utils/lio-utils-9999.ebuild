# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

EGIT_REPO_URI="git://git.kernel.org/pub/scm/linux/storage/lio/lio-utils.git"
PYTHON_DEPEND="2"
RESTRICT_PYTHON_ABIS="3.*"
SUPPORT_PYTHON_ABIS="1"

inherit eutils distutils git-2 python

DESCRIPTION="Tools for controlling target_core_mod/ConfigFS"
HOMEPAGE="http://linux-iscsi.org/"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="snmp"

DEPEND="snmp? ( net-analyzer/net-snmp )"
RDEPEND="${DEPEND}"

src_prepare(){
	local module

	for module in tcm-py lio-py; do
		cd ${module}
		distutils_src_prepare
		cd ..
	done
	epatch "${FILESDIR}"/tools-makefile.patch
	epatch "${FILESDIR}"/snmp-makefile.patch
}

src_compile(){
	local module

	for module in tcm-py lio-py; do
		cd ${module}
		distutils_src_compile
		cd ..
	done
	cd tools/
	emake || die "emake failed"
	cd ..
	if use snmp; then
		cd mib-modules/
		emake || die "emake snmp failed"
		cd ..
	fi
}

src_install(){
	local module

	for module in tcm-py lio-py; do
		cd ${module}
		distutils_src_install
		cd ..
	done
	cd tools/
	emake DESTDIR="${ED}" install || die "emake install failed"
	cd ..

	symlink_to_sbin(){
		local ver=$(python_get_version) sitedir="$(python_get_sitedir)"
		ln -s "${sitedir}"/lio_dump.py \
				"${ED}"/usr/sbin/lio_dump-${ver}
		python_convert_shebangs "${ver}" "${D}${sitedir}"/lio_dump.py
		ln -s "${sitedir}"/lio_node.py \
				"${ED}"/usr/sbin/lio_node-${ver}
		python_convert_shebangs "${ver}" "${D}${sitedir}"/lio_node.py
	}
	python_execute_function --action-message "Making symlinks to /usr/sbin" symlink_to_sbin
	python_generate_wrapper_scripts "${ED}"/usr/sbin/{lio_dump,lio_node}

	if use snmp; then
		cd mib-modules/
		emake DESTDIR="${ED}" install || die "emake install snmp failed"
		cd ..
	fi

	emake DESTDIR="${ED}" conf_install || die "emake conf_install failed"
	#Handle initscripts here
}
