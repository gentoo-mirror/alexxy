# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/bfgminer/bfgminer-3.2.1.ebuild,v 1.1 2013/09/19 16:25:45 blueness Exp $

EAPI="5"

if [[ $PV = *9999* ]]; then
	scm_eclass="git-r3 autotools"
	EGIT_REPO_URI="https://github.com/luke-jr/bfgminer
				git://github.com/luke-jr/bfgminer"
	EGIT_BRANCH="bfgminer"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="http://luke.dashjr.org/programs/bitcoin/files/${PN}/${PV}/${P}.tbz2"
	KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"
fi


inherit eutils $scm_eclass

DESCRIPTION="Modular Bitcoin ASIC/FPGA/GPU/CPU miner in C"
HOMEPAGE="https://bitcointalk.org/?topic=168174"

LICENSE="GPL-3"
SLOT="0"

IUSE="+adl avalon bfsb bitforce bitfury bigpic cpumining examples hashbuster hardened icarus knc lm_sensors littlefury modminer metabank nanofury ncurses +opencl proxy scrypt +udev unicode x6500 ztex"
REQUIRED_USE="
	|| ( avalon bfsb bitforce bitfury bigpic  cpumining icarus knc littlefury metabank  modminer opencl proxy x6500 ztex )
	adl? ( opencl )
	bfsb? ( bitfury )
	bigpic? ( bitfury )
	littlefury? ( bitfury )
	metabank? ( bitfury )
	nanofury? ( bitfury )
	lm_sensors? ( opencl )
	scrypt? ( || ( cpumining opencl ) )
	unicode? ( ncurses )
"

DEPEND="
	net-misc/curl
	ncurses? (
		sys-libs/ncurses[unicode?]
	)
	>=dev-libs/jansson-2
	net-libs/libblkmaker
	udev? (
		virtual/udev
	)
	lm_sensors? (
		sys-apps/lm_sensors
	)
	proxy? (
		net-libs/libmicrohttpd
	)
	x6500? (
		virtual/libusb:1
	)
	ztex? (
		virtual/libusb:1
	)
"
RDEPEND="${DEPEND}
	opencl? (
		virtual/opencl
	)
"
DEPEND="${DEPEND}
	virtual/pkgconfig
	>=dev-libs/uthash-1.9.2
	sys-apps/sed
	cpumining? (
		amd64? (
			>=dev-lang/yasm-1.0.1
		)
		x86? (
			>=dev-lang/yasm-1.0.1
		)
	)
"

src_prepare() {
	if [[ $PV = *9999* ]]; then
		eautoreconf
	fi
}

src_configure() {
	local CFLAGS="${CFLAGS}"
	local with_curses
	use hardened && CFLAGS="${CFLAGS} -nopie"

	if use ncurses; then
		if use unicode; then
			with_curses='--with-curses=ncursesw'
		else
			with_curses='--with-curses=ncurses'
		fi
	fi

	CFLAGS="${CFLAGS}" \
	econf \
		--docdir="/usr/share/doc/${PF}" \
		--with-system-libblkmaker \
		$with_curses \
		$(use_enable adl) \
		$(use_enable avalon) \
		$(use_enable bfsb) \
		$(use_enable bigpic) \
		$(use_enable bitfury) \
		$(use_enable bitforce) \
		$(use_enable cpumining) \
		$(use_enable hashbuster) \
		$(use_enable icarus) \
		$(use_enable knc) \
		$(use_enable littlefury) \
		$(use_enable nanofury) \
		$(use_enable modminer) \
		$(use_enable metabank) \
		$(use_with ncurses curses) \
		$(use_enable opencl) \
		$(use_enable scrypt) \
		$(use_with udev libudev) \
		$(use_with lm_sensors sensors) \
		$(use_with proxy libmicrohttpd) \
		$(use_enable x6500) \
		$(use_enable ztex)
}

src_install() {
	emake install DESTDIR="$D"
	if ! use examples; then
		rm -r "${D}/usr/share/doc/${PF}/rpc-examples"
	fi
}
