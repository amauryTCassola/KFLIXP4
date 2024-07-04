//PACKET COUNT ===========================================================
register<bit<FEATURE_WIDTH>>(HASH_TABLE_ENTRIES) registerPktCount;

action actionResetPktCount() {
    registerPktCount.write(meta.hashKey, (bit<FEATURE_WIDTH>)1);
    meta.pktCount = 1;
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
register<bit<FEATURE_WIDTH>>(HASH_TABLE_ENTRIES) registerMeanPktLength;
register<bit<FEATURE_WIDTH>>(HASH_TABLE_ENTRIES) registerLengthApproxSum;

action actionResetPktLength() {
    registerSumPktLength.write(meta.hashKey, standard_metadata.packet_length);
    registerMaxPktLength.write(meta.hashKey, standard_metadata.packet_length);
    registerMinPktLength.write(meta.hashKey, standard_metadata.packet_length);
    registerLengthApproxSum.write(meta.hashKey, standard_metadata.packet_length);
    registerMeanPktLength.write(meta.hashKey, standard_metadata.packet_length);
}

action actionIncrementPktLength() {
    bit<FEATURE_WIDTH> lengthSum;

    registerSumPktLength.read(lengthSum, meta.hashKey);
    lengthSum = lengthSum + standard_metadata.packet_length;
    registerSumPktLength.write(meta.hashKey, lengthSum);


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

    if(standard_metadata.packet_length < minLength)
      update_value = standard_metadata.packet_length;
    else
      update_value = minLength;

    registerMinPktLength.write(meta.hashKey, update_value);



    bit<FEATURE_WIDTH> lengthApproxSum;
    bit<FEATURE_WIDTH> lengthApproxMean;
    registerLengthApproxSum.read(lengthApproxSum, meta.hashKey);
    registerMeanPktLength.read(lengthApproxMean, meta.hashKey);

    approximate_mean(
        (bit<TIMESTAMP_WIDTH>)lengthSum, 
        (bit<TIMESTAMP_WIDTH>)lengthApproxSum, 
        (bit<TIMESTAMP_WIDTH>)lengthApproxMean, 
        (bit<TIMESTAMP_WIDTH>)standard_metadata.packet_length
    );

    lengthApproxSum = (bit<FEATURE_WIDTH>)meta.return_approx_sum;
    lengthApproxMean = (bit<FEATURE_WIDTH>)meta.return_approx_mean;

    registerLengthApproxSum.write(meta.hashKey, lengthApproxSum);
    registerMeanPktLength.write(meta.hashKey, lengthApproxMean);
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
register<bit<TIMESTAMP_WIDTH>>(HASH_TABLE_ENTRIES) registerLastPktTS;

register<bit<TIMESTAMP_WIDTH>>(HASH_TABLE_ENTRIES) registerSumIat;
register<bit<TIMESTAMP_WIDTH>>(HASH_TABLE_ENTRIES) registerMaxIat;
register<bit<TIMESTAMP_WIDTH>>(HASH_TABLE_ENTRIES) registerMinIat;
register<bit<TIMESTAMP_WIDTH>>(HASH_TABLE_ENTRIES) registerMeanIat;
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
    registerMeanIat.read(iatApproxMean, meta.hashKey);

    curIat = standard_metadata.ingress_global_timestamp - lastPktTS;

    iatSum = curIat + iatSum;
    registerSumIat.write(meta.hashKey, iatSum);
    
    bit<TIMESTAMP_WIDTH> update_value;
    if(curIat > iatMax){
        update_value = curIat;
    } else {
        update_value = iatMax;
    }
    registerMaxIat.write(meta.hashKey, update_value);

    if(iatMin == 0 || curIat < iatMin){
        update_value = curIat;
    } else {
        update_value = iatMin;
    }
    registerMinIat.write(meta.hashKey, update_value);

    approximate_mean(
        (bit<TIMESTAMP_WIDTH>)iatSum, 
        (bit<TIMESTAMP_WIDTH>)iatApproxSum, 
        (bit<TIMESTAMP_WIDTH>)iatApproxMean, 
        (bit<TIMESTAMP_WIDTH>)curIat
    );

    iatApproxSum = (bit<TIMESTAMP_WIDTH>)meta.return_approx_sum;
    iatApproxMean = (bit<TIMESTAMP_WIDTH>)meta.return_approx_mean;

    registerIatApproxSum.write(meta.hashKey, iatApproxSum);
    registerMeanIat.write(meta.hashKey, iatApproxMean);
    
    registerLastPktTS.write(meta.hashKey, standard_metadata.ingress_global_timestamp);
}

action actionResetIat() {

    registerLastPktTS.write(meta.hashKey, standard_metadata.ingress_global_timestamp);

    registerSumIat.write(meta.hashKey, 0);
    registerMinIat.write(meta.hashKey, 0);
    registerMaxIat.write(meta.hashKey, 0);
    registerIatApproxSum.write(meta.hashKey, 0);
    registerMeanIat.write(meta.hashKey, 0);
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

//FLOW DURATION ============================================================
register<bit<TIMESTAMP_WIDTH>>(HASH_TABLE_ENTRIES) registerFlowStart;
register<bit<TIMESTAMP_WIDTH>>(HASH_TABLE_ENTRIES) registerFlowDuration;

action actionResetFlowDuration() {
    registerFlowStart.write(meta.hashKey, standard_metadata.ingress_global_timestamp);

    registerFlowDuration.write(meta.hashKey, 0);
}

action actionIncrementFlowDuration() {
    bit<TIMESTAMP_WIDTH> curDuration;
    bit<TIMESTAMP_WIDTH> flowStart;

    registerFlowStart.read(flowStart, meta.hashKey);
    curDuration = standard_metadata.ingress_global_timestamp - flowStart;

    registerFlowDuration.write(meta.hashKey, curDuration);
}

table tableResetFlowDuration {
    actions = {
        actionResetFlowDuration();
    }
    
    default_action = actionResetFlowDuration();
}

table tableIncrementFlowDuration {
    actions = {
        actionIncrementFlowDuration();
    }
    
    default_action = actionIncrementFlowDuration();
}

//TCP WINDOW SIZE ==========================================================
register<bit<FEATURE_WIDTH>>(HASH_TABLE_ENTRIES) registerInitialWindow;

register<bit<FEATURE_WIDTH>>(HASH_TABLE_ENTRIES) registerSumWindow;
register<bit<FEATURE_WIDTH>>(HASH_TABLE_ENTRIES) registerMaxWindow;
register<bit<FEATURE_WIDTH>>(HASH_TABLE_ENTRIES) registerMinWindow;
register<bit<FEATURE_WIDTH>>(HASH_TABLE_ENTRIES) registerMeanWindow;
register<bit<FEATURE_WIDTH>>(HASH_TABLE_ENTRIES) registerWindowApproxSum;

action actionResetWindowSize() {
    bit<FEATURE_WIDTH> curWindow = (bit<FEATURE_WIDTH>)hdr.tcp.windowSize;

    registerInitialWindow.write(meta.hashKey, curWindow);

    registerSumWindow.write(meta.hashKey, curWindow);
    registerMaxWindow.write(meta.hashKey, curWindow);
    registerMinWindow.write(meta.hashKey, curWindow);
    registerMeanWindow.write(meta.hashKey, curWindow);
    registerWindowApproxSum.write(meta.hashKey, curWindow);
}

action actionIncrementWindowSize() {
    bit<FEATURE_WIDTH> initialWindow;
    bit<FEATURE_WIDTH> curWindow;
    bit<FEATURE_WIDTH> windowSum;
    bit<FEATURE_WIDTH> windowMax;
    bit<FEATURE_WIDTH> windowMin;
    bit<FEATURE_WIDTH> windowApproxSum;
    bit<FEATURE_WIDTH> windowApproxMean;

    registerInitialWindow.read(initialWindow, meta.hashKey);

    registerSumWindow.read(windowSum, meta.hashKey);
    registerMaxWindow.read(windowMax, meta.hashKey);
    registerMinWindow.read(windowMin, meta.hashKey);
    registerWindowApproxSum.read(windowApproxSum, meta.hashKey);
    registerMeanWindow.read(windowApproxMean, meta.hashKey);

    curWindow = (bit<FEATURE_WIDTH>)hdr.tcp.windowSize;

    windowSum = curWindow + windowSum;
    registerSumWindow.write(meta.hashKey, windowSum);
    
    bit<FEATURE_WIDTH> update_value;
    if(curWindow > windowMax){
        update_value = curWindow;
    } else {
        update_value = windowMax;
    }
    registerMaxWindow.write(meta.hashKey, update_value);

    if(curWindow < windowMin){
        update_value = curWindow;
    } else {
        update_value = windowMin;
    }
    registerMinWindow.write(meta.hashKey, update_value);

    approximate_mean(
        (bit<TIMESTAMP_WIDTH>)windowSum, 
        (bit<TIMESTAMP_WIDTH>)windowApproxSum, 
        (bit<TIMESTAMP_WIDTH>)windowApproxMean, 
        (bit<TIMESTAMP_WIDTH>)curWindow
    );

    windowApproxSum = (bit<FEATURE_WIDTH>)meta.return_approx_sum;
    windowApproxMean = (bit<FEATURE_WIDTH>)meta.return_approx_mean;

    registerWindowApproxSum.write(meta.hashKey, windowApproxSum);
    registerMeanWindow.write(meta.hashKey, windowApproxMean);

}

table tableResetWindowSize {
    actions = {
        actionResetWindowSize();
    }
    
    default_action = actionResetWindowSize();
}

table tableIncrementWindowSize {
    actions = {
        actionIncrementWindowSize();
    }
    
    default_action = actionIncrementWindowSize();
}