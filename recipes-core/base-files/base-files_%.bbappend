FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append  = " \
	file://dot.profile \
"

do_install_append() {
	# Install /home/root directory and copy .profile file
	install -d ${D}/home/root
	install -c -m 0644 ${WORKDIR}/dot.profile ${D}/home/root/.profile
}
