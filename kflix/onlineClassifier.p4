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
		actionResetDistances();
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
	default_action = actionClassify(0,0,0,0);
}
action actionCalcPktCountDists(
	bit<NORMALIZED_WIDTH> cluster0,
	bit<NORMALIZED_WIDTH> cluster1,
	bit<NORMALIZED_WIDTH> cluster2,
	bit<NORMALIZED_WIDTH> cluster3,
	bit<TIMESTAMP_WIDTH> min_feature,
	bit<DIV_MASK_WIDTH> divisor_mask
) {

	bit<FEATURE_WIDTH> feature;
	registerPktCount.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;

	normalize(featPadded, min_feature, divisor_mask);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	bit<TIMESTAMP_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster0)*(normalized_feature - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<TIMESTAMP_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster1)*(normalized_feature - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<TIMESTAMP_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster2)*(normalized_feature - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<TIMESTAMP_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster3)*(normalized_feature - cluster3));
	registerDistances.write(3, clus3Dist);


}
table tableCalcPktCountDists {
	actions = {
		actionCalcPktCountDists;
	}
	key = {
		meta.pktCount: ternary;
	}
	default_action = actionCalcPktCountDists(0,0,0,0,0,0);
}
action actionCalcSumPktLengthDists(
	bit<NORMALIZED_WIDTH> cluster0,
	bit<NORMALIZED_WIDTH> cluster1,
	bit<NORMALIZED_WIDTH> cluster2,
	bit<NORMALIZED_WIDTH> cluster3,
	bit<TIMESTAMP_WIDTH> min_feature,
	bit<DIV_MASK_WIDTH> divisor_mask
) {

	bit<FEATURE_WIDTH> feature;
	registerSumPktLength.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;

	normalize(featPadded, min_feature, divisor_mask);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	bit<TIMESTAMP_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster0)*(normalized_feature - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<TIMESTAMP_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster1)*(normalized_feature - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<TIMESTAMP_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster2)*(normalized_feature - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<TIMESTAMP_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster3)*(normalized_feature - cluster3));
	registerDistances.write(3, clus3Dist);


}
table tableCalcSumPktLengthDists {
	actions = {
		actionCalcSumPktLengthDists;
	}
	key = {
		meta.pktCount: ternary;
	}
	default_action = actionCalcSumPktLengthDists(0,0,0,0,0,0);
}
action actionCalcMaxPktLengthDists(
	bit<NORMALIZED_WIDTH> cluster0,
	bit<NORMALIZED_WIDTH> cluster1,
	bit<NORMALIZED_WIDTH> cluster2,
	bit<NORMALIZED_WIDTH> cluster3,
	bit<TIMESTAMP_WIDTH> min_feature,
	bit<DIV_MASK_WIDTH> divisor_mask
) {

	bit<FEATURE_WIDTH> feature;
	registerMaxPktLength.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;

	normalize(featPadded, min_feature, divisor_mask);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	bit<TIMESTAMP_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster0)*(normalized_feature - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<TIMESTAMP_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster1)*(normalized_feature - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<TIMESTAMP_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster2)*(normalized_feature - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<TIMESTAMP_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster3)*(normalized_feature - cluster3));
	registerDistances.write(3, clus3Dist);


}
table tableCalcMaxPktLengthDists {
	actions = {
		actionCalcMaxPktLengthDists;
	}
	key = {
		meta.pktCount: ternary;
	}
	default_action = actionCalcMaxPktLengthDists(0,0,0,0,0,0);
}
action actionCalcMinPktLengthDists(
	bit<NORMALIZED_WIDTH> cluster0,
	bit<NORMALIZED_WIDTH> cluster1,
	bit<NORMALIZED_WIDTH> cluster2,
	bit<NORMALIZED_WIDTH> cluster3,
	bit<TIMESTAMP_WIDTH> min_feature,
	bit<DIV_MASK_WIDTH> divisor_mask
) {

	bit<FEATURE_WIDTH> feature;
	registerMinPktLength.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;

	normalize(featPadded, min_feature, divisor_mask);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	bit<TIMESTAMP_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster0)*(normalized_feature - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<TIMESTAMP_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster1)*(normalized_feature - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<TIMESTAMP_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster2)*(normalized_feature - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<TIMESTAMP_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster3)*(normalized_feature - cluster3));
	registerDistances.write(3, clus3Dist);


}
table tableCalcMinPktLengthDists {
	actions = {
		actionCalcMinPktLengthDists;
	}
	key = {
		meta.pktCount: ternary;
	}
	default_action = actionCalcMinPktLengthDists(0,0,0,0,0,0);
}
action actionCalcMeanPktLengthDists(
	bit<NORMALIZED_WIDTH> cluster0,
	bit<NORMALIZED_WIDTH> cluster1,
	bit<NORMALIZED_WIDTH> cluster2,
	bit<NORMALIZED_WIDTH> cluster3,
	bit<TIMESTAMP_WIDTH> min_feature,
	bit<DIV_MASK_WIDTH> divisor_mask
) {

	bit<FEATURE_WIDTH> feature;
	registerMeanPktLength.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;

	normalize(featPadded, min_feature, divisor_mask);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	bit<TIMESTAMP_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster0)*(normalized_feature - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<TIMESTAMP_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster1)*(normalized_feature - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<TIMESTAMP_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster2)*(normalized_feature - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<TIMESTAMP_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster3)*(normalized_feature - cluster3));
	registerDistances.write(3, clus3Dist);


}
table tableCalcMeanPktLengthDists {
	actions = {
		actionCalcMeanPktLengthDists;
	}
	key = {
		meta.pktCount: ternary;
	}
	default_action = actionCalcMeanPktLengthDists(0,0,0,0,0,0);
}
action actionCalcSumIatDists(
	bit<NORMALIZED_WIDTH> cluster0,
	bit<NORMALIZED_WIDTH> cluster1,
	bit<NORMALIZED_WIDTH> cluster2,
	bit<NORMALIZED_WIDTH> cluster3,
	bit<TIMESTAMP_WIDTH> min_feature,
	bit<DIV_MASK_WIDTH> divisor_mask
) {

	bit<FEATURE_WIDTH> feature;
	registerSumIat.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;

	normalize(featPadded, min_feature, divisor_mask);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	bit<TIMESTAMP_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster0)*(normalized_feature - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<TIMESTAMP_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster1)*(normalized_feature - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<TIMESTAMP_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster2)*(normalized_feature - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<TIMESTAMP_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster3)*(normalized_feature - cluster3));
	registerDistances.write(3, clus3Dist);


}
table tableCalcSumIatDists {
	actions = {
		actionCalcSumIatDists;
	}
	key = {
		meta.pktCount: ternary;
	}
	default_action = actionCalcSumIatDists(0,0,0,0,0,0);
}
action actionCalcMaxIatDists(
	bit<NORMALIZED_WIDTH> cluster0,
	bit<NORMALIZED_WIDTH> cluster1,
	bit<NORMALIZED_WIDTH> cluster2,
	bit<NORMALIZED_WIDTH> cluster3,
	bit<TIMESTAMP_WIDTH> min_feature,
	bit<DIV_MASK_WIDTH> divisor_mask
) {

	bit<FEATURE_WIDTH> feature;
	registerMaxIat.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;

	normalize(featPadded, min_feature, divisor_mask);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	bit<TIMESTAMP_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster0)*(normalized_feature - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<TIMESTAMP_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster1)*(normalized_feature - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<TIMESTAMP_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster2)*(normalized_feature - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<TIMESTAMP_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster3)*(normalized_feature - cluster3));
	registerDistances.write(3, clus3Dist);


}
table tableCalcMaxIatDists {
	actions = {
		actionCalcMaxIatDists;
	}
	key = {
		meta.pktCount: ternary;
	}
	default_action = actionCalcMaxIatDists(0,0,0,0,0,0);
}
action actionCalcMinIatDists(
	bit<NORMALIZED_WIDTH> cluster0,
	bit<NORMALIZED_WIDTH> cluster1,
	bit<NORMALIZED_WIDTH> cluster2,
	bit<NORMALIZED_WIDTH> cluster3,
	bit<TIMESTAMP_WIDTH> min_feature,
	bit<DIV_MASK_WIDTH> divisor_mask
) {

	bit<FEATURE_WIDTH> feature;
	registerMinIat.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;

	normalize(featPadded, min_feature, divisor_mask);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	bit<TIMESTAMP_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster0)*(normalized_feature - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<TIMESTAMP_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster1)*(normalized_feature - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<TIMESTAMP_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster2)*(normalized_feature - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<TIMESTAMP_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster3)*(normalized_feature - cluster3));
	registerDistances.write(3, clus3Dist);


}
table tableCalcMinIatDists {
	actions = {
		actionCalcMinIatDists;
	}
	key = {
		meta.pktCount: ternary;
	}
	default_action = actionCalcMinIatDists(0,0,0,0,0,0);
}
action actionCalcMeanIatDists(
	bit<NORMALIZED_WIDTH> cluster0,
	bit<NORMALIZED_WIDTH> cluster1,
	bit<NORMALIZED_WIDTH> cluster2,
	bit<NORMALIZED_WIDTH> cluster3,
	bit<TIMESTAMP_WIDTH> min_feature,
	bit<DIV_MASK_WIDTH> divisor_mask
) {

	bit<FEATURE_WIDTH> feature;
	registerMeanIat.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;

	normalize(featPadded, min_feature, divisor_mask);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	bit<TIMESTAMP_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster0)*(normalized_feature - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<TIMESTAMP_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster1)*(normalized_feature - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<TIMESTAMP_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster2)*(normalized_feature - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<TIMESTAMP_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster3)*(normalized_feature - cluster3));
	registerDistances.write(3, clus3Dist);


}
table tableCalcMeanIatDists {
	actions = {
		actionCalcMeanIatDists;
	}
	key = {
		meta.pktCount: ternary;
	}
	default_action = actionCalcMeanIatDists(0,0,0,0,0,0);
}
action actionCalcFlowDurationDists(
	bit<NORMALIZED_WIDTH> cluster0,
	bit<NORMALIZED_WIDTH> cluster1,
	bit<NORMALIZED_WIDTH> cluster2,
	bit<NORMALIZED_WIDTH> cluster3,
	bit<TIMESTAMP_WIDTH> min_feature,
	bit<DIV_MASK_WIDTH> divisor_mask
) {

	bit<FEATURE_WIDTH> feature;
	registerFlowDuration.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;

	normalize(featPadded, min_feature, divisor_mask);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	bit<TIMESTAMP_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster0)*(normalized_feature - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<TIMESTAMP_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster1)*(normalized_feature - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<TIMESTAMP_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster2)*(normalized_feature - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<TIMESTAMP_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster3)*(normalized_feature - cluster3));
	registerDistances.write(3, clus3Dist);


}
table tableCalcFlowDurationDists {
	actions = {
		actionCalcFlowDurationDists;
	}
	key = {
		meta.pktCount: ternary;
	}
	default_action = actionCalcFlowDurationDists(0,0,0,0,0,0);
}
action actionCalcInitialWindowDists(
	bit<NORMALIZED_WIDTH> cluster0,
	bit<NORMALIZED_WIDTH> cluster1,
	bit<NORMALIZED_WIDTH> cluster2,
	bit<NORMALIZED_WIDTH> cluster3,
	bit<TIMESTAMP_WIDTH> min_feature,
	bit<DIV_MASK_WIDTH> divisor_mask
) {

	bit<FEATURE_WIDTH> feature;
	registerInitialWindow.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;

	normalize(featPadded, min_feature, divisor_mask);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	bit<TIMESTAMP_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster0)*(normalized_feature - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<TIMESTAMP_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster1)*(normalized_feature - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<TIMESTAMP_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster2)*(normalized_feature - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<TIMESTAMP_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster3)*(normalized_feature - cluster3));
	registerDistances.write(3, clus3Dist);


}
table tableCalcInitialWindowDists {
	actions = {
		actionCalcInitialWindowDists;
	}
	key = {
		meta.pktCount: ternary;
	}
	default_action = actionCalcInitialWindowDists(0,0,0,0,0,0);
}
action actionCalcSumWindowDists(
	bit<NORMALIZED_WIDTH> cluster0,
	bit<NORMALIZED_WIDTH> cluster1,
	bit<NORMALIZED_WIDTH> cluster2,
	bit<NORMALIZED_WIDTH> cluster3,
	bit<TIMESTAMP_WIDTH> min_feature,
	bit<DIV_MASK_WIDTH> divisor_mask
) {

	bit<FEATURE_WIDTH> feature;
	registerSumWindow.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;

	normalize(featPadded, min_feature, divisor_mask);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	bit<TIMESTAMP_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster0)*(normalized_feature - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<TIMESTAMP_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster1)*(normalized_feature - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<TIMESTAMP_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster2)*(normalized_feature - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<TIMESTAMP_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster3)*(normalized_feature - cluster3));
	registerDistances.write(3, clus3Dist);


}
table tableCalcSumWindowDists {
	actions = {
		actionCalcSumWindowDists;
	}
	key = {
		meta.pktCount: ternary;
	}
	default_action = actionCalcSumWindowDists(0,0,0,0,0,0);
}
action actionCalcMaxWindowDists(
	bit<NORMALIZED_WIDTH> cluster0,
	bit<NORMALIZED_WIDTH> cluster1,
	bit<NORMALIZED_WIDTH> cluster2,
	bit<NORMALIZED_WIDTH> cluster3,
	bit<TIMESTAMP_WIDTH> min_feature,
	bit<DIV_MASK_WIDTH> divisor_mask
) {

	bit<FEATURE_WIDTH> feature;
	registerMaxWindow.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;

	normalize(featPadded, min_feature, divisor_mask);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	bit<TIMESTAMP_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster0)*(normalized_feature - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<TIMESTAMP_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster1)*(normalized_feature - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<TIMESTAMP_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster2)*(normalized_feature - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<TIMESTAMP_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster3)*(normalized_feature - cluster3));
	registerDistances.write(3, clus3Dist);


}
table tableCalcMaxWindowDists {
	actions = {
		actionCalcMaxWindowDists;
	}
	key = {
		meta.pktCount: ternary;
	}
	default_action = actionCalcMaxWindowDists(0,0,0,0,0,0);
}
action actionCalcMinWindowDists(
	bit<NORMALIZED_WIDTH> cluster0,
	bit<NORMALIZED_WIDTH> cluster1,
	bit<NORMALIZED_WIDTH> cluster2,
	bit<NORMALIZED_WIDTH> cluster3,
	bit<TIMESTAMP_WIDTH> min_feature,
	bit<DIV_MASK_WIDTH> divisor_mask
) {

	bit<FEATURE_WIDTH> feature;
	registerMinWindow.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;

	normalize(featPadded, min_feature, divisor_mask);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	bit<TIMESTAMP_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster0)*(normalized_feature - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<TIMESTAMP_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster1)*(normalized_feature - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<TIMESTAMP_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster2)*(normalized_feature - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<TIMESTAMP_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster3)*(normalized_feature - cluster3));
	registerDistances.write(3, clus3Dist);


}
table tableCalcMinWindowDists {
	actions = {
		actionCalcMinWindowDists;
	}
	key = {
		meta.pktCount: ternary;
	}
	default_action = actionCalcMinWindowDists(0,0,0,0,0,0);
}
action actionCalcMeanWindowDists(
	bit<NORMALIZED_WIDTH> cluster0,
	bit<NORMALIZED_WIDTH> cluster1,
	bit<NORMALIZED_WIDTH> cluster2,
	bit<NORMALIZED_WIDTH> cluster3,
	bit<TIMESTAMP_WIDTH> min_feature,
	bit<DIV_MASK_WIDTH> divisor_mask
) {

	bit<FEATURE_WIDTH> feature;
	registerMeanWindow.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;

	normalize(featPadded, min_feature, divisor_mask);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	bit<TIMESTAMP_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster0)*(normalized_feature - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<TIMESTAMP_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster1)*(normalized_feature - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<TIMESTAMP_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster2)*(normalized_feature - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<TIMESTAMP_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster3)*(normalized_feature - cluster3));
	registerDistances.write(3, clus3Dist);


}
table tableCalcMeanWindowDists {
	actions = {
		actionCalcMeanWindowDists;
	}
	key = {
		meta.pktCount: ternary;
	}
	default_action = actionCalcMeanWindowDists(0,0,0,0,0,0);
}
