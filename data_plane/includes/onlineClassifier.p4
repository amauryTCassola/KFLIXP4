#define CLUSTER_NUMBER 7
register<bit<DISTANCE_WIDTH>>(CLUSTER_NUMBER) registerDistances;
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
table tableClassifier {
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
	bit<DIV_MASK_WIDTH> divisor_mask
	bit<DIV_MASK_WIDTH> mult_factor
) {

	bit<FEATURE_WIDTH> feature;
	registerPktCount.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;

	normalize(featPadded, min_feature, divisor_mask, mult_factor);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	bit<DISTANCE_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster0)*(normalized_feature - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<DISTANCE_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster1)*(normalized_feature - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<DISTANCE_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster2)*(normalized_feature - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<DISTANCE_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster3)*(normalized_feature - cluster3));
	registerDistances.write(3, clus3Dist);


	bit<DISTANCE_WIDTH> clus4Dist;
	registerDistances.read(clus4Dist, 4);
	clus4Dist = clus4Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster4)*(normalized_feature - cluster4));
	registerDistances.write(4, clus4Dist);


	bit<DISTANCE_WIDTH> clus5Dist;
	registerDistances.read(clus5Dist, 5);
	clus5Dist = clus5Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster5)*(normalized_feature - cluster5));
	registerDistances.write(5, clus5Dist);


	bit<DISTANCE_WIDTH> clus6Dist;
	registerDistances.read(clus6Dist, 6);
	clus6Dist = clus6Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster6)*(normalized_feature - cluster6));
	registerDistances.write(6, clus6Dist);


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
	bit<DIV_MASK_WIDTH> divisor_mask
	bit<DIV_MASK_WIDTH> mult_factor
) {

	bit<FEATURE_WIDTH> feature;
	registerSumPktLength.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;

	normalize(featPadded, min_feature, divisor_mask, mult_factor);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	bit<DISTANCE_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster0)*(normalized_feature - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<DISTANCE_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster1)*(normalized_feature - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<DISTANCE_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster2)*(normalized_feature - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<DISTANCE_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster3)*(normalized_feature - cluster3));
	registerDistances.write(3, clus3Dist);


	bit<DISTANCE_WIDTH> clus4Dist;
	registerDistances.read(clus4Dist, 4);
	clus4Dist = clus4Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster4)*(normalized_feature - cluster4));
	registerDistances.write(4, clus4Dist);


	bit<DISTANCE_WIDTH> clus5Dist;
	registerDistances.read(clus5Dist, 5);
	clus5Dist = clus5Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster5)*(normalized_feature - cluster5));
	registerDistances.write(5, clus5Dist);


	bit<DISTANCE_WIDTH> clus6Dist;
	registerDistances.read(clus6Dist, 6);
	clus6Dist = clus6Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster6)*(normalized_feature - cluster6));
	registerDistances.write(6, clus6Dist);


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
	bit<DIV_MASK_WIDTH> divisor_mask
	bit<DIV_MASK_WIDTH> mult_factor
) {

	bit<FEATURE_WIDTH> feature;
	registerMaxPktLength.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;

	normalize(featPadded, min_feature, divisor_mask, mult_factor);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	bit<DISTANCE_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster0)*(normalized_feature - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<DISTANCE_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster1)*(normalized_feature - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<DISTANCE_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster2)*(normalized_feature - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<DISTANCE_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster3)*(normalized_feature - cluster3));
	registerDistances.write(3, clus3Dist);


	bit<DISTANCE_WIDTH> clus4Dist;
	registerDistances.read(clus4Dist, 4);
	clus4Dist = clus4Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster4)*(normalized_feature - cluster4));
	registerDistances.write(4, clus4Dist);


	bit<DISTANCE_WIDTH> clus5Dist;
	registerDistances.read(clus5Dist, 5);
	clus5Dist = clus5Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster5)*(normalized_feature - cluster5));
	registerDistances.write(5, clus5Dist);


	bit<DISTANCE_WIDTH> clus6Dist;
	registerDistances.read(clus6Dist, 6);
	clus6Dist = clus6Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster6)*(normalized_feature - cluster6));
	registerDistances.write(6, clus6Dist);


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
	bit<DIV_MASK_WIDTH> divisor_mask
	bit<DIV_MASK_WIDTH> mult_factor
) {

	bit<FEATURE_WIDTH> feature;
	registerMinPktLength.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;

	normalize(featPadded, min_feature, divisor_mask, mult_factor);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	bit<DISTANCE_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster0)*(normalized_feature - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<DISTANCE_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster1)*(normalized_feature - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<DISTANCE_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster2)*(normalized_feature - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<DISTANCE_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster3)*(normalized_feature - cluster3));
	registerDistances.write(3, clus3Dist);


	bit<DISTANCE_WIDTH> clus4Dist;
	registerDistances.read(clus4Dist, 4);
	clus4Dist = clus4Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster4)*(normalized_feature - cluster4));
	registerDistances.write(4, clus4Dist);


	bit<DISTANCE_WIDTH> clus5Dist;
	registerDistances.read(clus5Dist, 5);
	clus5Dist = clus5Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster5)*(normalized_feature - cluster5));
	registerDistances.write(5, clus5Dist);


	bit<DISTANCE_WIDTH> clus6Dist;
	registerDistances.read(clus6Dist, 6);
	clus6Dist = clus6Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster6)*(normalized_feature - cluster6));
	registerDistances.write(6, clus6Dist);


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
	bit<DIV_MASK_WIDTH> divisor_mask
	bit<DIV_MASK_WIDTH> mult_factor
) {

	bit<FEATURE_WIDTH> feature;
	registerMeanPktLength.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;

	normalize(featPadded, min_feature, divisor_mask, mult_factor);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	bit<DISTANCE_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster0)*(normalized_feature - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<DISTANCE_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster1)*(normalized_feature - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<DISTANCE_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster2)*(normalized_feature - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<DISTANCE_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster3)*(normalized_feature - cluster3));
	registerDistances.write(3, clus3Dist);


	bit<DISTANCE_WIDTH> clus4Dist;
	registerDistances.read(clus4Dist, 4);
	clus4Dist = clus4Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster4)*(normalized_feature - cluster4));
	registerDistances.write(4, clus4Dist);


	bit<DISTANCE_WIDTH> clus5Dist;
	registerDistances.read(clus5Dist, 5);
	clus5Dist = clus5Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster5)*(normalized_feature - cluster5));
	registerDistances.write(5, clus5Dist);


	bit<DISTANCE_WIDTH> clus6Dist;
	registerDistances.read(clus6Dist, 6);
	clus6Dist = clus6Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster6)*(normalized_feature - cluster6));
	registerDistances.write(6, clus6Dist);


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
	bit<DIV_MASK_WIDTH> divisor_mask
	bit<DIV_MASK_WIDTH> mult_factor
) {

	bit<FEATURE_WIDTH> feature;
	registerSumIat.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;

	normalize(featPadded, min_feature, divisor_mask, mult_factor);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	bit<DISTANCE_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster0)*(normalized_feature - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<DISTANCE_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster1)*(normalized_feature - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<DISTANCE_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster2)*(normalized_feature - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<DISTANCE_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster3)*(normalized_feature - cluster3));
	registerDistances.write(3, clus3Dist);


	bit<DISTANCE_WIDTH> clus4Dist;
	registerDistances.read(clus4Dist, 4);
	clus4Dist = clus4Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster4)*(normalized_feature - cluster4));
	registerDistances.write(4, clus4Dist);


	bit<DISTANCE_WIDTH> clus5Dist;
	registerDistances.read(clus5Dist, 5);
	clus5Dist = clus5Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster5)*(normalized_feature - cluster5));
	registerDistances.write(5, clus5Dist);


	bit<DISTANCE_WIDTH> clus6Dist;
	registerDistances.read(clus6Dist, 6);
	clus6Dist = clus6Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster6)*(normalized_feature - cluster6));
	registerDistances.write(6, clus6Dist);


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
	bit<DIV_MASK_WIDTH> divisor_mask
	bit<DIV_MASK_WIDTH> mult_factor
) {

	bit<FEATURE_WIDTH> feature;
	registerMaxIat.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;

	normalize(featPadded, min_feature, divisor_mask, mult_factor);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	bit<DISTANCE_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster0)*(normalized_feature - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<DISTANCE_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster1)*(normalized_feature - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<DISTANCE_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster2)*(normalized_feature - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<DISTANCE_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster3)*(normalized_feature - cluster3));
	registerDistances.write(3, clus3Dist);


	bit<DISTANCE_WIDTH> clus4Dist;
	registerDistances.read(clus4Dist, 4);
	clus4Dist = clus4Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster4)*(normalized_feature - cluster4));
	registerDistances.write(4, clus4Dist);


	bit<DISTANCE_WIDTH> clus5Dist;
	registerDistances.read(clus5Dist, 5);
	clus5Dist = clus5Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster5)*(normalized_feature - cluster5));
	registerDistances.write(5, clus5Dist);


	bit<DISTANCE_WIDTH> clus6Dist;
	registerDistances.read(clus6Dist, 6);
	clus6Dist = clus6Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster6)*(normalized_feature - cluster6));
	registerDistances.write(6, clus6Dist);


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
	bit<DIV_MASK_WIDTH> divisor_mask
	bit<DIV_MASK_WIDTH> mult_factor
) {

	bit<FEATURE_WIDTH> feature;
	registerMinIat.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;

	normalize(featPadded, min_feature, divisor_mask, mult_factor);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	bit<DISTANCE_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster0)*(normalized_feature - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<DISTANCE_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster1)*(normalized_feature - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<DISTANCE_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster2)*(normalized_feature - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<DISTANCE_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster3)*(normalized_feature - cluster3));
	registerDistances.write(3, clus3Dist);


	bit<DISTANCE_WIDTH> clus4Dist;
	registerDistances.read(clus4Dist, 4);
	clus4Dist = clus4Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster4)*(normalized_feature - cluster4));
	registerDistances.write(4, clus4Dist);


	bit<DISTANCE_WIDTH> clus5Dist;
	registerDistances.read(clus5Dist, 5);
	clus5Dist = clus5Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster5)*(normalized_feature - cluster5));
	registerDistances.write(5, clus5Dist);


	bit<DISTANCE_WIDTH> clus6Dist;
	registerDistances.read(clus6Dist, 6);
	clus6Dist = clus6Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster6)*(normalized_feature - cluster6));
	registerDistances.write(6, clus6Dist);


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
	bit<DIV_MASK_WIDTH> divisor_mask
	bit<DIV_MASK_WIDTH> mult_factor
) {

	bit<FEATURE_WIDTH> feature;
	registerMeanIat.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;

	normalize(featPadded, min_feature, divisor_mask, mult_factor);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	bit<DISTANCE_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster0)*(normalized_feature - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<DISTANCE_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster1)*(normalized_feature - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<DISTANCE_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster2)*(normalized_feature - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<DISTANCE_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster3)*(normalized_feature - cluster3));
	registerDistances.write(3, clus3Dist);


	bit<DISTANCE_WIDTH> clus4Dist;
	registerDistances.read(clus4Dist, 4);
	clus4Dist = clus4Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster4)*(normalized_feature - cluster4));
	registerDistances.write(4, clus4Dist);


	bit<DISTANCE_WIDTH> clus5Dist;
	registerDistances.read(clus5Dist, 5);
	clus5Dist = clus5Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster5)*(normalized_feature - cluster5));
	registerDistances.write(5, clus5Dist);


	bit<DISTANCE_WIDTH> clus6Dist;
	registerDistances.read(clus6Dist, 6);
	clus6Dist = clus6Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster6)*(normalized_feature - cluster6));
	registerDistances.write(6, clus6Dist);


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
	bit<DIV_MASK_WIDTH> divisor_mask
	bit<DIV_MASK_WIDTH> mult_factor
) {

	bit<FEATURE_WIDTH> feature;
	registerFlowDuration.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;

	normalize(featPadded, min_feature, divisor_mask, mult_factor);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	bit<DISTANCE_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster0)*(normalized_feature - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<DISTANCE_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster1)*(normalized_feature - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<DISTANCE_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster2)*(normalized_feature - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<DISTANCE_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster3)*(normalized_feature - cluster3));
	registerDistances.write(3, clus3Dist);


	bit<DISTANCE_WIDTH> clus4Dist;
	registerDistances.read(clus4Dist, 4);
	clus4Dist = clus4Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster4)*(normalized_feature - cluster4));
	registerDistances.write(4, clus4Dist);


	bit<DISTANCE_WIDTH> clus5Dist;
	registerDistances.read(clus5Dist, 5);
	clus5Dist = clus5Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster5)*(normalized_feature - cluster5));
	registerDistances.write(5, clus5Dist);


	bit<DISTANCE_WIDTH> clus6Dist;
	registerDistances.read(clus6Dist, 6);
	clus6Dist = clus6Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster6)*(normalized_feature - cluster6));
	registerDistances.write(6, clus6Dist);


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
	bit<DIV_MASK_WIDTH> divisor_mask
	bit<DIV_MASK_WIDTH> mult_factor
) {

	bit<FEATURE_WIDTH> feature;
	registerInitialWindow.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;

	normalize(featPadded, min_feature, divisor_mask, mult_factor);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	bit<DISTANCE_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster0)*(normalized_feature - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<DISTANCE_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster1)*(normalized_feature - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<DISTANCE_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster2)*(normalized_feature - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<DISTANCE_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster3)*(normalized_feature - cluster3));
	registerDistances.write(3, clus3Dist);


	bit<DISTANCE_WIDTH> clus4Dist;
	registerDistances.read(clus4Dist, 4);
	clus4Dist = clus4Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster4)*(normalized_feature - cluster4));
	registerDistances.write(4, clus4Dist);


	bit<DISTANCE_WIDTH> clus5Dist;
	registerDistances.read(clus5Dist, 5);
	clus5Dist = clus5Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster5)*(normalized_feature - cluster5));
	registerDistances.write(5, clus5Dist);


	bit<DISTANCE_WIDTH> clus6Dist;
	registerDistances.read(clus6Dist, 6);
	clus6Dist = clus6Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster6)*(normalized_feature - cluster6));
	registerDistances.write(6, clus6Dist);


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
	bit<DIV_MASK_WIDTH> divisor_mask
	bit<DIV_MASK_WIDTH> mult_factor
) {

	bit<FEATURE_WIDTH> feature;
	registerSumWindow.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;

	normalize(featPadded, min_feature, divisor_mask, mult_factor);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	bit<DISTANCE_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster0)*(normalized_feature - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<DISTANCE_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster1)*(normalized_feature - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<DISTANCE_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster2)*(normalized_feature - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<DISTANCE_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster3)*(normalized_feature - cluster3));
	registerDistances.write(3, clus3Dist);


	bit<DISTANCE_WIDTH> clus4Dist;
	registerDistances.read(clus4Dist, 4);
	clus4Dist = clus4Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster4)*(normalized_feature - cluster4));
	registerDistances.write(4, clus4Dist);


	bit<DISTANCE_WIDTH> clus5Dist;
	registerDistances.read(clus5Dist, 5);
	clus5Dist = clus5Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster5)*(normalized_feature - cluster5));
	registerDistances.write(5, clus5Dist);


	bit<DISTANCE_WIDTH> clus6Dist;
	registerDistances.read(clus6Dist, 6);
	clus6Dist = clus6Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster6)*(normalized_feature - cluster6));
	registerDistances.write(6, clus6Dist);


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
	bit<DIV_MASK_WIDTH> divisor_mask
	bit<DIV_MASK_WIDTH> mult_factor
) {

	bit<FEATURE_WIDTH> feature;
	registerMaxWindow.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;

	normalize(featPadded, min_feature, divisor_mask, mult_factor);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	bit<DISTANCE_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster0)*(normalized_feature - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<DISTANCE_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster1)*(normalized_feature - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<DISTANCE_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster2)*(normalized_feature - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<DISTANCE_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster3)*(normalized_feature - cluster3));
	registerDistances.write(3, clus3Dist);


	bit<DISTANCE_WIDTH> clus4Dist;
	registerDistances.read(clus4Dist, 4);
	clus4Dist = clus4Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster4)*(normalized_feature - cluster4));
	registerDistances.write(4, clus4Dist);


	bit<DISTANCE_WIDTH> clus5Dist;
	registerDistances.read(clus5Dist, 5);
	clus5Dist = clus5Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster5)*(normalized_feature - cluster5));
	registerDistances.write(5, clus5Dist);


	bit<DISTANCE_WIDTH> clus6Dist;
	registerDistances.read(clus6Dist, 6);
	clus6Dist = clus6Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster6)*(normalized_feature - cluster6));
	registerDistances.write(6, clus6Dist);


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
	bit<DIV_MASK_WIDTH> divisor_mask
	bit<DIV_MASK_WIDTH> mult_factor
) {

	bit<FEATURE_WIDTH> feature;
	registerMinWindow.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;

	normalize(featPadded, min_feature, divisor_mask, mult_factor);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	bit<DISTANCE_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster0)*(normalized_feature - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<DISTANCE_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster1)*(normalized_feature - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<DISTANCE_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster2)*(normalized_feature - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<DISTANCE_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster3)*(normalized_feature - cluster3));
	registerDistances.write(3, clus3Dist);


	bit<DISTANCE_WIDTH> clus4Dist;
	registerDistances.read(clus4Dist, 4);
	clus4Dist = clus4Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster4)*(normalized_feature - cluster4));
	registerDistances.write(4, clus4Dist);


	bit<DISTANCE_WIDTH> clus5Dist;
	registerDistances.read(clus5Dist, 5);
	clus5Dist = clus5Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster5)*(normalized_feature - cluster5));
	registerDistances.write(5, clus5Dist);


	bit<DISTANCE_WIDTH> clus6Dist;
	registerDistances.read(clus6Dist, 6);
	clus6Dist = clus6Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster6)*(normalized_feature - cluster6));
	registerDistances.write(6, clus6Dist);


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
	bit<DIV_MASK_WIDTH> divisor_mask
	bit<DIV_MASK_WIDTH> mult_factor
) {

	bit<FEATURE_WIDTH> feature;
	registerMeanWindow.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;

	normalize(featPadded, min_feature, divisor_mask, mult_factor);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	bit<DISTANCE_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster0)*(normalized_feature - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<DISTANCE_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster1)*(normalized_feature - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<DISTANCE_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster2)*(normalized_feature - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<DISTANCE_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster3)*(normalized_feature - cluster3));
	registerDistances.write(3, clus3Dist);


	bit<DISTANCE_WIDTH> clus4Dist;
	registerDistances.read(clus4Dist, 4);
	clus4Dist = clus4Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster4)*(normalized_feature - cluster4));
	registerDistances.write(4, clus4Dist);


	bit<DISTANCE_WIDTH> clus5Dist;
	registerDistances.read(clus5Dist, 5);
	clus5Dist = clus5Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster5)*(normalized_feature - cluster5));
	registerDistances.write(5, clus5Dist);


	bit<DISTANCE_WIDTH> clus6Dist;
	registerDistances.read(clus6Dist, 6);
	clus6Dist = clus6Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster6)*(normalized_feature - cluster6));
	registerDistances.write(6, clus6Dist);


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
action actionCalcIsTCPDists(
	bit<NORMALIZED_WIDTH> cluster0,
	bit<NORMALIZED_WIDTH> cluster1,
	bit<NORMALIZED_WIDTH> cluster2,
	bit<NORMALIZED_WIDTH> cluster3,
	bit<NORMALIZED_WIDTH> cluster4,
	bit<NORMALIZED_WIDTH> cluster5,
	bit<NORMALIZED_WIDTH> cluster6,
	bit<TIMESTAMP_WIDTH> min_feature,
	bit<DIV_MASK_WIDTH> divisor_mask
	bit<DIV_MASK_WIDTH> mult_factor
) {

	bit<FEATURE_WIDTH> feature;
	registerIsTCP.read(feature, meta.hashKey);
	bit<TIMESTAMP_WIDTH> featPadded;
	featPadded = (bit<TIMESTAMP_WIDTH>) feature;

	normalize(featPadded, min_feature, divisor_mask, mult_factor);

	bit<NORMALIZED_WIDTH> normalized_feature;
	normalized_feature = meta.return_normalize;

	bit<DISTANCE_WIDTH> clus0Dist;
	registerDistances.read(clus0Dist, 0);
	clus0Dist = clus0Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster0)*(normalized_feature - cluster0));
	registerDistances.write(0, clus0Dist);


	bit<DISTANCE_WIDTH> clus1Dist;
	registerDistances.read(clus1Dist, 1);
	clus1Dist = clus1Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster1)*(normalized_feature - cluster1));
	registerDistances.write(1, clus1Dist);


	bit<DISTANCE_WIDTH> clus2Dist;
	registerDistances.read(clus2Dist, 2);
	clus2Dist = clus2Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster2)*(normalized_feature - cluster2));
	registerDistances.write(2, clus2Dist);


	bit<DISTANCE_WIDTH> clus3Dist;
	registerDistances.read(clus3Dist, 3);
	clus3Dist = clus3Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster3)*(normalized_feature - cluster3));
	registerDistances.write(3, clus3Dist);


	bit<DISTANCE_WIDTH> clus4Dist;
	registerDistances.read(clus4Dist, 4);
	clus4Dist = clus4Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster4)*(normalized_feature - cluster4));
	registerDistances.write(4, clus4Dist);


	bit<DISTANCE_WIDTH> clus5Dist;
	registerDistances.read(clus5Dist, 5);
	clus5Dist = clus5Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster5)*(normalized_feature - cluster5));
	registerDistances.write(5, clus5Dist);


	bit<DISTANCE_WIDTH> clus6Dist;
	registerDistances.read(clus6Dist, 6);
	clus6Dist = clus6Dist + (bit<DISTANCE_WIDTH>)((normalized_feature - cluster6)*(normalized_feature - cluster6));
	registerDistances.write(6, clus6Dist);


}
table tableCalcIsTCPDists {
	actions = {
		actionCalcIsTCPDists;
	}
	key = {
		meta.pktCount: ternary;
	}
	default_action = actionCalcIsTCPDists(0,0,0,0,0,0,0,0,0,0);
}
