# DISTRO_TO_BUILD-builder
# Copyright (C) 2015-2021 Intel Corporation
#
# SPDX-License-Identifier: GPL-2.0-only
#

FROM crops/yocto:DISTRO_TO_BUILD-base

USER root
COPY distro-entry.sh runbitbake.py /usr/local/bin/
RUN chown  yoctouser:yoctouser /usr/local/bin/runbitbake.py && \
    chmod +x /usr/local/bin/runbitbake.py && \
    chmod +x /usr/local/bin/distro-entry.sh

USER yoctouser

WORKDIR /home/yoctouser
ENTRYPOINT ["/usr/local/bin/distro-entry.sh", "/usr/local/bin/runbitbake.py"]
