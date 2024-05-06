//HASH KEY CALCULATION
bit<HASH_TABLE_BIT_WIDTH> hashKey;

action tableCalculateHashKey(in headers hdr, inout metadata meta) {
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
    meta.srcAddr = registerSrcAddr[meta.hashKey];
    if (hdr.ipv4.srcAddr != registerSrcAddr[meta.hashKey]){
        //Overwrites the srcAddress in the register if necessary
        registerSrcAddr[meta.hashKey] = hdr.ipv4.srcAddr;
    }
}

//DST ADDRESS ===========================================================
register<ip4Addr_t>(HASH_TABLE_ENTRIES) registerDstAddr;

action actionUpdateDstAddr(in headers hdr, inout metadata meta) {
    meta.dstAddr = registerDstAddr[meta.hashKey];
    if (hdr.ipv4.dstAddr != registerDstAddr[meta.hashKey]){
        registerDstAddr[meta.hashKey] = hdr.ipv4.dstAddr;
    }
}

//SRC PORT ===========================================================
register<port_t>(HASH_TABLE_ENTRIES) registerSrcPort;

action actionUpdateSrcPort(in headers hdr, inout metadata meta) {
    meta.srcPort = registerSrcPort[meta.hashKey];
    if (hdr.tcp.srcPort != registerSrcPort[meta.hashKey]){
        registerSrcPort[meta.hashKey] = hdr.tcp.srcPort;
    }
}

//DST PORT ===========================================================
register<port_t>(HASH_TABLE_ENTRIES) registerDstPort;

action actionUpdateDstPort(in headers hdr, inout metadata meta) {
    meta.dstPort = registerDstPort[meta.hashKey];
    if (hdr.tcp.dstPort != registerDstPort[meta.hashKey]){
        registerDstPort[meta.hashKey] = hdr.tcp.dstPort;
    }
}

//PROTOCOL ===========================================================
register<protocol_t>(HASH_TABLE_ENTRIES) registerProtocol;

action actionUpdateProtocol(in headers hdr, inout metadata meta) {
    meta.protocol = registerProtocol[meta.hashKey];
    if (hdr.ipv4.protocol != registerProtocol[meta.hashKey]){
        registerProtocol[meta.hashKey] = hdr.ipv4.protocol;
    }
}