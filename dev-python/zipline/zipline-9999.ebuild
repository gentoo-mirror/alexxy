# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

if [[ $PV = *9999* ]]; then
	scm_eclass=git-2
	EGIT_REPO_URI="
		git://github.com/quantopian/${PN}.git
		https://github.com/quantopian/${PN}.git"
	SRC_URI=""
	KEYWORDS=""
else
	scm_eclass=vcs-snapshot
	SRC_URI="https://github.com/quantopian/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

inherit eutils distutils-r1 ${scm_eclass}

DESCRIPTION="Zipline is a Pythonic algorithmic trading library"
HOMEPAGE="https://github.com/quantopian/zipline"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND="
		>=dev-python/numpy-1.6d[${PYTHON_USEDEP}]
		>=dev-python/pandas-0.9[${PYTHON_USEDEP}]
		dev-python/msgpack[${PYTHON_USEDEP}]
		dev-python/logbook[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/delorean[${PYTHON_USEDEP}]
		"
RDEPEND="${DEPEND}"

src_prepare() {
	rm -rf tests
	distutils-r1_src_prepare
}
