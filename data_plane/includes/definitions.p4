/* -*- P4_16 -*- */
#define HASH_TABLE_ENTRIES 65536
#define HASH_TABLE_BIT_WIDTH 32

#define FEATURE_WIDTH 32
#define TIMESTAMP_WIDTH 48

#define SHIFT_AMOUNT_WIDTH 4

#define NORMALIZED_WIDTH 10
#define DISTANCE_WIDTH 24

#define BOOLEAN 1

const bit<8> PROTO_TCP = 0x06;
const bit<8> PROTO_UDP = 0x11;

const bit<16> TYPE_IPV4 = 0x800;
const bit<16> TYPE_FEATURES = 0x1212;

typedef bit<48> macAddr_t;
typedef bit<32> ip4Addr_t;
typedef bit<16> port_t;
typedef bit<8> protocol_t;
typedef bit<9>  egressSpec_t;

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
    bit<16> windowSize;
    bit<16> checksum;
    bit<16> urgentPtr;
}

//udp header
header udp_t{
    bit<16> srcPort;
    bit<16> dstPort;
    bit<16> len;
    bit<16> checksum;
}

//classifier header
header features_t {
    bit<16> isVideo;
    bit<16> cluster;
    bit<16> etherType;
}

struct headers {
    ethernet_t  ethernet;
    features_t  features;
    ipv4_t      ipv4;
    tcp_t       tcp;
    udp_t       udp;
}

struct metadata {
    bit<HASH_TABLE_BIT_WIDTH>   hashKey;
    ip4Addr_t                   srcAddr;
    ip4Addr_t                   dstAddr;
    bit<16>                     srcPort;
    bit<16>                     dstPort;
    protocol_t                  protocol;
    bit<BOOLEAN>                matchFlag;

    bit<FEATURE_WIDTH>          pktCount;
    bit<BOOLEAN>                is_pow2;
    bit<FEATURE_WIDTH>          prev_pow2;
    bit<SHIFT_AMOUNT_WIDTH>     shift_amount;
    bit<TIMESTAMP_WIDTH>        return_approx_sum;
    bit<TIMESTAMP_WIDTH>        return_approx_mean;

    bit<NORMALIZED_WIDTH> return_normalize;
}