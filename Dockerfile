#
# RcloneBrowser Dockerfile
#

FROM jlesage/baseimage-gui:ubuntu-18.04

# Define environment variables
ENV RCLONE_VERSION=current
ENV ARCH=amd64

ARG RCLONE_URL=https://github.com/kapitainsky/RcloneBrowser/releases/download/1.8.0/rclone-browser-1.8.0-a0b66c6-linux-x86_64.AppImage

# Define working directory.
WORKDIR /tmp

# Install Rclone Browser dependencies
RUN apt update && \
    apt install -y curl dbus unzip && \
    curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip && \
    unzip rclone-current-linux-amd64.zip && \
    cd rclone-*-linux-amd64 && \
    cp rclone /usr/bin/ && \
    chmod 755 /usr/bin/rclone && \
    rm -rf rclone-*-linux-amd64 && \
    curl -s -L $RCLONE_URL > /usr/bin/rclone-browser && \
    chmod u+x /usr/bin/rclone-browser

# Maximize only the main/initial window.
RUN \
    sed-patch 's/<application type="normal">/<application type="normal" title="Rclone Browser">/' \
        /etc/xdg/openbox/rc.xml

# Generate and install favicons.
RUN \
    APP_ICON_URL=https://github.com/rclone/rclone/raw/master/graphics/logo/logo_symbol/logo_symbol_color_512px.png && \
    install_app_icon.sh "$APP_ICON_URL"

# Add files.
COPY rootfs/ /
COPY VERSION /

# Set environment variables.
ENV APP_NAME="Rclone Browser" \
    S6_KILL_GRACETIME=8000

# Define mountable directories.
VOLUME ["/config"]
VOLUME ["/shared"]

# Metadata.
LABEL \
      org.label-schema.name="rclonebrowser" \
      org.label-schema.description="Docker container for RcloneBrowser" \
      org.label-schema.version="unknown" \
      org.label-schema.vcs-url="https://github.com/romancin/rclonebrowser-docker" \
      org.label-schema.schema-version="1.0"
