# SSH into Raspberry PI

Makes the assumption that you have enabled ssh when [flushing the drive](./os-flushing.md).

 - Find the device's IP address

    ```sh
    # Find MAC address
    netstat -r

    # grep for IP address
    netstat -nr | grep "mac:add:re:ss"
    ```

    This Method is a bit cumbersome, and a better alternative should
    be found.


 - ssh

    ```sh
    # ssh into device, pswd is usually "ubuntu"
    ssh ubuntu@192.168.0.xx
    ```
