//PACKET COUNT ===========================================================
register<bit<16>>(HASH_TABLE_ENTRIES) registerPktCount;

action actionResetPktCount() {
    registerPktCount.write(meta.hashKey, (bit<16>)1);
    hdr.features.pktCount = 1;
}

action actionIncrementPktCount() {
    bit<16> tmpCount;
    registerPktCount.read(tmpCount, meta.hashKey);
    
    tmpCount = tmpCount + 1;

    registerPktCount.write(meta.hashKey, tmpCount);
    hdr.features.pktCount = tmpCount;
}

table tableResetPktCount {
    actions = {
        actionResetPktCount();
    }
    
    default_action = actionResetPktCount();
}

table tableIncrementPktCount {
    actions = {
        actionIncrementPktCount();
    }
    
    default_action = actionIncrementPktCount();
}

//BYTE COUNT ==========================================================
register<bit<32>>(HASH_TABLE_ENTRIES) registerByteCount;

action actionResetByteCount() {
    registerByteCount.write(meta.hashKey, (bit<32>)hdr.ipv4.totalLen);
    hdr.features.byteCount = (bit<32>)hdr.ipv4.totalLen;
}

action actionIncrementByteCount() {
    bit<32> tmpCount;
    registerByteCount.read(tmpCount, meta.hashKey);
    
    tmpCount = tmpCount + (bit<32>)hdr.ipv4.totalLen;

    registerByteCount.write(meta.hashKey, tmpCount);
    hdr.features.byteCount = tmpCount;
}

table tableResetByteCount {
    actions = {
        actionResetByteCount();
    }
    
    default_action = actionResetByteCount();
}

table tableIncrementByteCount {
    actions = {
        actionIncrementByteCount();
    }
    
    default_action = actionIncrementByteCount();
}