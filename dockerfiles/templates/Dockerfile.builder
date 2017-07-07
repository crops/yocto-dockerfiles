# DISTRO_TO_BUILD-builder
# Copyright (C) 2015-2017 Intel Corporation
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

FROM crops/yocto:DISTRO_TO_BUILD-base

USER root
COPY runbitbake.py /usr/local/bin
RUN chown  yoctouser:yoctouser /usr/local/bin/runbitbake.py && \
    chmod +x /usr/local/bin/runbitbake.py

USER yoctouser

WORKDIR /home/yoctouser
ENTRYPOINT ["/usr/local/bin/runbitbake.py"]
