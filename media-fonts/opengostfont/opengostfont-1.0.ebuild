# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Open-source version of the fonts by Russian standard GOST 2.304-81"
HOMEPAGE="https://fontstorage.com/font/nikita-volchenkov/opengost-a"
SRC_URI="https://webfonts.ru/original/opengosta/opengosta.zip"
S="${WORKDIR}"

LICENSE="OFL-1.10"
SLOT="0"
KEYWORDS="amd64 arm64 x86"

DEPEND="app-arch/unzip"

#FONT_S="OpenGostTypeA-Regular.ttf"
FONT_SUFFIX="ttf"
