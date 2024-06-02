//APPROXIMATE MEAN CALCULATION
//Inputs:
//exact_sum: exact sum of all values (including current value)
//approx_sum: if ||values|| is a power of 2, it is the exact sum.
//  Else, it is the last approx_sum - the last approx_mean + the value
//approx_mean: if ||values|| is a power of 2, it is the exact sum divided by ||values|| (through byte shifts)
//  Else, it is approx_sum divided by prev_pow2 (also through bit shifts)
//value: the current value of the feature being extracted
//meta.is_pow2: wether the current number of packets is a power of 2
//meta.shift_amount: how much a sum value needs to be shifted to get the mean (based on either ||values|| or prev_pow2)

//Outputs:
//meta.return_approx_mean: the current approximate mean
//meta.return_approx_sum: the current approximate sum

//This is action is supposed to be invoked by every feature action that needs a mean value
action approximate_mean(bit<TIMESTAMP_WIDTH> exact_sum, bit<TIMESTAMP_WIDTH> approx_sum, bit<TIMESTAMP_WIDTH> approx_mean, bit<TIMESTAMP_WIDTH> value){
    if ((meta.is_pow2 == 1) && (meta.shift_amount != 0)){
        meta.return_approx_sum = exact_sum;
        meta.return_approx_mean = exact_sum >> meta.shift_amount; //exact_sum / ||values||
    }else{
        if (meta.shift_amount > 0 && meta.prev_pow2 > 0){
            bit<TIMESTAMP_WIDTH> new_sum;
            bit<TIMESTAMP_WIDTH> new_mean;

            new_sum = approx_sum - approx_mean + value;
            new_mean = new_sum >> meta.shift_amount;

            meta.return_approx_mean = new_mean;
            meta.return_approx_sum = new_sum;
        }
    }
}

//Checks wether the current number of packets is a power of 2 or not
//And sets the appropriate shift amount for the mean calculation
action check_for_pow2_tern(bit<FEATURE_WIDTH> prev_pow2, bit<SHIFT_AMOUNT_WIDTH> shift_amount){
    if (meta.pktCount == prev_pow2){
        meta.is_pow2 = 1;
    }else{
        meta.is_pow2 = 0;
    }

    meta.prev_pow2 = prev_pow2;
    meta.shift_amount = shift_amount;
}

table checkPowerOf2{
    key = {
        meta.pktCount: ternary;
    }
    actions = {
        check_for_pow2_tern;
    }
    const entries = {
        //32w0xffffffff
        32w0x0001 &&& 32w0xffffffff : check_for_pow2_tern(1, 0);
        32w0x0002 &&& 32w0xfffffffe : check_for_pow2_tern(2, 1);
        32w0x0004 &&& 32w0xfffffffc : check_for_pow2_tern(4, 2);
        32w0x0008 &&& 32w0xfffffff8 : check_for_pow2_tern(8, 3);
        32w0x0010 &&& 32w0xfffffff0 : check_for_pow2_tern(16, 4);
        32w0x0020 &&& 32w0xffffffe0 : check_for_pow2_tern(32, 5);
        32w0x0040 &&& 32w0xffffffc0 : check_for_pow2_tern(64, 6);
        32w0x0080 &&& 32w0xffffff80 : check_for_pow2_tern(128, 7);
        32w0x0100 &&& 32w0xffffff00 : check_for_pow2_tern(256, 8);
        32w0x0200 &&& 32w0xfffffe00 : check_for_pow2_tern(512, 9);
        32w0x0400 &&& 32w0xfffffc00 : check_for_pow2_tern(1024, 10);
        32w0x0800 &&& 32w0xfffff800 : check_for_pow2_tern(2048, 11);
    }
    default_action = check_for_pow2_tern(0, 0);
}

//IAT only starts being computed on the second packet, so it is necessary
//to check the number of values before incrementing it
//Since a table cannot be applied twice, this second table is necessary
table checkPowerOf2ForIAT{
    key = {
        meta.pktCount: ternary;
    }
    actions = {
        check_for_pow2_tern;
    }
    const entries = {
        //32w0xffffffff
        32w0x0001 &&& 32w0xffffffff : check_for_pow2_tern(1, 0);
        32w0x0002 &&& 32w0xfffffffe : check_for_pow2_tern(2, 1);
        32w0x0004 &&& 32w0xfffffffc : check_for_pow2_tern(4, 2);
        32w0x0008 &&& 32w0xfffffff8 : check_for_pow2_tern(8, 3);
        32w0x0010 &&& 32w0xfffffff0 : check_for_pow2_tern(16, 4);
        32w0x0020 &&& 32w0xffffffe0 : check_for_pow2_tern(32, 5);
        32w0x0040 &&& 32w0xffffffc0 : check_for_pow2_tern(64, 6);
        32w0x0080 &&& 32w0xffffff80 : check_for_pow2_tern(128, 7);
        32w0x0100 &&& 32w0xffffff00 : check_for_pow2_tern(256, 8);
        32w0x0200 &&& 32w0xfffffe00 : check_for_pow2_tern(512, 9);
        32w0x0400 &&& 32w0xfffffc00 : check_for_pow2_tern(1024, 10);
        32w0x0800 &&& 32w0xfffff800 : check_for_pow2_tern(2048, 11);
    }
    default_action = check_for_pow2_tern(0, 0);
}