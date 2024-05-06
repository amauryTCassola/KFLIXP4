/* -*- P4_16 -*- */
#define ETHERTYPE_IPV4 0x0800
#define ETHERTYPE_TURBOFLOW 0x081A

#define HASH_TABLE_ENTRIES 65536
#define HASH_TABLE_BIT_WIDTH 16

typedef bit<48> macAddr_t;
typedef bit<32> ip4Addr_t;
typedef bit<16> port_t;
typedef bit<8> protocol_t;

// ethernet header
header ethernet_t {
    macAddr_t dstAddr;
    macAddr_t srcAddr;
    bit<16>   etherType;
}

// ipv4 header
header ipv4_t {
    bit<4>    version;
    bit<4>    ihl;
    bit<8>    diffserv;
    bit<16>   totalLen;
    bit<16>   identification;
    bit<3>    flags;
    bit<13>   fragOffset;
    bit<8>    ttl;
    protocol_t    protocol;
    bit<16>   hdrChecksum;
    ip4Addr_t srcAddr;
    ip4Addr_t dstAddr;
}

// tcp header
header tcp_t {
    port_t srcPort;
    port_t dstPort;
    bit<32> seqNo;
    bit<32> ackNo;
    bit<4>  dataOffset;
    bit<3>  res;
    bit<3>  ecn;
    bit<6>  ctrl;
    bit<16> window;
    bit<16> checksum;
    bit<16> urgentPtr;
}

header features_t {
    bit<16> pktCount;
    bit<32> byteCount;
}

struct headers {
    ethernet_t   ethernet;
    ipv4_t       ipv4;
    tcp_t      tcp;
    features_t features;
}

struct metadata {
    bit<HASH_TABLE_BIT_WIDTH> hashKey;
    ip4Addr_t srcAddr;
    ip4Addr_t dstAddr;
    bit<16> srcPort;
    bit<16> dstPort;
    bit<1> matchFlag;
}