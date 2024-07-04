#!/usr/bin/env python3
import subprocess
import argparse
import os
from scapy.all import IP, TCP, Ether, get_if_hwaddr, get_if_list, sendp
import time

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('cap_dir', type=str, help="The directory with the captures")
    args = parser.parse_args()
    cap_dir = args.cap_dir

    subprocess.run(["ifconfig", "eth0", 'mtu', '9216'])

    absCapDir = os.path.join(os.getcwd(), cap_dir)
    capFiles = os.listdir(absCapDir)

    for filename in capFiles:
        cap_file = cap_dir+'/'+filename
        subprocess.run(["./send_pcap.sh", cap_file])
        time.sleep(5)

    print("FINISHED")
