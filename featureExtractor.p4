//PACKET COUNT ===========================================================
register<bit<16>>(HASH_TABLE_ENTRIES) registerPktCount;

action actionResetPktCount(inout headers hdr, in metadata meta) {
    registerPktCount[meta.hashKey] = 1;
    hdr.features.pktCount = 1;
}

action actionIncrementPktCount(inout headers hdr, in metadata meta) {
    registerPktCount[meta.hashKey] += 1;
    hdr.features.pktCount += 1;
}

//BYTE COUNT ==========================================================
register<bit<32>>(HASH_TABLE_ENTRIES) registerByteCount;

action actionResetByteCount(in headers hdr, in metadata meta) {
    registerByteCount[meta.hashKey] = hdr.ipv4.totalLen;
    hdr.features.byteCount = hdr.ipv4.totalLen;
}

action actionIncrementByteCount(in headers hdr, in metadata meta) {
    registerByteCount[meta.hashKey] += hdr.ipv4.totalLen;
    hdr.features.byteCount += hdr.ipv4.totalLen;
}