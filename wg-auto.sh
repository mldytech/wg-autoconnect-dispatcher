#!/bin/bash

WG_INTERFACE="wg-tunnel"                            #the name of your wireguard interface (this is the name of your configuration file)
LOCAL_SUBNETS=("192.168.30.0/24" "192.168.1.0/24")   #the list of subnets which are considered local
LOCAL_SSIDS=("yourhomewifi")                        #the list of wifi ssids which are considered local

check_network() {
    CURRENT_SSID=$(iw dev | awk '/ssid/ {print $2}')
    for SSID in "${LOCAL_SSIDS[@]}"; do
        if [[ "$CURRENT_SSID" == "$SSID" ]]; then
            echo "connected to local Wi-Fi ($SSID)."
            return 0
        fi
    done

    CURRENT_IP=$(hostname -I | awk '{print $1}')
    for SUBNET in "${LOCAL_SUBNETS[@]}"; do
        if ip route | grep -q "$SUBNET"; then
            echo "connected to local network ($SUBNET)."
            return 0
        fi
    done

    if ip route | grep -q .; then
        echo "connected to foreign network."
        return 1

    else
        echo "not connected to any network. Shutting down tunnel (if up)"
        return 0
    fi
}

start_tunnel() {
    echo "starting wireguard tunnel..."
    wg-quick up $WG_INTERFACE
}

stop_tunnel() {
    echo "stopping wireguard tunnel..."
    wg-quick down $WG_INTERFACE
}

#main logic
if check_network; then
    stop_tunnel
else
    start_tunnel
fi