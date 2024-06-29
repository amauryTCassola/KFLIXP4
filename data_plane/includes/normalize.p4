//APPROXIMATE NORMALIZATION
//Inputs:
//feature: the feature value, padded to TIMESTAMP_WIDTH
//min_feature: the minimal value of the feature from the dataset
//divisor_mask: a 32-bit mask representing the power of 2 decomposition of (max-min)
//mult_factor: a value for multiplication

//Outputs:
//meta.return_normalize: a 10-bit value with the normalized feature value

#define DIV_MASK_WIDTH 32

action normalize(bit<TIMESTAMP_WIDTH> feature, bit<TIMESTAMP_WIDTH> min_feature, bit<DIV_MASK_WIDTH> divisor_mask, bit<TIMESTAMP_WIDTH> mult_factor){

	bit<TIMESTAMP_WIDTH> dividend;
	if(feature >= min_feature){
		dividend = feature - min_feature;
	} else {
		dividend = 0;
	}

	bit<TIMESTAMP_WIDTH> normalized_feature;
	normalized_feature = 0;

	bit<DIV_MASK_WIDTH> div_mask = divisor_mask;
	bit<DIV_MASK_WIDTH> mask = 1;
	bit<DIV_MASK_WIDTH> mask_result = (div_mask & mask);
	bit<8> shift_amount = 1;

	normalized_feature = normalized_feature + (bit<TIMESTAMP_WIDTH>)mask_result*(dividend >> shift_amount);

	shift_amount = 2;
	div_mask = div_mask >> 1;
	mask_result = (div_mask & mask);
	normalized_feature = normalized_feature + (bit<TIMESTAMP_WIDTH>)mask_result*(dividend >> shift_amount);

	shift_amount = 3;
	div_mask = div_mask >> 1;
	mask_result = (div_mask & mask);
	normalized_feature = normalized_feature + (bit<TIMESTAMP_WIDTH>)mask_result*(dividend >> shift_amount);

	shift_amount = 4;
	div_mask = div_mask >> 1;
	mask_result = (div_mask & mask);
	normalized_feature = normalized_feature + (bit<TIMESTAMP_WIDTH>)mask_result*(dividend >> shift_amount);

	shift_amount = 5;
	div_mask = div_mask >> 1;
	mask_result = (div_mask & mask);
	normalized_feature = normalized_feature + (bit<TIMESTAMP_WIDTH>)mask_result*(dividend >> shift_amount);

	shift_amount = 6;
	div_mask = div_mask >> 1;
	mask_result = (div_mask & mask);
	normalized_feature = normalized_feature + (bit<TIMESTAMP_WIDTH>)mask_result*(dividend >> shift_amount);

	shift_amount = 7;
	div_mask = div_mask >> 1;
	mask_result = (div_mask & mask);
	normalized_feature = normalized_feature + (bit<TIMESTAMP_WIDTH>)mask_result*(dividend >> shift_amount);

	shift_amount = 8;
	div_mask = div_mask >> 1;
	mask_result = (div_mask & mask);
	normalized_feature = normalized_feature + (bit<TIMESTAMP_WIDTH>)mask_result*(dividend >> shift_amount);

	shift_amount = 9;
	div_mask = div_mask >> 1;
	mask_result = (div_mask & mask);
	normalized_feature = normalized_feature + (bit<TIMESTAMP_WIDTH>)mask_result*(dividend >> shift_amount);

	shift_amount = 10;
	div_mask = div_mask >> 1;
	mask_result = (div_mask & mask);
	normalized_feature = normalized_feature + (bit<TIMESTAMP_WIDTH>)mask_result*(dividend >> shift_amount);

	shift_amount = 11;
	div_mask = div_mask >> 1;
	mask_result = (div_mask & mask);
	normalized_feature = normalized_feature + (bit<TIMESTAMP_WIDTH>)mask_result*(dividend >> shift_amount);

	shift_amount = 12;
	div_mask = div_mask >> 1;
	mask_result = (div_mask & mask);
	normalized_feature = normalized_feature + (bit<TIMESTAMP_WIDTH>)mask_result*(dividend >> shift_amount);

	shift_amount = 13;
	div_mask = div_mask >> 1;
	mask_result = (div_mask & mask);
	normalized_feature = normalized_feature + (bit<TIMESTAMP_WIDTH>)mask_result*(dividend >> shift_amount);

	shift_amount = 14;
	div_mask = div_mask >> 1;
	mask_result = (div_mask & mask);
	normalized_feature = normalized_feature + (bit<TIMESTAMP_WIDTH>)mask_result*(dividend >> shift_amount);

	shift_amount = 15;
	div_mask = div_mask >> 1;
	mask_result = (div_mask & mask);
	normalized_feature = normalized_feature + (bit<TIMESTAMP_WIDTH>)mask_result*(dividend >> shift_amount);

	shift_amount = 16;
	div_mask = div_mask >> 1;
	mask_result = (div_mask & mask);
	normalized_feature = normalized_feature + (bit<TIMESTAMP_WIDTH>)mask_result*(dividend >> shift_amount);

	shift_amount = 17;
	div_mask = div_mask >> 1;
	mask_result = (div_mask & mask);
	normalized_feature = normalized_feature + (bit<TIMESTAMP_WIDTH>)mask_result*(dividend >> shift_amount);

	shift_amount = 18;
	div_mask = div_mask >> 1;
	mask_result = (div_mask & mask);
	normalized_feature = normalized_feature + (bit<TIMESTAMP_WIDTH>)mask_result*(dividend >> shift_amount);

	shift_amount = 19;
	div_mask = div_mask >> 1;
	mask_result = (div_mask & mask);
	normalized_feature = normalized_feature + (bit<TIMESTAMP_WIDTH>)mask_result*(dividend >> shift_amount);

	shift_amount = 20;
	div_mask = div_mask >> 1;
	mask_result = (div_mask & mask);
	normalized_feature = normalized_feature + (bit<TIMESTAMP_WIDTH>)mask_result*(dividend >> shift_amount);

	shift_amount = 21;
	div_mask = div_mask >> 1;
	mask_result = (div_mask & mask);
	normalized_feature = normalized_feature + (bit<TIMESTAMP_WIDTH>)mask_result*(dividend >> shift_amount);

	shift_amount = 22;
	div_mask = div_mask >> 1;
	mask_result = (div_mask & mask);
	normalized_feature = normalized_feature + (bit<TIMESTAMP_WIDTH>)mask_result*(dividend >> shift_amount);

	shift_amount = 23;
	div_mask = div_mask >> 1;
	mask_result = (div_mask & mask);
	normalized_feature = normalized_feature + (bit<TIMESTAMP_WIDTH>)mask_result*(dividend >> shift_amount);

	shift_amount = 24;
	div_mask = div_mask >> 1;
	mask_result = (div_mask & mask);
	normalized_feature = normalized_feature + (bit<TIMESTAMP_WIDTH>)mask_result*(dividend >> shift_amount);

	shift_amount = 25;
	div_mask = div_mask >> 1;
	mask_result = (div_mask & mask);
	normalized_feature = normalized_feature + (bit<TIMESTAMP_WIDTH>)mask_result*(dividend >> shift_amount);

	shift_amount = 26;
	div_mask = div_mask >> 1;
	mask_result = (div_mask & mask);
	normalized_feature = normalized_feature + (bit<TIMESTAMP_WIDTH>)mask_result*(dividend >> shift_amount);

	shift_amount = 27;
	div_mask = div_mask >> 1;
	mask_result = (div_mask & mask);
	normalized_feature = normalized_feature + (bit<TIMESTAMP_WIDTH>)mask_result*(dividend >> shift_amount);

	shift_amount = 28;
	div_mask = div_mask >> 1;
	mask_result = (div_mask & mask);
	normalized_feature = normalized_feature + (bit<TIMESTAMP_WIDTH>)mask_result*(dividend >> shift_amount);

	shift_amount = 29;
	div_mask = div_mask >> 1;
	mask_result = (div_mask & mask);
	normalized_feature = normalized_feature + (bit<TIMESTAMP_WIDTH>)mask_result*(dividend >> shift_amount);

	shift_amount = 30;
	div_mask = div_mask >> 1;
	mask_result = (div_mask & mask);
	normalized_feature = normalized_feature + (bit<TIMESTAMP_WIDTH>)mask_result*(dividend >> shift_amount);

	shift_amount = 31;
	div_mask = div_mask >> 1;
	mask_result = (div_mask & mask);
	normalized_feature = normalized_feature + (bit<TIMESTAMP_WIDTH>)mask_result*(dividend >> shift_amount);

	shift_amount = 32;
	div_mask = div_mask >> 1;
	mask_result = (div_mask & mask);
	normalized_feature = normalized_feature + (bit<TIMESTAMP_WIDTH>)mask_result*(dividend >> shift_amount);


	meta.return_normalize = (bit<NORMALIZED_WIDTH>)(normalized_feature + (dividend*mult_factor));
}
