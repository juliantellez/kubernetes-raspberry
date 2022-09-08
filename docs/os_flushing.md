# Flushing the Operating System

The Raspberry PI nodes are provisioned using [Ubuntu 22.04 LTS](https://ubuntu.com/download/raspberry-pi) for ARM

- Download and unzip the iso image from the link above

- Locate the SD card

  ```sh
  diskutil list
  ```

  <p align="center">
      <img src="./../assets/diskutil_list.png" width="500px">
  </p>

- Unmount the disk

  ```sh
  diskutil unmountDisk /dev/disk2
  ```

- dd the image into the disk

  ```
  sudo dd if=<path-to-image>/raspbian.img of=/dev/rdisk2 bs=1m
  ```

- Enable ssh 

  ```
  cd /Volumes/boot
  touch ssh
  ```

- Unmount and remove card
