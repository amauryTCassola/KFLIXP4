

from scapy.all import *

TYPE_FEATURES = 0x1212
TYPE_IPV4 = 0x0800

class Features(Packet):
    name = "Features"
    fields_desc = [
        ShortField("isVideo", 0),
        ShortField("cluster", 0),
        ShortField("etherType", 0)
    ]
    def mysummary(self):
        return self.sprintf(" \
            isVideo=%isVideo%, \
            cluster=%cluster%, \
        ")


bind_layers(Ether, Features, type=TYPE_FEATURES)
bind_layers(Features, IP, etherType=TYPE_IPV4)
