#define CLUSTER_NUMBER 4
register<bit<TIMESTAMP_WIDTH>>(CLUSTER_NUMBER) registerDistances;
action actionResetDistances() {
	registerDistances.write(0, (bit<TIMESTAMP_WIDTH>)0);
	registerDistances.write(1, (bit<TIMESTAMP_WIDTH>)0);
	registerDistances.write(2, (bit<TIMESTAMP_WIDTH>)0);
	registerDistances.write(3, (bit<TIMESTAMP_WIDTH>)0);
}

table tableResetDistances {
	actions = {
		ctionResetDistances();
	}
	default_action = actionResetDistances();
}
action actionClassify(
	bit<BOOLEAN> cluster0,
	bit<BOOLEAN> cluster1,
	bit<BOOLEAN> cluster2,
	bit<BOOLEAN> cluster3
) {
	bit<BOOLEAN> result;
	result = 0;
	bit<TIMESTAMP_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	bit<TIMESTAMP_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	bit<TIMESTAMP_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	bit<TIMESTAMP_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	if(
		 clus0Dist <= clus1Dist &&
		 clus0Dist <= clus2Dist &&
		 clus0Dist <= clus3Dist
	) {
		result = cluster0;
		hdr.features.cluster = (bit<16>)0;
	} else {
	if(
		 clus1Dist <= clus2Dist &&
		 clus1Dist <= clus3Dist
	) {
		result = cluster1;
		hdr.features.cluster = (bit<16>)1;
	} else {
	if(
		 clus2Dist <= clus3Dist
	) {
		result = cluster2;
		hdr.features.cluster = (bit<16>)2;
	} else {
		result = cluster3;
		hdr.features.cluster = (bit<16>)3;
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
	bit<TIMESTAMP_WIDTH> cluster3
) {
	bit<FEATURE_WIDTH> feature;
	registerPktCount.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;
	bit<TIMESTAMP_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + ((featPadded - cluster0)*(featPadded - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<TIMESTAMP_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + ((featPadded - cluster1)*(featPadded - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<TIMESTAMP_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + ((featPadded - cluster2)*(featPadded - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<TIMESTAMP_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + ((featPadded - cluster3)*(featPadded - cluster3));
	registerDistances.write(3, clus3Dist);


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
action actionCalcSumPktLengthDists(
	bit<TIMESTAMP_WIDTH> cluster0,
	bit<TIMESTAMP_WIDTH> cluster1,
	bit<TIMESTAMP_WIDTH> cluster2,
	bit<TIMESTAMP_WIDTH> cluster3
) {
	bit<FEATURE_WIDTH> feature;
	registerSumPktLength.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;
	bit<TIMESTAMP_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + ((featPadded - cluster0)*(featPadded - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<TIMESTAMP_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + ((featPadded - cluster1)*(featPadded - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<TIMESTAMP_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + ((featPadded - cluster2)*(featPadded - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<TIMESTAMP_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + ((featPadded - cluster3)*(featPadded - cluster3));
	registerDistances.write(3, clus3Dist);


}
table tableCalcSumPktLengthDists {
	actions = {
		actionCalcSumPktLengthDists;
	}
	key = {
		meta.pktCount: ternary;
	}
	default_action = actionCalcSumPktLengthDists(0,0,0,0,0,0,0,0,0,0);
}
action actionCalcMaxPktLengthDists(
	bit<TIMESTAMP_WIDTH> cluster0,
	bit<TIMESTAMP_WIDTH> cluster1,
	bit<TIMESTAMP_WIDTH> cluster2,
	bit<TIMESTAMP_WIDTH> cluster3
) {
	bit<FEATURE_WIDTH> feature;
	registerMaxPktLength.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;
	bit<TIMESTAMP_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + ((featPadded - cluster0)*(featPadded - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<TIMESTAMP_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + ((featPadded - cluster1)*(featPadded - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<TIMESTAMP_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + ((featPadded - cluster2)*(featPadded - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<TIMESTAMP_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + ((featPadded - cluster3)*(featPadded - cluster3));
	registerDistances.write(3, clus3Dist);


}
table tableCalcMaxPktLengthDists {
	actions = {
		actionCalcMaxPktLengthDists;
	}
	key = {
		meta.pktCount: ternary;
	}
	default_action = actionCalcMaxPktLengthDists(0,0,0,0,0,0,0,0,0,0);
}
action actionCalcMinPktLengthDists(
	bit<TIMESTAMP_WIDTH> cluster0,
	bit<TIMESTAMP_WIDTH> cluster1,
	bit<TIMESTAMP_WIDTH> cluster2,
	bit<TIMESTAMP_WIDTH> cluster3
) {
	bit<FEATURE_WIDTH> feature;
	registerMinPktLength.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;
	bit<TIMESTAMP_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + ((featPadded - cluster0)*(featPadded - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<TIMESTAMP_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + ((featPadded - cluster1)*(featPadded - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<TIMESTAMP_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + ((featPadded - cluster2)*(featPadded - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<TIMESTAMP_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + ((featPadded - cluster3)*(featPadded - cluster3));
	registerDistances.write(3, clus3Dist);


}
table tableCalcMinPktLengthDists {
	actions = {
		actionCalcMinPktLengthDists;
	}
	key = {
		meta.pktCount: ternary;
	}
	default_action = actionCalcMinPktLengthDists(0,0,0,0,0,0,0,0,0,0);
}
action actionCalcMeanPktLengthDists(
	bit<TIMESTAMP_WIDTH> cluster0,
	bit<TIMESTAMP_WIDTH> cluster1,
	bit<TIMESTAMP_WIDTH> cluster2,
	bit<TIMESTAMP_WIDTH> cluster3
) {
	bit<FEATURE_WIDTH> feature;
	registerMeanPktLength.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;
	bit<TIMESTAMP_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + ((featPadded - cluster0)*(featPadded - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<TIMESTAMP_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + ((featPadded - cluster1)*(featPadded - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<TIMESTAMP_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + ((featPadded - cluster2)*(featPadded - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<TIMESTAMP_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + ((featPadded - cluster3)*(featPadded - cluster3));
	registerDistances.write(3, clus3Dist);


}
table tableCalcMeanPktLengthDists {
	actions = {
		actionCalcMeanPktLengthDists;
	}
	key = {
		meta.pktCount: ternary;
	}
	default_action = actionCalcMeanPktLengthDists(0,0,0,0,0,0,0,0,0,0);
}
action actionCalcSumIatDists(
	bit<TIMESTAMP_WIDTH> cluster0,
	bit<TIMESTAMP_WIDTH> cluster1,
	bit<TIMESTAMP_WIDTH> cluster2,
	bit<TIMESTAMP_WIDTH> cluster3
) {
	bit<FEATURE_WIDTH> feature;
	registerSumIat.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;
	bit<TIMESTAMP_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + ((featPadded - cluster0)*(featPadded - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<TIMESTAMP_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + ((featPadded - cluster1)*(featPadded - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<TIMESTAMP_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + ((featPadded - cluster2)*(featPadded - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<TIMESTAMP_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + ((featPadded - cluster3)*(featPadded - cluster3));
	registerDistances.write(3, clus3Dist);


}
table tableCalcSumIatDists {
	actions = {
		actionCalcSumIatDists;
	}
	key = {
		meta.pktCount: ternary;
	}
	default_action = actionCalcSumIatDists(0,0,0,0,0,0,0,0,0,0);
}
action actionCalcMaxIatDists(
	bit<TIMESTAMP_WIDTH> cluster0,
	bit<TIMESTAMP_WIDTH> cluster1,
	bit<TIMESTAMP_WIDTH> cluster2,
	bit<TIMESTAMP_WIDTH> cluster3
) {
	bit<FEATURE_WIDTH> feature;
	registerMaxIat.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;
	bit<TIMESTAMP_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + ((featPadded - cluster0)*(featPadded - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<TIMESTAMP_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + ((featPadded - cluster1)*(featPadded - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<TIMESTAMP_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + ((featPadded - cluster2)*(featPadded - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<TIMESTAMP_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + ((featPadded - cluster3)*(featPadded - cluster3));
	registerDistances.write(3, clus3Dist);


}
table tableCalcMaxIatDists {
	actions = {
		actionCalcMaxIatDists;
	}
	key = {
		meta.pktCount: ternary;
	}
	default_action = actionCalcMaxIatDists(0,0,0,0,0,0,0,0,0,0);
}
action actionCalcMinIatDists(
	bit<TIMESTAMP_WIDTH> cluster0,
	bit<TIMESTAMP_WIDTH> cluster1,
	bit<TIMESTAMP_WIDTH> cluster2,
	bit<TIMESTAMP_WIDTH> cluster3
) {
	bit<FEATURE_WIDTH> feature;
	registerMinIat.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;
	bit<TIMESTAMP_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + ((featPadded - cluster0)*(featPadded - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<TIMESTAMP_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + ((featPadded - cluster1)*(featPadded - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<TIMESTAMP_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + ((featPadded - cluster2)*(featPadded - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<TIMESTAMP_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + ((featPadded - cluster3)*(featPadded - cluster3));
	registerDistances.write(3, clus3Dist);


}
table tableCalcMinIatDists {
	actions = {
		actionCalcMinIatDists;
	}
	key = {
		meta.pktCount: ternary;
	}
	default_action = actionCalcMinIatDists(0,0,0,0,0,0,0,0,0,0);
}
action actionCalcMeanIatDists(
	bit<TIMESTAMP_WIDTH> cluster0,
	bit<TIMESTAMP_WIDTH> cluster1,
	bit<TIMESTAMP_WIDTH> cluster2,
	bit<TIMESTAMP_WIDTH> cluster3
) {
	bit<FEATURE_WIDTH> feature;
	registerMeanIat.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;
	bit<TIMESTAMP_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + ((featPadded - cluster0)*(featPadded - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<TIMESTAMP_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + ((featPadded - cluster1)*(featPadded - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<TIMESTAMP_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + ((featPadded - cluster2)*(featPadded - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<TIMESTAMP_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + ((featPadded - cluster3)*(featPadded - cluster3));
	registerDistances.write(3, clus3Dist);


}
table tableCalcMeanIatDists {
	actions = {
		actionCalcMeanIatDists;
	}
	key = {
		meta.pktCount: ternary;
	}
	default_action = actionCalcMeanIatDists(0,0,0,0,0,0,0,0,0,0);
}
action actionCalcFlowDurationDists(
	bit<TIMESTAMP_WIDTH> cluster0,
	bit<TIMESTAMP_WIDTH> cluster1,
	bit<TIMESTAMP_WIDTH> cluster2,
	bit<TIMESTAMP_WIDTH> cluster3
) {
	bit<FEATURE_WIDTH> feature;
	registerFlowDuration.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;
	bit<TIMESTAMP_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + ((featPadded - cluster0)*(featPadded - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<TIMESTAMP_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + ((featPadded - cluster1)*(featPadded - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<TIMESTAMP_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + ((featPadded - cluster2)*(featPadded - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<TIMESTAMP_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + ((featPadded - cluster3)*(featPadded - cluster3));
	registerDistances.write(3, clus3Dist);


}
table tableCalcFlowDurationDists {
	actions = {
		actionCalcFlowDurationDists;
	}
	key = {
		meta.pktCount: ternary;
	}
	default_action = actionCalcFlowDurationDists(0,0,0,0,0,0,0,0,0,0);
}
action actionCalcInitialWindowDists(
	bit<TIMESTAMP_WIDTH> cluster0,
	bit<TIMESTAMP_WIDTH> cluster1,
	bit<TIMESTAMP_WIDTH> cluster2,
	bit<TIMESTAMP_WIDTH> cluster3
) {
	bit<FEATURE_WIDTH> feature;
	registerInitialWindow.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;
	bit<TIMESTAMP_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + ((featPadded - cluster0)*(featPadded - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<TIMESTAMP_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + ((featPadded - cluster1)*(featPadded - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<TIMESTAMP_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + ((featPadded - cluster2)*(featPadded - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<TIMESTAMP_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + ((featPadded - cluster3)*(featPadded - cluster3));
	registerDistances.write(3, clus3Dist);


}
table tableCalcInitialWindowDists {
	actions = {
		actionCalcInitialWindowDists;
	}
	key = {
		meta.pktCount: ternary;
	}
	default_action = actionCalcInitialWindowDists(0,0,0,0,0,0,0,0,0,0);
}
action actionCalcSumWindowDists(
	bit<TIMESTAMP_WIDTH> cluster0,
	bit<TIMESTAMP_WIDTH> cluster1,
	bit<TIMESTAMP_WIDTH> cluster2,
	bit<TIMESTAMP_WIDTH> cluster3
) {
	bit<FEATURE_WIDTH> feature;
	registerSumWindow.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;
	bit<TIMESTAMP_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + ((featPadded - cluster0)*(featPadded - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<TIMESTAMP_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + ((featPadded - cluster1)*(featPadded - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<TIMESTAMP_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + ((featPadded - cluster2)*(featPadded - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<TIMESTAMP_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + ((featPadded - cluster3)*(featPadded - cluster3));
	registerDistances.write(3, clus3Dist);


}
table tableCalcSumWindowDists {
	actions = {
		actionCalcSumWindowDists;
	}
	key = {
		meta.pktCount: ternary;
	}
	default_action = actionCalcSumWindowDists(0,0,0,0,0,0,0,0,0,0);
}
action actionCalcMaxWindowDists(
	bit<TIMESTAMP_WIDTH> cluster0,
	bit<TIMESTAMP_WIDTH> cluster1,
	bit<TIMESTAMP_WIDTH> cluster2,
	bit<TIMESTAMP_WIDTH> cluster3
) {
	bit<FEATURE_WIDTH> feature;
	registerMaxWindow.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;
	bit<TIMESTAMP_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + ((featPadded - cluster0)*(featPadded - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<TIMESTAMP_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + ((featPadded - cluster1)*(featPadded - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<TIMESTAMP_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + ((featPadded - cluster2)*(featPadded - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<TIMESTAMP_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + ((featPadded - cluster3)*(featPadded - cluster3));
	registerDistances.write(3, clus3Dist);


}
table tableCalcMaxWindowDists {
	actions = {
		actionCalcMaxWindowDists;
	}
	key = {
		meta.pktCount: ternary;
	}
	default_action = actionCalcMaxWindowDists(0,0,0,0,0,0,0,0,0,0);
}
action actionCalcMinWindowDists(
	bit<TIMESTAMP_WIDTH> cluster0,
	bit<TIMESTAMP_WIDTH> cluster1,
	bit<TIMESTAMP_WIDTH> cluster2,
	bit<TIMESTAMP_WIDTH> cluster3
) {
	bit<FEATURE_WIDTH> feature;
	registerMinWindow.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;
	bit<TIMESTAMP_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + ((featPadded - cluster0)*(featPadded - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<TIMESTAMP_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + ((featPadded - cluster1)*(featPadded - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<TIMESTAMP_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + ((featPadded - cluster2)*(featPadded - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<TIMESTAMP_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + ((featPadded - cluster3)*(featPadded - cluster3));
	registerDistances.write(3, clus3Dist);


}
table tableCalcMinWindowDists {
	actions = {
		actionCalcMinWindowDists;
	}
	key = {
		meta.pktCount: ternary;
	}
	default_action = actionCalcMinWindowDists(0,0,0,0,0,0,0,0,0,0);
}
action actionCalcMeanWindowDists(
	bit<TIMESTAMP_WIDTH> cluster0,
	bit<TIMESTAMP_WIDTH> cluster1,
	bit<TIMESTAMP_WIDTH> cluster2,
	bit<TIMESTAMP_WIDTH> cluster3
) {
	bit<FEATURE_WIDTH> feature;
	registerMeanWindow.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;
	bit<TIMESTAMP_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + ((featPadded - cluster0)*(featPadded - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<TIMESTAMP_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + ((featPadded - cluster1)*(featPadded - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<TIMESTAMP_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + ((featPadded - cluster2)*(featPadded - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<TIMESTAMP_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + ((featPadded - cluster3)*(featPadded - cluster3));
	registerDistances.write(3, clus3Dist);


}
table tableCalcMeanWindowDists {
	actions = {
		actionCalcMeanWindowDists;
	}
	key = {
		meta.pktCount: ternary;
	}
	default_action = actionCalcMeanWindowDists(0,0,0,0,0,0,0,0,0,0);
}
