# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit git-2 cmake-utils

DESCRIPTION="Mesa OpenCL implementation (software and Gallium-based)"
HOMEPAGE="http://cgit.freedesktop.org/~steckdenis/clover/"
EGIT_REPO_URI="git://anongit.freedesktop.org/~steckdenis/clover"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
		media-libs/mesa[llvm,gallium]
		sys-devel/clang
		sys-devel/llvm
"
RDEPEND="${DEPEND}"

src_unpack() {
	default
	[[ $PV = 9999* ]] && git-2_src_unpack
}

src_install() {
	cmake-utils_src_install
	insinto /usr/include
	doins -r "${S}/include/CL"
}
