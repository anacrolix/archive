# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#EAPI=0
inherit eutils subversion
DESCRIPTION="A parsimonious audio player in GTK+."

HOMEPAGE="http://eruanno.net/"

#SRC_URI="ftp://foo.bar.com/${P}.tar.gz"
ESVN_REPO_URI="https://stupidape.dyndns.org/svn/miniplay/trunk"

LICENSE=""

SLOT="0"

KEYWORDS="~x86 ~amd64"

IUSE="hardy"

#RESTRICT="strip"

DEPEND="
	media-libs/gstreamer
	>=x11-libs/gtk+-2
	hardy? ( >=dev-libs/glib-2.18.1 )
	!hardy? ( dev-libs/glib )
	x11-libs/libnotify
"

RDEPEND="${DEPEND}"

# Source directory; the dir where the sources can be found (automatically
# unpacked) inside ${WORKDIR}.  The default value for S is ${WORKDIR}/${P}
# If you don't need to change it, leave the S= line out of the ebuild
# to keep it tidy.
#S="${WORKDIR}/${P}"

src_compile() {
	autoreconf --install --force
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
