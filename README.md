# rclonebrowser-docker

A repository for creating a docker container including RClone Browser with GUI interface.

[![](https://images.microbadger.com/badges/version/romancin/rclonebrowser.svg)](https://microbadger.com/images/romancin/rclonebrowser "Docker image version")
[![](https://images.microbadger.com/badges/image/romancin/rclonebrowser.svg)](https://microbadger.com/images/romancin/rclonebrowser "Docker image size")
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=X2CT2SWQCP74U)

You can invite me a beer if you want ;) 

This is a completely funcional Docker image with RClone Browser.

Based on Alpine Linux, which provides a very small size. 

Tested and working on Synology and QNAP, but should work on any x86_64 devices.

Instructions: 
- Map any local port to 5800 for web access
- Map any local port to 5900 for VNC access
- Map a local volume to /config (Stores configuration data)
- Map a local volume to /shared (Access media files)

Sample run command:

```bash
docker run -d --name=rclonebrowser \
-v /share/Container/rclonebrowser/config:/config \
-v /share/Container/rclonebrowser/media:/media \
-e GROUP_ID=0 -e USER_ID=0 -e TZ=Europe/Madrid \
-p 5800:5800 \
-p 5900:5900 \
romancin/rclonebrowser:latest
```
