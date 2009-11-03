# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools eutils linux-info

DESCRIPTION="LinuX Containers userspace utilities"
HOMEPAGE="http://lxc.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc static-libs"

RDEPEND="
	sys-libs/libcap
	>=sys-kernel/linux-headers-2.6.29
"
DEPEND="
	doc? ( app-text/docbook-sgml-utils )
	${RDEPEND}
"

CONFIG_CHECK="CGROUPS
	CGROUP_NS CPUSETS CGROUP_CPUACCT
	RESOURCE_COUNTERS CGROUP_MEM_RES_CTLR
	CGROUP_SCHED

	NAMESPACES
	IPC_NS USER_NS PID_NS

	SECURITY_FILE_CAPABILITIES"

SUPPLIMENTARY_KOPTIONS="
	CGROUP_FREEZER
	UTS_NS NET_NS
	VETH MACVLAN
"

INFO_CGROUP_FREEZER="Required to freeze containers"

INFO_UTS_NS="Required to unshare hostnames and uname info"
INFO_NET_NS="Required for unshared network"

INFO_VETH="Required for internal (inter-container) networking"
INFO_MACVLAN="${INFO_VETH}"

src_prepare() {
	epatch "${FILESDIR}/${P}-fix-doc-automagic.patch"
	epatch "${FILESDIR}/0.6.2-as-needed.patch"

	eautoreconf
}

src_configure() {
	econf \
		--localstatedir=/var				\
		--bindir=/usr/sbin					\
		$(use_enable static-libs static)	\
		$(use_enable doc)					\
		|| die "configure failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"

	dodoc AUTHORS CONTRIBUTING MAINTAINERS			|| die "dodoc failed"
	dodoc ChangeLog NEWS TODO README doc/FAQ.txt	|| die "dodoc failed"

	docinto config
	dodoc "${D}"/etc/lxc/*.conf	|| die "dodoc on config-samples failed"

	rm -Rf "${D}"/etc/lxc
	rm -f "${D}"/usr/sbin/lxc-{setcap,ls}

	keepdir /etc/lxc /var/lib/lxc

	find "${D}" -name '*.la' -delete
}

pkg_postinst() {
	local warn_about= option= message=

	for option in ${SUPPLIMENTARY_KOPTIONS}; do
		linux_chkconfig_present ${option} && continue;

		warn_about="${warn_about} ${option}"
	done

	if [[ -n "${warn_about}" ]]; then
		elog "There is few kernel options that is not mandatory for LXC"
		elog "But some nice features will refuse to work without them"
		elog "Here comes a list of options you may be interested to add:"
		elog

		for option in ${warn_about}; do
			eval message=\${INFO_${option}}

			elog "\tCONFIG_${option}: ${message}"
		done
	fi
}
