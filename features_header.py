

from scapy.all import *

TYPE_FEATURES = 0x1212
TYPE_IPV4 = 0x0800

class Features(Packet):
    name = "Features"
    fields_desc = [
        IntField("pktCount", 0),

        IntField("pktLength", 0),
        IntField("maxPktLength", 0),
        IntField("minPktLength", 0),
        IntField("pktLengthApproxSum", 0),
        IntField("pktLengthApproxMean", 0),

        LongField("sumIat", 0),
        LongField("maxIat", 0),
        LongField("minIat", 0),
        LongField("iatApproxSum", 0),
        LongField("iatApproxMean", 0),

        ShortField("etherType", 0)
    ]
    def mysummary(self):
        return self.sprintf(" \
            pktCount=%pktCount%, \
            pktLength=%pktLength%, \
            maxPktLength=%maxPktLength%, \
            minPktLength=%minPktLength%, \
            pktLengthApproxSum=%pktLengthApproxSum%, \
            pktLengthApproxMean=%pktLengthApproxMean%, \
            sumIat=%sumIat%, \
            maxIat=%maxIat%, \
            minIat=%minIat%, \
            iatApproxSum=%iatApproxSum%, \
            iatApproxMean=%iatApproxMean%, \
        ")


bind_layers(Ether, Features, type=TYPE_FEATURES)
bind_layers(Features, IP, etherType=TYPE_IPV4)
