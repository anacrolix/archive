# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="UPnP IGD client lightweight library"
HOMEPAGE="http://miniupnp.free.fr/"
SRC_URI="http://miniupnp.free.fr/files/${P}.tar.gz"
#LICENSE="Copyright (c) 2005-2008, Thomas BERNARD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="python"
DEPEND=""
RDEPEND="${DEPEND}"

src_compile() {
	emake || die "emake c library failed"
	use python && emake pythonmodule || die "emake python module failed"
}

src_install() {
	install -d "${D}/usr/bin" || die "failed to create usr/bin image folder"
	emake PREFIX="${D}" install \
		|| die "emake install c library failed"
	use python && distutils_src_install
}
