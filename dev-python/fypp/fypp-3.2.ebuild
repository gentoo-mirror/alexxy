# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Python powered Fortran metaprogramming"
HOMEPAGE="
	https://github.com/aradi/fypp/
	https://pypi.org/project/fypp/
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
