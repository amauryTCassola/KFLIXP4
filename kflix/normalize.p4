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

    bit<DIV_MASK_WIDTH> div_mask = divisor_mask;
    bit<DIV_MASK_WIDTH> mask = 1;
    bit<DIV_MASK_WIDTH> mask_result = (div_mask & mask);
    bit<8> shift_amount = 1;

    normalized_feature = normalized_feature + (bit<SHIFTED_TIMESTAMP_WIDTH>)mask_result*(shifted_dividend >> shift_amount);

    shift_amount = 2;
    div_mask = div_mask >> 1;
    mask_result = (div_mask & mask);
    normalized_feature = normalized_feature + (shifted_dividend >> shift_amount)*(bit<SHIFTED_TIMESTAMP_WIDTH>)mask_result;

    shift_amount = 3;
    div_mask = div_mask >> 1;
    mask_result = (div_mask & mask);
    normalized_feature = normalized_feature + (shifted_dividend >> shift_amount)*(bit<SHIFTED_TIMESTAMP_WIDTH>)mask_result;

    shift_amount = 4;
    div_mask = div_mask >> 1;
    mask_result = (div_mask & mask);
    normalized_feature = normalized_feature + (shifted_dividend >> shift_amount)*(bit<SHIFTED_TIMESTAMP_WIDTH>)mask_result;

    shift_amount = 5;
    div_mask = div_mask >> 1;
    mask_result = (div_mask & mask);
    normalized_feature = normalized_feature + (shifted_dividend >> shift_amount)*(bit<SHIFTED_TIMESTAMP_WIDTH>)mask_result;

    shift_amount = 6;
    div_mask = div_mask >> 1;
    mask_result = (div_mask & mask);
    normalized_feature = normalized_feature + (shifted_dividend >> shift_amount)*(bit<SHIFTED_TIMESTAMP_WIDTH>)mask_result;

    shift_amount = 7;
    div_mask = div_mask >> 1;
    mask_result = (div_mask & mask);
    normalized_feature = normalized_feature + (shifted_dividend >> shift_amount)*(bit<SHIFTED_TIMESTAMP_WIDTH>)mask_result;

    shift_amount = 8;
    div_mask = div_mask >> 1;
    mask_result = (div_mask & mask);
    normalized_feature = normalized_feature + (shifted_dividend >> shift_amount)*(bit<SHIFTED_TIMESTAMP_WIDTH>)mask_result;

    shift_amount = 9;
    div_mask = div_mask >> 1;
    mask_result = (div_mask & mask);
    normalized_feature = normalized_feature + (shifted_dividend >> shift_amount)*(bit<SHIFTED_TIMESTAMP_WIDTH>)mask_result;

    shift_amount = 10;
    div_mask = div_mask >> 1;
    mask_result = (div_mask & mask);
    normalized_feature = normalized_feature + (shifted_dividend >> shift_amount)*(bit<SHIFTED_TIMESTAMP_WIDTH>)mask_result;

    shift_amount = 11;
    div_mask = div_mask >> 1;
    mask_result = (div_mask & mask);
    normalized_feature = normalized_feature + (shifted_dividend >> shift_amount)*(bit<SHIFTED_TIMESTAMP_WIDTH>)mask_result;

    shift_amount = 12;
    div_mask = div_mask >> 1;
    mask_result = (div_mask & mask);
    normalized_feature = normalized_feature + (shifted_dividend >> shift_amount)*(bit<SHIFTED_TIMESTAMP_WIDTH>)mask_result;

    shift_amount = 13;
    div_mask = div_mask >> 1;
    mask_result = (div_mask & mask);
    normalized_feature = normalized_feature + (shifted_dividend >> shift_amount)*(bit<SHIFTED_TIMESTAMP_WIDTH>)mask_result;

    shift_amount = 14;
    div_mask = div_mask >> 1;
    mask_result = (div_mask & mask);
    normalized_feature = normalized_feature + (shifted_dividend >> shift_amount)*(bit<SHIFTED_TIMESTAMP_WIDTH>)mask_result;

    shift_amount = 15;
    div_mask = div_mask >> 1;
    mask_result = (div_mask & mask);
    normalized_feature = normalized_feature + (shifted_dividend >> shift_amount)*(bit<SHIFTED_TIMESTAMP_WIDTH>)mask_result;

    shift_amount = 16;
    div_mask = div_mask >> 1;
    mask_result = (div_mask & mask);
    normalized_feature = normalized_feature + (shifted_dividend >> shift_amount)*(bit<SHIFTED_TIMESTAMP_WIDTH>)mask_result;

    shift_amount = 17;
    div_mask = div_mask >> 1;
    mask_result = (div_mask & mask);
    normalized_feature = normalized_feature + (shifted_dividend >> shift_amount)*(bit<SHIFTED_TIMESTAMP_WIDTH>)mask_result;

    shift_amount = 18;
    div_mask = div_mask >> 1;
    mask_result = (div_mask & mask);
    normalized_feature = normalized_feature + (shifted_dividend >> shift_amount)*(bit<SHIFTED_TIMESTAMP_WIDTH>)mask_result;

    shift_amount = 19;
    div_mask = div_mask >> 1;
    mask_result = (div_mask & mask);
    normalized_feature = normalized_feature + (shifted_dividend >> shift_amount)*(bit<SHIFTED_TIMESTAMP_WIDTH>)mask_result;

    shift_amount = 20;
    div_mask = div_mask >> 1;
    mask_result = (div_mask & mask);
    normalized_feature = normalized_feature + (shifted_dividend >> shift_amount)*(bit<SHIFTED_TIMESTAMP_WIDTH>)mask_result;

    shift_amount = 21;
    div_mask = div_mask >> 1;
    mask_result = (div_mask & mask);
    normalized_feature = normalized_feature + (shifted_dividend >> shift_amount)*(bit<SHIFTED_TIMESTAMP_WIDTH>)mask_result;

    shift_amount = 22;
    div_mask = div_mask >> 1;
    mask_result = (div_mask & mask);
    normalized_feature = normalized_feature + (shifted_dividend >> shift_amount)*(bit<SHIFTED_TIMESTAMP_WIDTH>)mask_result;

    shift_amount = 23;
    div_mask = div_mask >> 1;
    mask_result = (div_mask & mask);
    normalized_feature = normalized_feature + (shifted_dividend >> shift_amount)*(bit<SHIFTED_TIMESTAMP_WIDTH>)mask_result;

    shift_amount = 24;
    div_mask = div_mask >> 1;
    mask_result = (div_mask & mask);
    normalized_feature = normalized_feature + (shifted_dividend >> shift_amount)*(bit<SHIFTED_TIMESTAMP_WIDTH>)mask_result;


    meta.return_normalize = (bit<NORMALIZED_WIDTH>)normalized_feature;
}
