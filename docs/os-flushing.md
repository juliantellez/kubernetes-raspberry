# Flushing the Operating System

The Raspberry PI nodes are provisioned using [Ubuntu](https://ubuntu.com/download/raspberry-pi).

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
  sudo dd if=./ubuntu.19.10.1.img of=/dev/rdisk2 bs=1m
  ```

- Enable ssh 

  ```
  cd /Volumes/system-boot
  touch ssh
  ```
