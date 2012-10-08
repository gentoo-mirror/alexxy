# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils autotools vcs-snapshot

DESCRIPTION="KMS/DRM based virtual Console Emulator"
HOMEPAGE="https://github.com/dvdhrm/kmscon"
SRC_URI="http://github.com/dvdhrm/${PN}/tarball/${P} -> ${P}.tar.gz"

LICENSE="MIT LGPL-2.1 BSD-2 as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+bblit dbus doc drm +f8x16 +fbdev freetype2 gles2 gltex pango static-libs systemd +udev"

RDEPEND="
	dev-libs/glib:2
	dbus? ( sys-apps/dbus )
	drm? ( x11-libs/libdrm
		>=media-libs/mesa-8.0.3[egl,gbm] )
	freetype2? ( media-libs/freetype:2 )
	gles2? ( >=media-libs/mesa-8.0.3[gles2] )
	pango? ( x11-libs/pango )
	systemd? ( sys-apps/systemd )
	udev? ( sys-fs/udev )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-proto/xproto
	doc? ( dev-util/gtk-doc )"

REQUIRED_USE="drm? ( gles2 )
	gltex? ( gles2 )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-flags.patch
	eautoreconf
}

src_configure() {
	# xkbcommon not in portage
	econf \
		--disable-silent-rules \
		$(use_enable static-libs static) \
		$(use_enable doc gtk-doc) \
		$(use_enable systemd) \
		$(use_enable udev) \
		$(use_enable dbus) \
		$(use_enable fbdev) \
		$(use_enable drm) \
		$(use_enable gles2) \
		--disable-xkbcommon \
		$(use_enable f8x16) \
		$(use_enable freetype2) \
		$(use_enable pango) \
		$(use_enable bblit) \
		--disable-debug \
		--disable-optimizations \
		--with-html-dir=/usr/share/doc/${PF}/html
}
