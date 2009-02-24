# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/xen-sources/xen-sources-2.6.21.ebuild,v 1.3 2008/08/31 17:44:43 rbu Exp $

ETYPE="sources"
UNIPATCH_STRICTORDER="1"
K_NOUSENAME="yes"
K_PREPATCHED="yes"

inherit kernel-2
detect_version

EGIT_REPO_URI="git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git"
EGIT_BRANCH="xen/dom0/hackery"

inherit git

DESCRIPTION="Full sources for a dom0/domU Linux kernel to run under Xen"
HOMEPAGE="http://xen.org/"
IUSE=""
KEYWORDS=""



DEPEND="${DEPEND} >=sys-devel/binutils-2.17"

src_unpack() {
	git_src_unpack
	cd "${EGIT_STORE_DIR}/${EGIT_PROJECT}"
	local last_commit_abbrev=$(git log -n 1 --no-color --pretty='format:%h')
	EXTRAVERSION="-${KV_MOD}.git-${last_commit_abbrev}"
	S=${WORKDIR}/${EGIT_PROJECT}
	cd "${S}"
	unpack_set_extraversion
}
