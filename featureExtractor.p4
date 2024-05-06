//PACKET COUNT ===========================================================
register<bit<16>>(HASH_TABLE_ENTRIES) registerPktCount;

action actionResetPktCount(inout headers hdr, in metadata meta) {
    registerPktCount.write(meta.hashKey, (bit<16>)1);
    hdr.features.pktCount = 1;
}

action actionIncrementPktCount(inout headers hdr, in metadata meta) {
    bit<16> tmpCount;
    registerPktCount.read(tmpCount, meta.hashKey);
    
    tmpCount = tmpCount + 1;

    registerPktCount.write(meta.hashKey, tmpCount);
    hdr.features.pktCount = tmpCount;
}

//BYTE COUNT ==========================================================
register<bit<32>>(HASH_TABLE_ENTRIES) registerByteCount;

action actionResetByteCount(inout headers hdr, in metadata meta) {
    registerByteCount.write(meta.hashKey, (bit<32>)hdr.ipv4.totalLen);
    hdr.features.byteCount = (bit<32>)hdr.ipv4.totalLen;
}

action actionIncrementByteCount(inout headers hdr, in metadata meta) {
    bit<32> tmpCount;
    registerByteCount.read(tmpCount, meta.hashKey);
    
    tmpCount = tmpCount + (bit<32>)hdr.ipv4.totalLen;

    registerByteCount.write(meta.hashKey, tmpCount);
    hdr.features.byteCount = tmpCount;
}