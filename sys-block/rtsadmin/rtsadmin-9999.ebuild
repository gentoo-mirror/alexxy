# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

EGIT_REPO_URI="git://linux-iscsi.org/${PN}.git"
PYTHON_DEPEND="2"
RESTRICT_PYTHON_ABIS="3.*"
SUPPORT_PYTHON_ABIS="1"

inherit eutils distutils git-2 python linux-info

DESCRIPTION="RTSAdmin Community Edition for target_core_mod/ConfigFS"
HOMEPAGE="http://linux-iscsi.org/"
SRC_URI=""

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-python/configshell
	dev-python/rtslib
	"
RDEPEND="${DEPEND}"

CONFIG_CHECK="~TARGET_CORE"

src_install() {
	distutils_src_install
	keepdir /var/target/
	keepdir /var/target/fabric
}
