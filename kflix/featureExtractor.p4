//PACKET COUNT ===========================================================
register<bit<FEATURE_WIDTH>>(HASH_TABLE_ENTRIES) registerPktCount;

action actionResetPktCount() {
    registerPktCount.write(meta.hashKey, (bit<FEATURE_WIDTH>)1);
    meta.pktCount = 1;
    hdr.features.pktCount = 1;
}

//Just loads the packet count (not counting the current packet)
//from the register to be used by the IAT mean calculations
action actionLoadPktCount() {
    bit<FEATURE_WIDTH> pktCount;
    registerPktCount.read(pktCount, meta.hashKey);
    meta.pktCount = pktCount;
}

action actionIncrementPktCount() {
    bit<FEATURE_WIDTH> tmpCount;
    registerPktCount.read(tmpCount, meta.hashKey);
    
    tmpCount = tmpCount + 1;

    registerPktCount.write(meta.hashKey, tmpCount);
    meta.pktCount = tmpCount;
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

table tableLoadPktCount {
    actions = {
        actionLoadPktCount();
    }
    
    default_action = actionLoadPktCount();
}

//BYTE COUNT ==========================================================
register<bit<FEATURE_WIDTH>>(HASH_TABLE_ENTRIES) registerSumPktLength;
register<bit<FEATURE_WIDTH>>(HASH_TABLE_ENTRIES) registerMaxPktLength;
register<bit<FEATURE_WIDTH>>(HASH_TABLE_ENTRIES) registerMinPktLength;
register<bit<FEATURE_WIDTH>>(HASH_TABLE_ENTRIES) registerLengthApproxMean;
register<bit<FEATURE_WIDTH>>(HASH_TABLE_ENTRIES) registerLengthApproxSum;

action actionResetPktLength() {
    registerSumPktLength.write(meta.hashKey, standard_metadata.packet_length);
    registerMaxPktLength.write(meta.hashKey, standard_metadata.packet_length);
    registerMinPktLength.write(meta.hashKey, standard_metadata.packet_length);
    registerLengthApproxSum.write(meta.hashKey, standard_metadata.packet_length);
    registerLengthApproxMean.write(meta.hashKey, standard_metadata.packet_length);

    hdr.features.pktLenFeatures.pktLength = standard_metadata.packet_length;
    hdr.features.pktLenFeatures.maxPktLength = standard_metadata.packet_length;
    hdr.features.pktLenFeatures.minPktLength = standard_metadata.packet_length;
    hdr.features.pktLenFeatures.pktLengthApproxSum = standard_metadata.packet_length;
    hdr.features.pktLenFeatures.pktLengthApproxMean = standard_metadata.packet_length;
}

action actionIncrementPktLength() {
    bit<FEATURE_WIDTH> lengthSum;

    registerSumPktLength.read(lengthSum, meta.hashKey);
    lengthSum = lengthSum + standard_metadata.packet_length;
    registerSumPktLength.write(meta.hashKey, lengthSum);
    hdr.features.pktLenFeatures.pktLength = lengthSum;


    bit<FEATURE_WIDTH> maxLength;
    registerMaxPktLength.read(maxLength, meta.hashKey);

    bit<FEATURE_WIDTH> minLength;
    registerMinPktLength.read(minLength, meta.hashKey);
    
    bit<FEATURE_WIDTH> update_value;

    if(standard_metadata.packet_length > maxLength)
      update_value = standard_metadata.packet_length;
    else
      update_value = maxLength;

    registerMaxPktLength.write(meta.hashKey, update_value);
    hdr.features.pktLenFeatures.maxPktLength = update_value;

    if(standard_metadata.packet_length < minLength)
      update_value = standard_metadata.packet_length;
    else
      update_value = minLength;

    registerMinPktLength.write(meta.hashKey, update_value);
    hdr.features.pktLenFeatures.minPktLength = update_value;



    bit<FEATURE_WIDTH> lengthApproxSum;
    bit<FEATURE_WIDTH> lengthApproxMean;
    registerLengthApproxSum.read(lengthApproxSum, meta.hashKey);
    registerLengthApproxMean.read(lengthApproxMean, meta.hashKey);

    approximate_mean(
        (bit<TIMESTAMP_WIDTH>)lengthSum, 
        (bit<TIMESTAMP_WIDTH>)lengthApproxSum, 
        (bit<TIMESTAMP_WIDTH>)lengthApproxMean, 
        (bit<TIMESTAMP_WIDTH>)standard_metadata.packet_length
    );

    lengthApproxSum = (bit<FEATURE_WIDTH>)meta.return_approx_sum;
    lengthApproxMean = (bit<FEATURE_WIDTH>)meta.return_approx_mean;

    registerLengthApproxSum.write(meta.hashKey, lengthApproxSum);
    registerLengthApproxMean.write(meta.hashKey, lengthApproxMean);

    hdr.features.pktLenFeatures.pktLengthApproxSum = lengthApproxSum;
    hdr.features.pktLenFeatures.pktLengthApproxMean = lengthApproxMean;
}

table tableResetPktLength {
    actions = {
        actionResetPktLength();
    }
    
    default_action = actionResetPktLength();
}

table tableIncrementPktLength {
    actions = {
        actionIncrementPktLength();
    }
    
    default_action = actionIncrementPktLength();
}


//IAT ==========================================================
register<bit<TIMESTAMP_WIDTH>>(HASH_TABLE_ENTRIES) registerFlowStart;
register<bit<TIMESTAMP_WIDTH>>(HASH_TABLE_ENTRIES) registerLastPktTS;

register<bit<TIMESTAMP_WIDTH>>(HASH_TABLE_ENTRIES) registerSumIat;
register<bit<TIMESTAMP_WIDTH>>(HASH_TABLE_ENTRIES) registerMaxIat;
register<bit<TIMESTAMP_WIDTH>>(HASH_TABLE_ENTRIES) registerMinIat;
register<bit<TIMESTAMP_WIDTH>>(HASH_TABLE_ENTRIES) registerIatApproxMean;
register<bit<TIMESTAMP_WIDTH>>(HASH_TABLE_ENTRIES) registerIatApproxSum;

action actionIncrementIat() {
    bit<TIMESTAMP_WIDTH> curIat;
    bit<TIMESTAMP_WIDTH> lastPktTS;
    bit<TIMESTAMP_WIDTH> iatSum;
    bit<TIMESTAMP_WIDTH> iatMax;
    bit<TIMESTAMP_WIDTH> iatMin;
    bit<TIMESTAMP_WIDTH> iatApproxSum;
    bit<TIMESTAMP_WIDTH> iatApproxMean;

    registerLastPktTS.read(lastPktTS, meta.hashKey);
    registerSumIat.read(iatSum, meta.hashKey);
    registerMaxIat.read(iatMax, meta.hashKey);
    registerMinIat.read(iatMin, meta.hashKey);
    registerIatApproxSum.read(iatApproxSum, meta.hashKey);
    registerIatApproxMean.read(iatApproxMean, meta.hashKey);

    curIat = standard_metadata.ingress_global_timestamp - lastPktTS;

    iatSum = curIat + iatSum;
    registerSumIat.write(meta.hashKey, iatSum);
    hdr.features.iatFeatures.sumIat = (bit<TIMESTAMP_HEADER_WIDTH>)iatSum;
    
    bit<TIMESTAMP_WIDTH> update_value;
    if(curIat > iatMax){
        update_value = curIat;
    } else {
        update_value = iatMax;
    }
    registerMaxIat.write(meta.hashKey, update_value);
    hdr.features.iatFeatures.maxIat = (bit<TIMESTAMP_HEADER_WIDTH>)update_value;

    if(iatMin == 0 || curIat < iatMin){
        update_value = curIat;
    } else {
        update_value = iatMin;
    }
    registerMinIat.write(meta.hashKey, update_value);
    hdr.features.iatFeatures.minIat = (bit<TIMESTAMP_HEADER_WIDTH>)update_value;

    approximate_mean(
        (bit<TIMESTAMP_WIDTH>)iatSum, 
        (bit<TIMESTAMP_WIDTH>)iatApproxSum, 
        (bit<TIMESTAMP_WIDTH>)iatApproxMean, 
        (bit<TIMESTAMP_WIDTH>)curIat
    );

    iatApproxSum = (bit<TIMESTAMP_WIDTH>)meta.return_approx_sum;
    iatApproxMean = (bit<TIMESTAMP_WIDTH>)meta.return_approx_mean;

    registerIatApproxSum.write(meta.hashKey, iatApproxSum);
    registerIatApproxMean.write(meta.hashKey, iatApproxMean);

    hdr.features.iatFeatures.iatApproxSum = (bit<TIMESTAMP_HEADER_WIDTH>)iatApproxSum;
    hdr.features.iatFeatures.iatApproxMean = (bit<TIMESTAMP_HEADER_WIDTH>)iatApproxMean;
    
    registerLastPktTS.write(meta.hashKey, standard_metadata.ingress_global_timestamp);
}

action actionResetIat() {

    registerFlowStart.write(meta.hashKey, standard_metadata.ingress_global_timestamp);
    registerLastPktTS.write(meta.hashKey, standard_metadata.ingress_global_timestamp);

    registerSumIat.write(meta.hashKey, 0);
    registerMinIat.write(meta.hashKey, 0);
    registerMaxIat.write(meta.hashKey, 0);
    registerIatApproxSum.write(meta.hashKey, 0);
    registerIatApproxMean.write(meta.hashKey, 0);

    hdr.features.iatFeatures.sumIat = 0;
    hdr.features.iatFeatures.minIat = 0;
    hdr.features.iatFeatures.maxIat = 0;
    hdr.features.iatFeatures.iatApproxSum = 0;
    hdr.features.iatFeatures.iatApproxMean = 0;
}

table tableResetIat {
    actions = {
        actionResetIat();
    }
    
    default_action = actionResetIat();
}

table tableIncrementIat {
    actions = {
        actionIncrementIat();
    }
    
    default_action = actionIncrementIat();
}