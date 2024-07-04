#! /usr/bin/bash
# $1 = pcap file
sudo tcpreplay -i veth0 $1