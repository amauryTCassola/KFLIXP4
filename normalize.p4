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
