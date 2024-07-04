action actionResetDistances() {
	registerDistances.write(0, (bit<DISTANCE_WIDTH>)0);
	registerDistances.write(1, (bit<DISTANCE_WIDTH>)0);
	registerDistances.write(2, (bit<DISTANCE_WIDTH>)0);
	registerDistances.write(3, (bit<DISTANCE_WIDTH>)0);
	registerDistances.write(4, (bit<DISTANCE_WIDTH>)0);
	registerDistances.write(5, (bit<DISTANCE_WIDTH>)0);
	registerDistances.write(6, (bit<DISTANCE_WIDTH>)0);
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
	bit<BOOLEAN> cluster6
) {
	bit<BOOLEAN> result;
	result = 0;
	bit<DISTANCE_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	bit<DISTANCE_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	bit<DISTANCE_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	bit<DISTANCE_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	bit<DISTANCE_WIDTH> clus4Dist;
	registerDistances.read(clus4Dist, 4);
	bit<DISTANCE_WIDTH> clus5Dist;
	registerDistances.read(clus5Dist, 5);
	bit<DISTANCE_WIDTH> clus6Dist;
	registerDistances.read(clus6Dist, 6);
	if(
		 clus0Dist <= clus1Dist &&
		 clus0Dist <= clus2Dist &&
		 clus0Dist <= clus3Dist &&
		 clus0Dist <= clus4Dist &&
		 clus0Dist <= clus5Dist &&
		 clus0Dist <= clus6Dist
	) {
		result = cluster0;
		hdr.features.cluster = (bit<16>)0;
	} else {
	if(
		 clus1Dist <= clus2Dist &&
		 clus1Dist <= clus3Dist &&
		 clus1Dist <= clus4Dist &&
		 clus1Dist <= clus5Dist &&
		 clus1Dist <= clus6Dist
	) {
		result = cluster1;
		hdr.features.cluster = (bit<16>)1;
	} else {
	if(
		 clus2Dist <= clus3Dist &&
		 clus2Dist <= clus4Dist &&
		 clus2Dist <= clus5Dist &&
		 clus2Dist <= clus6Dist
	) {
		result = cluster2;
		hdr.features.cluster = (bit<16>)2;
	} else {
	if(
		 clus3Dist <= clus4Dist &&
		 clus3Dist <= clus5Dist &&
		 clus3Dist <= clus6Dist
	) {
		result = cluster3;
		hdr.features.cluster = (bit<16>)3;
	} else {
	if(
		 clus4Dist <= clus5Dist &&
		 clus4Dist <= clus6Dist
	) {
		result = cluster4;
		hdr.features.cluster = (bit<16>)4;
	} else {
	if(
		 clus5Dist <= clus6Dist
	) {
		result = cluster5;
		hdr.features.cluster = (bit<16>)5;
	} else {
		result = cluster6;
		hdr.features.cluster = (bit<16>)6;
	}
	}
	}
	}
	}
	}
	hdr.features.isVideo = (bit<16>)result;
}
table tableClassify {
	actions = {
		actionClassify;
	}
	key = {
		meta.pktCount: ternary;
	}
	default_action = actionClassify(0,0,0,0,0,0,0);
}
action actionCalcPktCountDists(
	bit<NORMALIZED_WIDTH> cluster0,
	bit<NORMALIZED_WIDTH> cluster1,
	bit<NORMALIZED_WIDTH> cluster2,
	bit<NORMALIZED_WIDTH> cluster3,
	bit<NORMALIZED_WIDTH> cluster4,
	bit<NORMALIZED_WIDTH> cluster5,
	bit<NORMALIZED_WIDTH> cluster6,
	bit<TIMESTAMP_WIDTH> min_feature,
	bit<DIV_MASK_WIDTH> divisor_mask,
	bit<TIMESTAMP_WIDTH> mult_factor
) {

	bit<FEATURE_WIDTH> feature;
	registerPktCount.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;

	normalize(featPadded, min_feature, divisor_mask, mult_factor);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	calc_distance(normalized_feature, cluster0, 0);
	calc_distance(normalized_feature, cluster1, 1);
	calc_distance(normalized_feature, cluster2, 2);
	calc_distance(normalized_feature, cluster3, 3);
	calc_distance(normalized_feature, cluster4, 4);
	calc_distance(normalized_feature, cluster5, 5);
	calc_distance(normalized_feature, cluster6, 6);
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
	bit<NORMALIZED_WIDTH> cluster0,
	bit<NORMALIZED_WIDTH> cluster1,
	bit<NORMALIZED_WIDTH> cluster2,
	bit<NORMALIZED_WIDTH> cluster3,
	bit<NORMALIZED_WIDTH> cluster4,
	bit<NORMALIZED_WIDTH> cluster5,
	bit<NORMALIZED_WIDTH> cluster6,
	bit<TIMESTAMP_WIDTH> min_feature,
	bit<DIV_MASK_WIDTH> divisor_mask,
	bit<TIMESTAMP_WIDTH> mult_factor
) {

	bit<FEATURE_WIDTH> feature;
	registerSumPktLength.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;

	normalize(featPadded, min_feature, divisor_mask, mult_factor);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	calc_distance(normalized_feature, cluster0, 0);
	calc_distance(normalized_feature, cluster1, 1);
	calc_distance(normalized_feature, cluster2, 2);
	calc_distance(normalized_feature, cluster3, 3);
	calc_distance(normalized_feature, cluster4, 4);
	calc_distance(normalized_feature, cluster5, 5);
	calc_distance(normalized_feature, cluster6, 6);
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
	bit<NORMALIZED_WIDTH> cluster0,
	bit<NORMALIZED_WIDTH> cluster1,
	bit<NORMALIZED_WIDTH> cluster2,
	bit<NORMALIZED_WIDTH> cluster3,
	bit<NORMALIZED_WIDTH> cluster4,
	bit<NORMALIZED_WIDTH> cluster5,
	bit<NORMALIZED_WIDTH> cluster6,
	bit<TIMESTAMP_WIDTH> min_feature,
	bit<DIV_MASK_WIDTH> divisor_mask,
	bit<TIMESTAMP_WIDTH> mult_factor
) {

	bit<FEATURE_WIDTH> feature;
	registerMaxPktLength.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;

	normalize(featPadded, min_feature, divisor_mask, mult_factor);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	calc_distance(normalized_feature, cluster0, 0);
	calc_distance(normalized_feature, cluster1, 1);
	calc_distance(normalized_feature, cluster2, 2);
	calc_distance(normalized_feature, cluster3, 3);
	calc_distance(normalized_feature, cluster4, 4);
	calc_distance(normalized_feature, cluster5, 5);
	calc_distance(normalized_feature, cluster6, 6);
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
	bit<NORMALIZED_WIDTH> cluster0,
	bit<NORMALIZED_WIDTH> cluster1,
	bit<NORMALIZED_WIDTH> cluster2,
	bit<NORMALIZED_WIDTH> cluster3,
	bit<NORMALIZED_WIDTH> cluster4,
	bit<NORMALIZED_WIDTH> cluster5,
	bit<NORMALIZED_WIDTH> cluster6,
	bit<TIMESTAMP_WIDTH> min_feature,
	bit<DIV_MASK_WIDTH> divisor_mask,
	bit<TIMESTAMP_WIDTH> mult_factor
) {

	bit<FEATURE_WIDTH> feature;
	registerMinPktLength.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;

	normalize(featPadded, min_feature, divisor_mask, mult_factor);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	calc_distance(normalized_feature, cluster0, 0);
	calc_distance(normalized_feature, cluster1, 1);
	calc_distance(normalized_feature, cluster2, 2);
	calc_distance(normalized_feature, cluster3, 3);
	calc_distance(normalized_feature, cluster4, 4);
	calc_distance(normalized_feature, cluster5, 5);
	calc_distance(normalized_feature, cluster6, 6);
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
	bit<NORMALIZED_WIDTH> cluster0,
	bit<NORMALIZED_WIDTH> cluster1,
	bit<NORMALIZED_WIDTH> cluster2,
	bit<NORMALIZED_WIDTH> cluster3,
	bit<NORMALIZED_WIDTH> cluster4,
	bit<NORMALIZED_WIDTH> cluster5,
	bit<NORMALIZED_WIDTH> cluster6,
	bit<TIMESTAMP_WIDTH> min_feature,
	bit<DIV_MASK_WIDTH> divisor_mask,
	bit<TIMESTAMP_WIDTH> mult_factor
) {

	bit<FEATURE_WIDTH> feature;
	registerMeanPktLength.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;

	normalize(featPadded, min_feature, divisor_mask, mult_factor);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	calc_distance(normalized_feature, cluster0, 0);
	calc_distance(normalized_feature, cluster1, 1);
	calc_distance(normalized_feature, cluster2, 2);
	calc_distance(normalized_feature, cluster3, 3);
	calc_distance(normalized_feature, cluster4, 4);
	calc_distance(normalized_feature, cluster5, 5);
	calc_distance(normalized_feature, cluster6, 6);
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
	bit<NORMALIZED_WIDTH> cluster0,
	bit<NORMALIZED_WIDTH> cluster1,
	bit<NORMALIZED_WIDTH> cluster2,
	bit<NORMALIZED_WIDTH> cluster3,
	bit<NORMALIZED_WIDTH> cluster4,
	bit<NORMALIZED_WIDTH> cluster5,
	bit<NORMALIZED_WIDTH> cluster6,
	bit<TIMESTAMP_WIDTH> min_feature,
	bit<DIV_MASK_WIDTH> divisor_mask,
	bit<TIMESTAMP_WIDTH> mult_factor
) {

	bit<TIMESTAMP_WIDTH> featPadded;
	registerSumIat.read(featPadded, meta.hashKey);

	normalize(featPadded, min_feature, divisor_mask, mult_factor);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	calc_distance(normalized_feature, cluster0, 0);
	calc_distance(normalized_feature, cluster1, 1);
	calc_distance(normalized_feature, cluster2, 2);
	calc_distance(normalized_feature, cluster3, 3);
	calc_distance(normalized_feature, cluster4, 4);
	calc_distance(normalized_feature, cluster5, 5);
	calc_distance(normalized_feature, cluster6, 6);
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
	bit<NORMALIZED_WIDTH> cluster0,
	bit<NORMALIZED_WIDTH> cluster1,
	bit<NORMALIZED_WIDTH> cluster2,
	bit<NORMALIZED_WIDTH> cluster3,
	bit<NORMALIZED_WIDTH> cluster4,
	bit<NORMALIZED_WIDTH> cluster5,
	bit<NORMALIZED_WIDTH> cluster6,
	bit<TIMESTAMP_WIDTH> min_feature,
	bit<DIV_MASK_WIDTH> divisor_mask,
	bit<TIMESTAMP_WIDTH> mult_factor
) {

	bit<TIMESTAMP_WIDTH> featPadded;
	registerMaxIat.read(featPadded, meta.hashKey);

	normalize(featPadded, min_feature, divisor_mask, mult_factor);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	calc_distance(normalized_feature, cluster0, 0);
	calc_distance(normalized_feature, cluster1, 1);
	calc_distance(normalized_feature, cluster2, 2);
	calc_distance(normalized_feature, cluster3, 3);
	calc_distance(normalized_feature, cluster4, 4);
	calc_distance(normalized_feature, cluster5, 5);
	calc_distance(normalized_feature, cluster6, 6);
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
	bit<NORMALIZED_WIDTH> cluster0,
	bit<NORMALIZED_WIDTH> cluster1,
	bit<NORMALIZED_WIDTH> cluster2,
	bit<NORMALIZED_WIDTH> cluster3,
	bit<NORMALIZED_WIDTH> cluster4,
	bit<NORMALIZED_WIDTH> cluster5,
	bit<NORMALIZED_WIDTH> cluster6,
	bit<TIMESTAMP_WIDTH> min_feature,
	bit<DIV_MASK_WIDTH> divisor_mask,
	bit<TIMESTAMP_WIDTH> mult_factor
) {

	bit<TIMESTAMP_WIDTH> featPadded;
	registerMinIat.read(featPadded, meta.hashKey);

	normalize(featPadded, min_feature, divisor_mask, mult_factor);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	calc_distance(normalized_feature, cluster0, 0);
	calc_distance(normalized_feature, cluster1, 1);
	calc_distance(normalized_feature, cluster2, 2);
	calc_distance(normalized_feature, cluster3, 3);
	calc_distance(normalized_feature, cluster4, 4);
	calc_distance(normalized_feature, cluster5, 5);
	calc_distance(normalized_feature, cluster6, 6);
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
	bit<NORMALIZED_WIDTH> cluster0,
	bit<NORMALIZED_WIDTH> cluster1,
	bit<NORMALIZED_WIDTH> cluster2,
	bit<NORMALIZED_WIDTH> cluster3,
	bit<NORMALIZED_WIDTH> cluster4,
	bit<NORMALIZED_WIDTH> cluster5,
	bit<NORMALIZED_WIDTH> cluster6,
	bit<TIMESTAMP_WIDTH> min_feature,
	bit<DIV_MASK_WIDTH> divisor_mask,
	bit<TIMESTAMP_WIDTH> mult_factor
) {

	bit<TIMESTAMP_WIDTH> featPadded;
	registerMeanIat.read(featPadded, meta.hashKey);

	normalize(featPadded, min_feature, divisor_mask, mult_factor);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	calc_distance(normalized_feature, cluster0, 0);
	calc_distance(normalized_feature, cluster1, 1);
	calc_distance(normalized_feature, cluster2, 2);
	calc_distance(normalized_feature, cluster3, 3);
	calc_distance(normalized_feature, cluster4, 4);
	calc_distance(normalized_feature, cluster5, 5);
	calc_distance(normalized_feature, cluster6, 6);
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
	bit<NORMALIZED_WIDTH> cluster0,
	bit<NORMALIZED_WIDTH> cluster1,
	bit<NORMALIZED_WIDTH> cluster2,
	bit<NORMALIZED_WIDTH> cluster3,
	bit<NORMALIZED_WIDTH> cluster4,
	bit<NORMALIZED_WIDTH> cluster5,
	bit<NORMALIZED_WIDTH> cluster6,
	bit<TIMESTAMP_WIDTH> min_feature,
	bit<DIV_MASK_WIDTH> divisor_mask,
	bit<TIMESTAMP_WIDTH> mult_factor
) {

	bit<TIMESTAMP_WIDTH> featPadded;
	registerFlowDuration.read(featPadded, meta.hashKey);

	normalize(featPadded, min_feature, divisor_mask, mult_factor);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	calc_distance(normalized_feature, cluster0, 0);
	calc_distance(normalized_feature, cluster1, 1);
	calc_distance(normalized_feature, cluster2, 2);
	calc_distance(normalized_feature, cluster3, 3);
	calc_distance(normalized_feature, cluster4, 4);
	calc_distance(normalized_feature, cluster5, 5);
	calc_distance(normalized_feature, cluster6, 6);
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
	bit<NORMALIZED_WIDTH> cluster0,
	bit<NORMALIZED_WIDTH> cluster1,
	bit<NORMALIZED_WIDTH> cluster2,
	bit<NORMALIZED_WIDTH> cluster3,
	bit<NORMALIZED_WIDTH> cluster4,
	bit<NORMALIZED_WIDTH> cluster5,
	bit<NORMALIZED_WIDTH> cluster6,
	bit<TIMESTAMP_WIDTH> min_feature,
	bit<DIV_MASK_WIDTH> divisor_mask,
	bit<TIMESTAMP_WIDTH> mult_factor
) {

	bit<FEATURE_WIDTH> feature;
	registerInitialWindow.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;

	normalize(featPadded, min_feature, divisor_mask, mult_factor);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	calc_distance(normalized_feature, cluster0, 0);
	calc_distance(normalized_feature, cluster1, 1);
	calc_distance(normalized_feature, cluster2, 2);
	calc_distance(normalized_feature, cluster3, 3);
	calc_distance(normalized_feature, cluster4, 4);
	calc_distance(normalized_feature, cluster5, 5);
	calc_distance(normalized_feature, cluster6, 6);
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
	bit<NORMALIZED_WIDTH> cluster0,
	bit<NORMALIZED_WIDTH> cluster1,
	bit<NORMALIZED_WIDTH> cluster2,
	bit<NORMALIZED_WIDTH> cluster3,
	bit<NORMALIZED_WIDTH> cluster4,
	bit<NORMALIZED_WIDTH> cluster5,
	bit<NORMALIZED_WIDTH> cluster6,
	bit<TIMESTAMP_WIDTH> min_feature,
	bit<DIV_MASK_WIDTH> divisor_mask,
	bit<TIMESTAMP_WIDTH> mult_factor
) {

	bit<FEATURE_WIDTH> feature;
	registerSumWindow.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;

	normalize(featPadded, min_feature, divisor_mask, mult_factor);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	calc_distance(normalized_feature, cluster0, 0);
	calc_distance(normalized_feature, cluster1, 1);
	calc_distance(normalized_feature, cluster2, 2);
	calc_distance(normalized_feature, cluster3, 3);
	calc_distance(normalized_feature, cluster4, 4);
	calc_distance(normalized_feature, cluster5, 5);
	calc_distance(normalized_feature, cluster6, 6);
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
	bit<NORMALIZED_WIDTH> cluster0,
	bit<NORMALIZED_WIDTH> cluster1,
	bit<NORMALIZED_WIDTH> cluster2,
	bit<NORMALIZED_WIDTH> cluster3,
	bit<NORMALIZED_WIDTH> cluster4,
	bit<NORMALIZED_WIDTH> cluster5,
	bit<NORMALIZED_WIDTH> cluster6,
	bit<TIMESTAMP_WIDTH> min_feature,
	bit<DIV_MASK_WIDTH> divisor_mask,
	bit<TIMESTAMP_WIDTH> mult_factor
) {

	bit<FEATURE_WIDTH> feature;
	registerMaxWindow.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;

	normalize(featPadded, min_feature, divisor_mask, mult_factor);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	calc_distance(normalized_feature, cluster0, 0);
	calc_distance(normalized_feature, cluster1, 1);
	calc_distance(normalized_feature, cluster2, 2);
	calc_distance(normalized_feature, cluster3, 3);
	calc_distance(normalized_feature, cluster4, 4);
	calc_distance(normalized_feature, cluster5, 5);
	calc_distance(normalized_feature, cluster6, 6);
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
	bit<NORMALIZED_WIDTH> cluster0,
	bit<NORMALIZED_WIDTH> cluster1,
	bit<NORMALIZED_WIDTH> cluster2,
	bit<NORMALIZED_WIDTH> cluster3,
	bit<NORMALIZED_WIDTH> cluster4,
	bit<NORMALIZED_WIDTH> cluster5,
	bit<NORMALIZED_WIDTH> cluster6,
	bit<TIMESTAMP_WIDTH> min_feature,
	bit<DIV_MASK_WIDTH> divisor_mask,
	bit<TIMESTAMP_WIDTH> mult_factor
) {

	bit<FEATURE_WIDTH> feature;
	registerMinWindow.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;

	normalize(featPadded, min_feature, divisor_mask, mult_factor);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	calc_distance(normalized_feature, cluster0, 0);
	calc_distance(normalized_feature, cluster1, 1);
	calc_distance(normalized_feature, cluster2, 2);
	calc_distance(normalized_feature, cluster3, 3);
	calc_distance(normalized_feature, cluster4, 4);
	calc_distance(normalized_feature, cluster5, 5);
	calc_distance(normalized_feature, cluster6, 6);
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
	bit<NORMALIZED_WIDTH> cluster0,
	bit<NORMALIZED_WIDTH> cluster1,
	bit<NORMALIZED_WIDTH> cluster2,
	bit<NORMALIZED_WIDTH> cluster3,
	bit<NORMALIZED_WIDTH> cluster4,
	bit<NORMALIZED_WIDTH> cluster5,
	bit<NORMALIZED_WIDTH> cluster6,
	bit<TIMESTAMP_WIDTH> min_feature,
	bit<DIV_MASK_WIDTH> divisor_mask,
	bit<TIMESTAMP_WIDTH> mult_factor
) {

	bit<FEATURE_WIDTH> feature;
	registerMeanWindow.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;

	normalize(featPadded, min_feature, divisor_mask, mult_factor);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	calc_distance(normalized_feature, cluster0, 0);
	calc_distance(normalized_feature, cluster1, 1);
	calc_distance(normalized_feature, cluster2, 2);
	calc_distance(normalized_feature, cluster3, 3);
	calc_distance(normalized_feature, cluster4, 4);
	calc_distance(normalized_feature, cluster5, 5);
	calc_distance(normalized_feature, cluster6, 6);
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
