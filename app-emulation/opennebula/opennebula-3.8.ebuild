# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby19"

inherit eutils multilib ruby-ng user scons-utils

DESCRIPTION="OpenNebula Virtual Infrastructure Engine"
HOMEPAGE="http://www.opennebula.org/"
SRC_URI="opennebula-3.8.0.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="mysql sqlite"

RDEPEND=">=dev-libs/xmlrpc-c-1.18.02[abyss,cxx,threads]
	dev-lang/ruby:1.9
	mysql? ( dev-db/mysql )
	dev-db/sqlite:3[threadsafe]
	net-misc/openssh"
DEPEND="${RDEPEND}
	>=dev-util/scons-1.2.0-r1"

ruby_add_rdepend "dev-ruby/nokogiri
	dev-ruby/crack"

# make sure no eclass is running tests
RESTRICT="test fetch"

ONEUSER="oneadmin"
ONEGROUP="oneadmin"

S="${WORKDIR}/${P}.0"

pkg_nofetch() {
	einfo "Please go to http://downloads.opennebula.org/"
	einfo "Download ${P} and place it to ${DISTDIR}"
}

pkg_setup () {
	enewgroup ${ONEGROUP}
	enewuser ${ONEUSER} -1 /bin/bash /var/lib/one ${ONEGROUP}
}

src_prepare() {
	default
}

src_unpack() {
	default
}

src_configure() {
	myesconsargs=(
		$(use_scons mysql)
		)
}

src_compile() {
	escons
}

src_install() {
	DESTDIR=${T} ./install.sh || die "install failed"

	cd "${T}"

	# installing things for real
	dobin bin/*

	insinto /usr/$(get_libdir)/one
	doins -r lib/*

	insinto /usr/share/doc/${PF}
	doins -r share/examples

	keepdir /var/lock/one
	keepdir /var/lib/one
	keepdir /var/log/one
	keepdir /var/run/one
	keepdir /var/images

	fowners ${ONEUSER}:${ONEGROUP} /var/{lock,lib,log,run}/one /var/images
	fperms 3770 /var/images

	doenvd "${FILESDIR}/99one"

	newinitd "${FILESDIR}/opennebula.initd" opennebula
	newconfd "${FILESDIR}/opennebula.confd" opennebula

	insinto /etc/one
	insopts -m 0640
	doins -r etc/*
	doins "${FILESDIR}/one_auth"
	fowners -R root:${ONEGROUP} /etc/one
	fowners ${ONEUSER}:${ONEGROUP} /etc/one/one_auth
}

pkg_postinst() {
	local onedir="${EROOT}var/lib/one"
	if [ ! -d "${onedir}/.ssh" ] ; then
		einfo "Generating ssh-key..."
		umask 0027 || die "setting umask failed"
		mkdir "${onedir}/.ssh" || die "creating ssh directory failed"
		ssh-keygen -q -t dsa -N "" -f "${onedir}/.ssh/id_dsa" || die "ssh-keygen failed"
		cat > "${onedir}/.ssh/config" <<EOF
UserKnownHostsFile /dev/null
Host *
    StrictHostKeyChecking no
EOF
		cat "${onedir}/.ssh/id_dsa.pub"  >> "${onedir}/.ssh/authorized_keys" || die "adding key failed"
		chown -R ${ONEUSER}:${ONEGROUP} "${onedir}/.ssh" || die "changing owner failed"
	fi
}
