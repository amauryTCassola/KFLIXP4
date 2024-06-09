#define CLUSTER_NUMBER 10

register<bit<TIMESTAMP_WIDTH>>(CLUSTER_NUMBER) registerDistances;

action actionResetDistances() {
    registerDistances.write(0, (bit<TIMESTAMP_WIDTH>)0);
    registerDistances.write(1, (bit<TIMESTAMP_WIDTH>)0);
    registerDistances.write(2, (bit<TIMESTAMP_WIDTH>)0);
    registerDistances.write(3, (bit<TIMESTAMP_WIDTH>)0);
    registerDistances.write(4, (bit<TIMESTAMP_WIDTH>)0);
    registerDistances.write(5, (bit<TIMESTAMP_WIDTH>)0);
    registerDistances.write(6, (bit<TIMESTAMP_WIDTH>)0);
    registerDistances.write(7, (bit<TIMESTAMP_WIDTH>)0);
    registerDistances.write(8, (bit<TIMESTAMP_WIDTH>)0);
    registerDistances.write(9, (bit<TIMESTAMP_WIDTH>)0);
}

table tableResetDistances {
    actions = {
        actionResetDistances();
    }
    
    default_action = actionResetDistances();
}

action actionClassify(
    bit<BOOLEAN> cluster0,
    bit<BOOLEAN> cluster1,
    bit<BOOLEAN> cluster2,
    bit<BOOLEAN> cluster3,
    bit<BOOLEAN> cluster4,
    bit<BOOLEAN> cluster5,
    bit<BOOLEAN> cluster6,
    bit<BOOLEAN> cluster7,
    bit<BOOLEAN> cluster8,
    bit<BOOLEAN> cluster9
    ) {
        bit<BOOLEAN> result;
        result = 0;

        bit<TIMESTAMP_WIDTH> clus0Dist;
        bit<TIMESTAMP_WIDTH> clus1Dist;
        bit<TIMESTAMP_WIDTH> clus2Dist;
        bit<TIMESTAMP_WIDTH> clus3Dist;
        bit<TIMESTAMP_WIDTH> clus4Dist;
        bit<TIMESTAMP_WIDTH> clus5Dist;
        bit<TIMESTAMP_WIDTH> clus6Dist;
        bit<TIMESTAMP_WIDTH> clus7Dist;
        bit<TIMESTAMP_WIDTH> clus8Dist;
        bit<TIMESTAMP_WIDTH> clus9Dist;

        registerDistances.read(clus0Dist, 0);
        registerDistances.read(clus1Dist, 1);
        registerDistances.read(clus2Dist, 2);
        registerDistances.read(clus3Dist, 3);
        registerDistances.read(clus4Dist, 4);
        registerDistances.read(clus5Dist, 5);
        registerDistances.read(clus6Dist, 6);
        registerDistances.read(clus7Dist, 7);
        registerDistances.read(clus8Dist, 8);
        registerDistances.read(clus9Dist, 9);

        if(
            clus0Dist <= clus1Dist &&
            clus0Dist <= clus2Dist &&
            clus0Dist <= clus3Dist &&
            clus0Dist <= clus4Dist &&
            clus0Dist <= clus5Dist &&
            clus0Dist <= clus6Dist &&
            clus0Dist <= clus7Dist &&
            clus0Dist <= clus8Dist &&
            clus0Dist <= clus9Dist
         ) {
            result = cluster0;
            hdr.features.cluster = (bit<16>)0;
         } else {
            if(
                clus1Dist <= clus2Dist &&
                clus1Dist <= clus3Dist &&
                clus1Dist <= clus4Dist &&
                clus1Dist <= clus5Dist &&
                clus1Dist <= clus6Dist &&
                clus1Dist <= clus7Dist &&
                clus1Dist <= clus8Dist &&
                clus1Dist <= clus9Dist
            ) {
                result = cluster1;
                hdr.features.cluster = (bit<16>)1;
            } else {
                if(
                    clus2Dist <= clus3Dist &&
                    clus2Dist <= clus4Dist &&
                    clus2Dist <= clus5Dist &&
                    clus2Dist <= clus6Dist &&
                    clus2Dist <= clus7Dist &&
                    clus2Dist <= clus8Dist &&
                    clus2Dist <= clus9Dist
                ) {
                    result = cluster2;
                    hdr.features.cluster = (bit<16>)2;
                } else {
                    if(
                        clus3Dist <= clus4Dist &&
                        clus3Dist <= clus5Dist &&
                        clus3Dist <= clus6Dist &&
                        clus3Dist <= clus7Dist &&
                        clus3Dist <= clus8Dist &&
                        clus3Dist <= clus9Dist
                    ) {
                        result = cluster3;
                        hdr.features.cluster = (bit<16>)3;
                    } else {
                        if (
                            clus4Dist <= clus5Dist &&
                            clus4Dist <= clus6Dist &&
                            clus4Dist <= clus7Dist &&
                            clus4Dist <= clus8Dist &&
                            clus4Dist <= clus9Dist
                        ) {
                            result = cluster4;
                            hdr.features.cluster = (bit<16>)4;
                        } else {
                            if (
                                clus5Dist <= clus6Dist &&
                                clus5Dist <= clus7Dist &&
                                clus5Dist <= clus8Dist &&
                                clus5Dist <= clus9Dist
                            ) {
                                result = cluster5;
                                hdr.features.cluster = (bit<16>)5;
                            } else {
                                if (
                                    clus6Dist <= clus7Dist &&
                                    clus6Dist <= clus8Dist &&
                                    clus6Dist <= clus9Dist
                                ) {
                                    result = cluster6;
                                    hdr.features.cluster = (bit<16>)6;
                                } else {
                                    if(
                                        clus7Dist <= clus8Dist &&
                                        clus7Dist <= clus9Dist
                                    ) {
                                        result = cluster7;
                                        hdr.features.cluster = (bit<16>)7;
                                    } else {
                                        if(clus8Dist <= clus9Dist){
                                            result = cluster8;
                                            hdr.features.cluster = (bit<16>)8;
                                        } else {
                                            result = cluster9;
                                            hdr.features.cluster = (bit<16>)9;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
         }

         hdr.features.isVideo = (bit<16>)result;
}

table tableClassifier {
    actions = {
        actionClassify;
    }
    key = {
        meta.pktCount: ternary;
    }
    default_action = actionClassify(0,0,0,0,0,0,0,0,0,0);
}

action actionCalcPktCountDists(
    bit<TIMESTAMP_WIDTH> cluster0,
    bit<TIMESTAMP_WIDTH> cluster1,
    bit<TIMESTAMP_WIDTH> cluster2,
    bit<TIMESTAMP_WIDTH> cluster3,
    bit<TIMESTAMP_WIDTH> cluster4,
    bit<TIMESTAMP_WIDTH> cluster5,
    bit<TIMESTAMP_WIDTH> cluster6,
    bit<TIMESTAMP_WIDTH> cluster7,
    bit<TIMESTAMP_WIDTH> cluster8,
    bit<TIMESTAMP_WIDTH> cluster9
) {

    bit<FEATURE_WIDTH> feature;
    registerPktCount.read(feature, meta.hashKey);
    bit<TIMESTAMP_WIDTH> featPadded;
    featPadded = (bit<TIMESTAMP_WIDTH>) feature;

    bit<TIMESTAMP_WIDTH> clus0Dist;
    bit<TIMESTAMP_WIDTH> clus1Dist;
    bit<TIMESTAMP_WIDTH> clus2Dist;
    bit<TIMESTAMP_WIDTH> clus3Dist;
    bit<TIMESTAMP_WIDTH> clus4Dist;
    bit<TIMESTAMP_WIDTH> clus5Dist;
    bit<TIMESTAMP_WIDTH> clus6Dist;
    bit<TIMESTAMP_WIDTH> clus7Dist;
    bit<TIMESTAMP_WIDTH> clus8Dist;
    bit<TIMESTAMP_WIDTH> clus9Dist;

    registerDistances.read(clus0Dist, 0);
    registerDistances.read(clus1Dist, 1);
    registerDistances.read(clus2Dist, 2);
    registerDistances.read(clus3Dist, 3);
    registerDistances.read(clus4Dist, 4);
    registerDistances.read(clus5Dist, 5);
    registerDistances.read(clus6Dist, 6);
    registerDistances.read(clus7Dist, 7);
    registerDistances.read(clus8Dist, 8);
    registerDistances.read(clus9Dist, 9);

    clus0Dist = clus0Dist + ((featPadded - cluster0)*(featPadded - cluster0));
    clus1Dist = clus1Dist + ((featPadded - cluster1)*(featPadded - cluster1));
    clus2Dist = clus2Dist + ((featPadded - cluster2)*(featPadded - cluster2));
    clus3Dist = clus3Dist + ((featPadded - cluster3)*(featPadded - cluster3));
    clus4Dist = clus4Dist + ((featPadded - cluster4)*(featPadded - cluster4));
    clus5Dist = clus5Dist + ((featPadded - cluster5)*(featPadded - cluster5));
    clus6Dist = clus6Dist + ((featPadded - cluster6)*(featPadded - cluster6));
    clus7Dist = clus7Dist + ((featPadded - cluster7)*(featPadded - cluster7));
    clus8Dist = clus8Dist + ((featPadded - cluster8)*(featPadded - cluster8));
    clus9Dist = clus9Dist + ((featPadded - cluster9)*(featPadded - cluster9));

    registerDistances.write(0, clus0Dist);
    registerDistances.write(1, clus1Dist);
    registerDistances.write(2, clus2Dist);
    registerDistances.write(3, clus3Dist);
    registerDistances.write(4, clus4Dist);
    registerDistances.write(5, clus5Dist);
    registerDistances.write(6, clus6Dist);
    registerDistances.write(7, clus7Dist);
    registerDistances.write(8, clus8Dist);
    registerDistances.write(9, clus9Dist);
}

table tableCalcPktCountDists {
    actions = {
        actionCalcPktCountDists;
    }
    key = {
        meta.pktCount: ternary;
    }
    default_action = actionCalcPktCountDists(0,0,0,0,0,0,0,0,0,0);
}