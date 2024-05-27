

from scapy.all import *

TYPE_FEATURES = 0x1212
TYPE_IPV4 = 0x0800

class Features(Packet):
    name = "Features"
    fields_desc = [
        ShortField("pktCount", 0),
        ShortField("byteCount", 0),
        ShortField("maxByteCount", 0),
        ShortField("minByteCount", 0),
        ShortField("etherType", 0)
    ]
    def mysummary(self):
        return self.sprintf("pktCount=%pktCount%, byteCount=%byteCount%, maxByteCount=%maxByteCount%, minByteCount=%minByteCount%")


bind_layers(Ether, Features, type=TYPE_FEATURES)
bind_layers(Features, IP, etherType=TYPE_IPV4)
