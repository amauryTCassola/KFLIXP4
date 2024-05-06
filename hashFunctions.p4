//HASH KEY CALCULATION
action actionCalculateHashKey(in headers hdr, inout metadata meta) {
    bit<HASH_TABLE_BIT_WIDTH> hashKey;

    hash(
        hashKey, 
        HashAlgorithm.crc16, 
        (bit<HASH_TABLE_BIT_WIDTH>)0, 
        {
            hdr.ipv4.srcAddr,
            hdr.ipv4.dstAddr,
            hdr.ipv4.protocol,
            hdr.tcp.srcPort,
            hdr.tcp.dstPort
        },
        (bit<HASH_TABLE_BIT_WIDTH>)HASH_TABLE_ENTRIES
    );

    meta.hashKey = hashKey;
}

//SRC ADDRESS ===========================================================
register<ip4Addr_t>(HASH_TABLE_ENTRIES) registerSrcAddr;
//The 5-tuple (srcAddr, dstAddr, srcPort, dstPort, Protocol) is kept in registers
//to be able to undo the hash and check for collisions

action actionUpdateSrcAddr(in headers hdr, inout metadata meta) {
    //Saves the value in the metadata to check for collisions later in the flow
    registerSrcAddr.read(meta.srcAddr, meta.hashKey);
    if (hdr.ipv4.srcAddr != meta.srcAddr){
        //Overwrites the srcAddress in the register if necessary
        registerSrcAddr.write(meta.hashKey, hdr.ipv4.srcAddr);
    }
}

//DST ADDRESS ===========================================================
register<ip4Addr_t>(HASH_TABLE_ENTRIES) registerDstAddr;

action actionUpdateDstAddr(in headers hdr, inout metadata meta) {
    registerDstAddr.read(meta.dstAddr, meta.hashKey);
    if (hdr.ipv4.dstAddr != meta.dstAddr){
        registerDstAddr.write(meta.hashKey, hdr.ipv4.dstAddr);
    }
}

//SRC PORT ===========================================================
register<port_t>(HASH_TABLE_ENTRIES) registerSrcPort;

action actionUpdateSrcPort(in headers hdr, inout metadata meta) {
    registerSrcPort.read(meta.srcPort, meta.hashKey);
    if (hdr.tcp.srcPort != meta.srcPort){
        registerSrcPort.write(meta.hashKey, hdr.tcp.srcPort);
    }
}

//DST PORT ===========================================================
register<port_t>(HASH_TABLE_ENTRIES) registerDstPort;

action actionUpdateDstPort(in headers hdr, inout metadata meta) {
    registerDstPort.read(meta.dstPort, meta.hashKey);
    if (hdr.tcp.dstPort != meta.dstPort){
        registerDstPort.write(meta.hashKey, hdr.tcp.dstPort);
    }
}

//PROTOCOL ===========================================================
register<protocol_t>(HASH_TABLE_ENTRIES) registerProtocol;

action actionUpdateProtocol(in headers hdr, inout metadata meta) {
    registerProtocol.read(meta.protocol, meta.hashKey);
    if (hdr.ipv4.protocol != meta.protocol){
        registerProtocol.write(meta.hashKey, hdr.ipv4.protocol);
    }
}