# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic

DESCRIPTION="BibTool is a powerful command-line tool to manipulate BibTeX databases."
HOMEPAGE="http://www.gerd-neugebauer.de/software/TeX/BibTool.en.html"
SRC_URI="http://mirror.ctan.org/biblio/bibtex/utils/bibtool/${P}.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc"

DEPEND="
	dev-libs/kpathsea
	doc? ( app-text/texlive )"
RDEPEND="$DEPEND"

S="${WORKDIR}/${PN}"

src_prepare()
{
	sed -e 's,^INSTALL_DIR.*\./mkdirchain,INSTALL_DIR = install -d,g' \
		-e 's,^BIBTOOL_DEFAULT.*$,BIBTOOL_DEFAULT = \\"\.:/usr/share/bibtool\\",g' \
		-e 's,^LIBDIR.*$,LIBDIR = @libdir@/bibtool,g' \
		-e 's,^NON_ANSI_DEFS.*,NON_ANSI_DEFS = @DEFS@ -DSTDC_HEADERS,g' \
		-e 's,\$(INSTALLPREFIX),\$(DESTDIR)\$(INSTALLPREFIX),g' \
		-i AutoConf/makefile.in || die
	default
}

src_configure()
{
	append-flags -fno-strict-aliasing
	econf
	sed -i -e 's#@kpathsea_lib_static@##' makefile || die "sed failed"
}

src_compile() {
	emake CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
	if use doc ; then
		ln -s makefile Makefile
		emake doc
	fi
}

src_install()
{
	emake DESTDIR="${D}" install

	doman doc/bibtool.1 || die

	if use doc ; then
		dodoc doc/{bibtool.pdf,c_lib.pdf,ref_card.pdf} || die
	fi
}
