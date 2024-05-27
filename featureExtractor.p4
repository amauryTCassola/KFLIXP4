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
register<bit<16>>(HASH_TABLE_ENTRIES) registerByteCount;
register<bit<16>>(HASH_TABLE_ENTRIES) registerMaxByteCount;
register<bit<16>>(HASH_TABLE_ENTRIES) registerMinByteCount;

action actionResetByteCount() {
    registerByteCount.write(meta.hashKey, (bit<16>)hdr.ipv4.totalLen);
    registerMaxByteCount.write(meta.hashKey, (bit<16>)hdr.ipv4.totalLen);
    registerMinByteCount.write(meta.hashKey, (bit<16>)hdr.ipv4.totalLen);

    hdr.features.byteCount = (bit<16>)hdr.ipv4.totalLen;
    hdr.features.maxByteCount = (bit<16>)hdr.ipv4.totalLen;
    hdr.features.minByteCount = (bit<16>)hdr.ipv4.totalLen;
}

action actionIncrementByteCount() {
    bit<16> tmpCount;
    registerByteCount.read(tmpCount, meta.hashKey);

    bit<16> max_byte_count;
    registerMaxByteCount.read(max_byte_count, meta.hashKey);

    bit<16> min_byte_count;
    registerMinByteCount.read(min_byte_count, meta.hashKey);
    
    bit<16> update_value;
    
    tmpCount = tmpCount + (bit<16>)hdr.ipv4.totalLen;

    registerByteCount.write(meta.hashKey, tmpCount);
    hdr.features.byteCount = tmpCount;

    if(hdr.ipv4.totalLen > max_byte_count)
      update_value = hdr.ipv4.totalLen;
    else
      update_value = max_byte_count;

    registerMaxByteCount.write(meta.hashKey, update_value);
    hdr.features.maxByteCount = update_value;

    if(hdr.ipv4.totalLen < min_byte_count)
      update_value = hdr.ipv4.totalLen;
    else
      update_value = min_byte_count;

    registerMinByteCount.write(meta.hashKey, update_value);
    hdr.features.minByteCount = update_value;
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