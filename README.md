# wg-autoconnect-dispatcher

**DISCLAIMER: This setup is definitely not foolproof and should therefore not be used for scenarios with serious security concerns.**

Simple collection of scripts and examples that achieve the following:

* Monitor network changes via. the dispatcher of Network Manager
* If the user is not connected to the local home network, a connection to a previously specified Wireguard tunnel should be established
* The user can specify various configurations to determine whether the network is considered a local home network. For example, via the subnet or name of the wifi connection

### Required packages
* NetworkManager
* wg-tools (wg-quick is used to establish and kill wireguard connections)

### Required Files / Configuration (Examples)
* `/etc/wireguard/tunnel.conf`
    * Wireguard configuration file
* `/etc/NetworkManager/dispatcher.d/99-wg-auto`
    * Simple bash script which is executed when the network changes. The script below will be called from within this script.
* `/var/scripts/wg-auto.sh`
    * The bash script which contains the actual logic. This is used to decide whether the connection to Wireguard is established or terminated.

### Notes
Obviously, the contents of wg-auto.sh could be directly implemented in the 99-wg-auto dispatcher file.