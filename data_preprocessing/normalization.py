from decimal import Decimal

def get_rec_powers_of_2(x, max_power):
    powers = []
    power = 1
    tentResult = 0
    while power <= max_power:
        temp = tentResult + 1/(2**power)
        if temp <= x:
            powers.append(power)
            tentResult = temp
        power += 1
    return powers

def get_divisor_mask(powersOf2):
    power = 1
    divisor_mask = 0
    for power in powersOf2:
        divisor_mask = divisor_mask + (2**(power-1))
    return divisor_mask

def get_normalization_params(feat_max, feat_min, scale_max = 1024, max_power = 32):
    #normX = a + (X - min)*(b-a) / (max - min)
    #normX = (X - min)*1024 / (max-min)
    #normX = (X - min) / ((max-min)/1024)
    
    divisor = feat_max - feat_min
    scaled_divisor = divisor/scale_max
    divisor_rec = 1/scaled_divisor

    if(divisor_rec < 1):
        powers_of_2 = get_rec_powers_of_2(divisor_rec, max_power)
        multiply_factor = 0
    else: 
        decimal_part = float(Decimal(str(divisor_rec)) % 1)
        integer_part = round(divisor_rec - decimal_part)
        multiply_factor = integer_part
        powers_of_2 = get_rec_powers_of_2(decimal_part, max_power)

    divisor_mask = get_divisor_mask(powers_of_2)

    resultDict = {
        "min_feature": feat_min,
        "divisor_mask": divisor_mask,
        "mult_factor": multiply_factor
    }

    return resultDict

def normalize(feature, min_feature, div_mask, mult_factor, max_power = 32):
    dividend = int(feature - min_feature)
    normalized_feature = 0

    if div_mask == 0:
        return feature*mult_factor
    
    for power in range(1, max_power):
        mask = 2**(power-1)
        bit = div_mask & mask
        if bit != 0:
            normalized_feature = normalized_feature + (dividend >> power)

    return normalized_feature + (dividend*mult_factor)