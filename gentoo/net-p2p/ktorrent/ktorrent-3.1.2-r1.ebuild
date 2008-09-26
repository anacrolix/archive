# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

NEED_KDE="4.2"
inherit versionator kde4overlay-base

# Install to KDEDIR rather than /usr, to slot properly.
PREFIX="${KDEDIR}"

DESCRIPTION="A BitTorrent program for KDE."
HOMEPAGE="http://ktorrent.org/"
SRC_URI="http://ktorrent.org/downloads/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS=""
SLOT="4.2"
IUSE="+bwscheduler +infowidget +ipfilter +logviewer +scanfolder +search +stats +upnp +webinterface +zeroconf +mediaplayer"

DEPEND="dev-libs/gmp
	app-crypt/qca:2"
RDEPEND="${DEPEND}
	infowidget? ( >=dev-libs/geoip-1.4.4 )
	ipfilter? (
		|| ( kde-base/kdebase-kioslaves:${SLOT}
			kde-base/kdelibs:${SLOT} ) )
	zeroconf? ( kde-base/kdnssd:${SLOT} )"
		#|| ( kde-base/kdnssd:${SLOT}
		#	kde-base/kdenetwork:${SLOT} ) )
		# these deps are broken :)
LANGS="ar be bg ca da de el en_GB eo es et eu fi fr ga gl hu it ja km lt nb nds nl nn
oc pl pt pt_BR ru se sk sr sv tr uk zh_CN zh_TW"

for X in ${LANGS}; do
	IUSE="${IUSE} linguas_${X}"
done

src_compile() {
	comment_all_add_subdirectory po/ || die "sed to remove all linguas failed."

	epatch "${FILESDIR}"/ktorrent-kde4.2.patch

	local X
	for X in ${LANGS}; do
		if use linguas_${X}; then
			sed -i -e "/add_subdirectory(\s*${X}\s*)\s*$/ s/^#DONOTCOMPILE //" \
				po/CMakeLists.txt || die "sed to uncomment ${lang} failed."
		fi
	done

	mycmakeargs="${mycmakeargs}
		-DCMAKE_INSTALL_PREFIX=${PREFIX}
		-DENABLE_DHT_SUPPORT=ON
		$(cmake-utils_use_enable bwscheduler BWSCHEDULER_PLUGIN)
		$(cmake-utils_use_enable infowidget INFOWIDGET_PLUGIN)
		$(cmake-utils_use_with infowidget SYSTEM_GEOIP)
		$(cmake-utils_use_enable ipfilter IPFILTER_PLUGIN)
		$(cmake-utils_use_enable logviewer LOGVIEWER_PLUGIN)
		$(cmake-utils_use_enable scanfolder SCANFOLDER_PLUGIN)
		$(cmake-utils_use_enable search SEARCH_PLUGIN)
		$(cmake-utils_use_enable stats STATS_PLUGIN)
		$(cmake-utils_use_enable upnp UPNP_PLUGIN)
		$(cmake-utils_use_enable webinterface WEBINTERFACE_PLUGIN)
		$(cmake-utils_use_enable zeroconf ZEROCONF_PLUGIN)
		$(cmake-utils_use_enable mediaplayer MEDIAPLAYER_PLUGIN)"
	kde4overlay-base_src_compile
}
