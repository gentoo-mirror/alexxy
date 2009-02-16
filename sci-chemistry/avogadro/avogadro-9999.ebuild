# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/avogadro/avogadro-0.8.1.ebuild,v 1.3 2008/09/22 13:28:43 markusle Exp $

EAPI=1
RESTRICT="mirror"

inherit toolchain-funcs multilib eutils git

DESCRIPTION="Advanced molecular editor that uses Qt4 and OpenGL"
HOMEPAGE="http://avogadro.sourceforge.net/"
EGIT_REPO_URI="git://github.com/cryos/avogadro.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="python"

DEPEND=">=dev-util/cmake-2.4.8
	>=dev-cpp/eigen-2.0.0
	${RDEPEND}"
RDEPEND="|| ( ( x11-libs/qt-gui:4 x11-libs/qt-opengl:4 )
				>=x11-libs/qt-4.3.4 )
	>=sci-chemistry/openbabel-2.2.0
	python? ( >=dev-lang/python-2.5 >=dev-libs/boost-1.34 )"

src_compile() {
	if use python; then
		USEPYTHON="TRUE"
	else
		USEPYTHON="FALSE"
	fi
	cmake -DCMAKE_INSTALL_PREFIX=/usr \
		-DLIBRARY_OUTPUT_PATH=PROJECT_BINARY_DIR/$(get_libdir) \
		-DCMAKE_BUILD_TYPE=Release \
		-DENABLE_PYTHON=${USEPYTHON} \
		-DLIB_INSTALL_DIR=$(get_libdir) \
		-DCMAKE_C_COMPILER=$(type -p $(tc-getCC)) \
		-DCMAKE_CXX_COMPILER=$(type -p $(tc-getCXX)) || die "cmake failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
}
