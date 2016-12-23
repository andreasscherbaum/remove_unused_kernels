#!/bin/bash
#
# remove unused kernel packages to clean up disk space
#
# provide a list of unused kernel packages along with the proper 'remove' command for Debian/Ubuntu
# this excludes the currently running kernel, the newest installed kernel, and dependencies
# the output is suitable to run with backticks
#
# Written by Andreas 'ads' Scherbaum <andreas@scherbaum.la>
#

removekernel () {
	local curent_kernel=$(uname -r|sed 's/-*[a-z]//g'|sed 's/-386//g')
	local kernel_pkg="linux-(image|headers|ubuntu-modules|restricted-modules)"
	local meta_pkg="${kernel_pkg}-(generic|i386|virtual|server|common|rt|xen|ec2|amd64)"
	local latest_kernel=$(LC_ALL=en_US.UTF-8 dpkg -l linux-* | awk '/^ii/{ print $2}' | egrep "linux-image-[0-9]" | tail -1 | cut -f3,4 -d"-")
	local dep_kernel=$(LC_ALL=en_US.UTF-8 apt-cache showpkg linux-image-generic | grep -A 1 'Dependencies:' | tail -n 1 | tr ' ' '\n' | grep '^linux-image' | grep -v extra | sed -e 's/linux-image-//' -e 's/-generic//')
	local remove_packages=$(dpkg -l | egrep $kernel_pkg | egrep -v "${curent_kernel}|${meta_pkg}|${latest_kernel}|${dep_kernel}" | awk '{print $2}')
	if [ -n "${remove_packages}" ]
	then
            echo "dpkg --purge" ${remove_packages}
	fi
	#aptitude purge -y $(dpkg -l | egrep $kernel_pkg | egrep -v "${curent_kernel}|${meta_pkg}|${latest_kernel}|${dep_kernel}" | awk '{print $2}')
}

removekernel

exit 0


