# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# TODO: use versionator; first talk to upstream to cleanup their naming
# TODO: add slot for version 2, append -${SLOT}

EAPI=2

inherit eutils multilib qt4-r2 versionator

DESCRIPTION="A mesh processing system for the editing of large unstructured 3D triangular meshes."
HOMEPAGE="http://meshlab.sourceforge.net/"
SRC_URI="mirror://sourceforge/meshlab/meshlab/MeshLab%20v1.3.0/MeshLabSrc_AllInc_v130a.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=">=sys-devel/gcc-4.3
	media-libs/glew
	sci-libs/levmar
	media-libs/lib3ds
	>=dev-cpp/muParser-1.30
	media-libs/qhull
	x11-libs/qt-core:4
	x11-libs/qt-opengl:4"
RDEPEND="${DEPEND}"

S=${WORKDIR}/meshlab/src

PATCHES=(
	"${FILESDIR}/${PF}-unbundle-libs-and-fix-rpath.patch"
)

src_configure() {
	eqmake4 external/external.pro
	eqmake4 meshlab_full.pro
}

src_compile() {
	cd external && emake
	cd .. && emake
}

src_install() {
	local my_libdir=/usr/$(get_libdir)/meshlab

	exeinto ${my_libdir}
	doexe distrib/{libcommon.so.1.0.0,meshlab{,server}} || die
	dosym libcommon.so.1.0.0 ${my_libdir}/libcommon.so.1 || die
	dosym libcommon.so.1 ${my_libdir}/libcommon.so || die
	dosym ${my_libdir}/meshlab /usr/bin/meshlab || die
	dosym ${my_libdir}/meshlabserver /usr/bin/meshlabserver || die

	exeinto ${my_libdir}/plugins
	doexe distrib/plugins/*.so || die

	insinto ${my_libdir}/shaders
	doins -r distrib/shaders/* || die
}
