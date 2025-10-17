# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit cmake fortran-2 python-single-r1

DESCRIPTION="Distributed Block Compressed Sparse Row matrix library"
HOMEPAGE="https://cp2k.github.io/dbcsr"
SRC_URI="https://github.com/cp2k/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

IUSE="mpi openmp"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	mpi? ( virtual/mpi )
	openmp? (
		sys-devel/gcc[openmp]
		llvm-runtimes/clang-runtime[openmp]
	)
"
RDEPEND="${DEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	dev-python/fypp
"

src_configure() {
	default
	local mycmakeargs=(
		-DUSE_MPI=$(usex mpi)
		-DUSE_OPENMP=$(usex openmp)
		-DPYTHON_EXECUTABLE="${EPREFIX}/usr/bin/${EPYTHON}"
	)
	cmake_src_configure
}
