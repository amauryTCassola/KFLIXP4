//APPROXIMATE NORMALIZATION
//Inputs:
//feature: the feature value, padded to TIMESTAMP_WIDTH
//min_feature: the minimal value of the feature from the dataset
//divisor_mask: a 24-bit mask representing the power of 2 decomposition of (max-min)

//Outputs:
//meta.return_normalize: a 10-bit value with the normalized feature value

action normalize(bit<TIMESTAMP_WIDTH> feature, bit<TIMESTAMP_WIDTH> min_feature, bit<DIV_MASK_WIDTH> divisor_mask){

    bit<TIMESTAMP_WIDTH> dividend;
    if(feature >= min_feature){
        dividend = feature - min_feature;
    } else {
        dividend = 0;
    }
    
    bit<SHIFTED_TIMESTAMP_WIDTH> shifted_dividend;
    shifted_dividend = dividend << 10;

    bit<SHIFTED_TIMESTAMP_WIDTH> normalized_feature;
    normalized_feature = 0;

    bit<DIV_MASK_WIDTH> zero = 0;

    if(divisor_mask & (bit<DIV_MASK_WIDTH>)1 != zero){
	    normalized_feature = normalized_feature + (shifted_dividend >> 1);
    }
    if(divisor_mask & (bit<DIV_MASK_WIDTH>)2 != zero){
      normalized_feature = normalized_feature + (shifted_dividend >> 2);
    }
    if(divisor_mask & (bit<DIV_MASK_WIDTH>)4 != zero){
      normalized_feature = normalized_feature + (shifted_dividend >> 3);
    }
    if(divisor_mask & (bit<DIV_MASK_WIDTH>)8 != zero){
      normalized_feature = normalized_feature + (shifted_dividend >> 4);
    }
    if(divisor_mask & (bit<DIV_MASK_WIDTH>)16 != zero){
      normalized_feature = normalized_feature + (shifted_dividend >> 5);
    }
    if(divisor_mask & (bit<DIV_MASK_WIDTH>)32 != zero){
      normalized_feature = normalized_feature + (shifted_dividend >> 6);
    }
    if(divisor_mask & (bit<DIV_MASK_WIDTH>)64 != zero){
      normalized_feature = normalized_feature + (shifted_dividend >> 7);
    }
    if(divisor_mask & (bit<DIV_MASK_WIDTH>)128 != zero){
      normalized_feature = normalized_feature + (shifted_dividend >> 8);
    }
    if(divisor_mask & (bit<DIV_MASK_WIDTH>)256 != zero){
      normalized_feature = normalized_feature + (shifted_dividend >> 9);
    }
    if(divisor_mask & (bit<DIV_MASK_WIDTH>)512 != zero){
      normalized_feature = normalized_feature + (shifted_dividend >> 10);
    }
    if(divisor_mask & (bit<DIV_MASK_WIDTH>)1024 != zero){
      normalized_feature = normalized_feature + (shifted_dividend >> 11);
    }
    if(divisor_mask & (bit<DIV_MASK_WIDTH>)2048 != zero){
      normalized_feature = normalized_feature + (shifted_dividend >> 12);
    }
    if(divisor_mask & (bit<DIV_MASK_WIDTH>)4096 != zero){
      normalized_feature = normalized_feature + (shifted_dividend >> 13);
    }
    if(divisor_mask & (bit<DIV_MASK_WIDTH>)8192 != zero){
      normalized_feature = normalized_feature + (shifted_dividend >> 14);
    }
    if(divisor_mask & (bit<DIV_MASK_WIDTH>)16384 != zero){
      normalized_feature = normalized_feature + (shifted_dividend >> 15);
    }
    if(divisor_mask & (bit<DIV_MASK_WIDTH>)32768 != zero){
      normalized_feature = normalized_feature + (shifted_dividend >> 16);
    }
    if(divisor_mask & (bit<DIV_MASK_WIDTH>)65536 != zero){
      normalized_feature = normalized_feature + (shifted_dividend >> 17);
    }
    if(divisor_mask & (bit<DIV_MASK_WIDTH>)131072 != zero){
      normalized_feature = normalized_feature + (shifted_dividend >> 18);
    }
    if(divisor_mask & (bit<DIV_MASK_WIDTH>)262144 != zero){
      normalized_feature = normalized_feature + (shifted_dividend >> 19);
    }
    if(divisor_mask & (bit<DIV_MASK_WIDTH>)524288 != zero){
      normalized_feature = normalized_feature + (shifted_dividend >> 20);
    }
    if(divisor_mask & (bit<DIV_MASK_WIDTH>)1048576 != zero){
      normalized_feature = normalized_feature + (shifted_dividend >> 21);
    }
    if(divisor_mask & (bit<DIV_MASK_WIDTH>)2097152 != zero){
      normalized_feature = normalized_feature + (shifted_dividend >> 22);
    }
    if(divisor_mask & (bit<DIV_MASK_WIDTH>)4194304 != zero){
      normalized_feature = normalized_feature + (shifted_dividend >> 23);
    }
    if(divisor_mask & (bit<DIV_MASK_WIDTH>)8388608 != zero){
      normalized_feature = normalized_feature + (shifted_dividend >> 24);
    }

    meta.return_normalize = (bit<NORMALIZED_WIDTH>)normalized_feature;
}