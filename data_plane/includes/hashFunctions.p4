//HASH KEY CALCULATION
action actionCalculateHashKey() {
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

table tableCalculateHashKey {
    actions = {
        actionCalculateHashKey();
    }
    default_action = actionCalculateHashKey();
}

//SRC ADDRESS ===========================================================
register<ip4Addr_t>(HASH_TABLE_ENTRIES) registerSrcAddr;
//The 5-tuple (srcAddr, dstAddr, srcPort, dstPort, Protocol) is kept in registers
//to be able to undo the hash and check for collisions

action actionUpdateSrcAddr() {
    //Saves the value in the metadata to check for collisions later in the flow
    registerSrcAddr.read(meta.srcAddr, meta.hashKey);
    //Overwrites the srcAddress in the register
    registerSrcAddr.write(meta.hashKey, hdr.ipv4.srcAddr);
}

table tableUpdateSrcAddr { //table has no key, which means the default action will always be executed
    actions = {
        actionUpdateSrcAddr();
    }
    default_action = actionUpdateSrcAddr();
}

//DST ADDRESS ===========================================================
register<ip4Addr_t>(HASH_TABLE_ENTRIES) registerDstAddr;

action actionUpdateDstAddr() {
    registerDstAddr.read(meta.dstAddr, meta.hashKey);
        registerDstAddr.write(meta.hashKey, hdr.ipv4.dstAddr);
}

table tableUpdateDstAddr {
    actions = {
        actionUpdateDstAddr();
    }
    default_action = actionUpdateDstAddr();
}

//SRC PORT ===========================================================
register<port_t>(HASH_TABLE_ENTRIES) registerSrcPort;

action actionUpdateSrcPort() {
    registerSrcPort.read(meta.srcPort, meta.hashKey);
    registerSrcPort.write(meta.hashKey, hdr.tcp.srcPort);
}

table tableUpdateSrcPort {
    actions = {
        actionUpdateSrcPort();
    }
    default_action = actionUpdateSrcPort();
}

//DST PORT ===========================================================
register<port_t>(HASH_TABLE_ENTRIES) registerDstPort;

action actionUpdateDstPort() {
    registerDstPort.read(meta.dstPort, meta.hashKey);
    registerDstPort.write(meta.hashKey, hdr.tcp.dstPort);
}

table tableUpdateDstPort {
    actions = {
        actionUpdateDstPort();
    }
    default_action = actionUpdateDstPort();
}

//PROTOCOL ===========================================================
register<protocol_t>(HASH_TABLE_ENTRIES) registerProtocol;

action actionUpdateProtocol() {
    registerProtocol.read(meta.protocol, meta.hashKey);
    registerProtocol.write(meta.hashKey, hdr.ipv4.protocol);
}

table tableUpdateProtocol {
    actions = {
        actionUpdateProtocol();
    }
    default_action = actionUpdateProtocol();
}

//MATCH ==============================================================
action actionSetMatch(inout metadata _meta) {
    _meta.matchFlag = 1;
}

table tableSetMatch {
    actions = {
        actionSetMatch(meta);
    }
    
    default_action = actionSetMatch(meta);
}