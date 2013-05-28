# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7,3_1,3_2,3_3} )

if [[ $PV = *9999* ]]; then
	scm_eclass=git-2
	EGIT_REPO_URI="
		git://github.com/alanmcintyre/${PN}.git
		https://github.com/alanmcintyre/${PN}.git"
	SRC_URI=""
	KEYWORDS=""
else
	scm_eclass=vcs-snapshot
	SRC_URI="https://github.com/alanmcintyre/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

inherit eutils distutils-r1 ${scm_eclass}

DESCRIPTION="Python wrapper around the public and trading APIs of BTC-e.com"
HOMEPAGE="https://github.com/alanmcintyre/btce-api"

LICENSE="MIT"
SLOT="0"
IUSE=""
