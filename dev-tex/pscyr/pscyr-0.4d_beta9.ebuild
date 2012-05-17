# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/aastex/aastex-5.2.ebuild,v 1.9 2006/09/04 01:22:21 kumba Exp $

EAPI=4

inherit latex-package

DESCRIPTION="Type1 cyrillic fonts collection."
HOMEPAGE="ftp://scon155.phys.msu.su/pub/russian/psfonts/"
SRC_URI="ftp://scon155.phys.msu.su/pub/russian/psfonts/0.4d-beta/PSCyr-0.4-beta9-tex.tar.gz
		ftp://scon155.phys.msu.su/pub/russian/psfonts/0.4d-beta/PSCyr-0.4-beta9-type1.tar.gz"
LICENSE="as-is"

SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

SUPPLIER="public"

S="${WORKDIR}/PSCyr"

src_install() {

	for each in dvips/pscyr tex/latex/pscyr fonts/tfm/public/pscyr \
		fonts/vf/public/pscyr fonts/type1/public/pscyr fonts/afm/public/pscyr; do
		cd "${S}"
		cd "$each"
		latex-package_src_install
	done
	cd "${S}"
	insinto "${TEXMF}/fonts/map/dvips/pscyr"
	doins dvips/pscyr/pscyr.map || die "doins $i failed"

	for each in dvips/pscyr/*.enc; do
		insinto "${TEXMF}/fonts/enc/dvips/pscyr"
		doins "$each" || die "doins $i failed"
	done

	insinto /etc/texmf/updmap.d
	doins "${FILESDIR}/90pscyr.cfg"

	dodoc doc/README.* doc/PROBLEMS ChangeLog
}

pkg_postinst() {
	latex-package_pkg_postinst
	updmap
}

pkg_postrm() {
	latex-package_pkg_postrm
	updmap
}
