# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit	cmake-utils multilib

DESCRIPTION="Port of Intel's U3D library to gnu build tools"
HOMEPAGE="http://u3d.sourceforge.net/"
SRC_URI="http://www.iaas.msu.ru/tmp/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
		sys-libs/zlib
		virtual/jpeg
		media-libs/libpng
		"
RDEPEND="${DEPEND}"

MYCMAKEARGS="-DU3D_SHARED=ON -DBUILD_SHARED_LIBS=ON"

src_prepare() {
	sed \
		-e "s:LIB_DESTINATION u3d:LIB_DESTINATION $(get_libdir):g" \
		-e "s:PLUGIN_DESTINATION u3d:PLUGIN_DESTINATION $(get_libdir):g" \
		-e "s:BIN_DESTINATION u3d:BIN_DESTINATION bin:g" \
		-e "s:INCLUDE_DESTINATION u3d/include:INCLUDE_DESTINATION include:g" \
		-e "s:SAMPLE_DESTINATION u3d/samples:SAMPLE_DESTINATION share/${PN}/samples:g" \
		-e "s:DOC_DESTINATION u3d/docs:DOC_DESTINATION share/docs/${P}:g" \
		-i CMakeLists.txt
}
