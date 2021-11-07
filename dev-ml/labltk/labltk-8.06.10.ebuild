# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit findlib

DESCRIPTION="OCaml interface to the Tcl/Tk GUI framework"
HOMEPAGE="https://garrigue.github.io/labltk/"
SRC_URI="https://github.com/garrigue/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-warnings.patch.bz2"

LICENSE="QPL-1.0 LGPL-2"
SLOT="0/${PV}"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="+ocamlopt X"

RDEPEND="dev-lang/tk:=
	>=dev-lang/ocaml-4.11:=[ocamlopt?,X(+)?]"
DEPEND="${RDEPEND}
	dev-ml/findlib
"

PATCHES=(
	"${FILESDIR}/findlib.patch"
	"${WORKDIR}"/${P}-warnings.patch
)

src_prepare() {
	has_version "dev-lang/ocaml:0/4.11" && \
		eapply "${FILESDIR}"/${P}-this-expression-has-type.patch
	default
}

src_configure() {
	./configure --use-findlib --verbose $(usex X "--tk-x11" "--tk-no-x11") || die "configure failed!"
}

src_compile() {
	emake -j1
	use ocamlopt && emake -j1 opt
}

src_install() {
	findlib_src_preinst
	dodir /usr/bin
	emake \
		INSTALLDIR="${D}/$(ocamlc -where)/labltk" \
		INSTALLBINDIR="${ED}/usr/bin/" \
		install
	dodoc Changes README.mlTk
}
