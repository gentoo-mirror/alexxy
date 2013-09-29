# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/latex-calendar/latex-calendar-3.1.ebuild,v 1.8 2013/04/03 22:23:08 ulm Exp $

EAPI="5"

PYTHON_COMPAT=( python{2_6,2_7} )

inherit latex-package distutils-r1

DESCRIPTION="cpssp - Draw protein secondary structures"
HOMEPAGE="http://www.ctan.org/pkg/cpssp"
SRC_URI="http://dev.gentoo.org/~alexxy/distfiles/${P}.zip"

LICENSE="LPPL-1.3c"
SLOT="0"
KEYWORDS=" ~amd64 ~x86"
IUSE=""

src_compile() {
	einfo "Extracting from cpssp.ins"
	latex cpssp.ins >/dev/null 2>&1
	einfo "Compiling doc"
	pdflatex cpssp.dtx >/dev/null 2>&1
	makeindex -s gind.ist -o cpssp.ind cpssp.idx >/dev/null 2>&1
	makeindex -s gglo.ist -o cpssp.gls cpssp.glo >/dev/null 2>&1
	pdflatex cpssp.dtx >/dev/null 2>&1
}

src_install() {
	latex-package_src_doinstall styles bin doc
	dobin cpssp
}