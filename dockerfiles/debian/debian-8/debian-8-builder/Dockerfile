# debian-8-builder
FROM rewitt/yocto:debian-8-base

USER root
# Use add for now to guarantee that the cache is invalidated without requiring
# a user to specify --no-cache.
ADD https://raw.githubusercontent.com/zedian/yocto-container-helpers/master/runbitbake.py /home/yoctouser/
RUN chown -R yoctouser /home/yoctouser/ && \
    chmod +x /home/yoctouser/runbitbake.py

USER yoctouser

WORKDIR /home/yoctouser
ENTRYPOINT ["/home/yoctouser/runbitbake.py"]
