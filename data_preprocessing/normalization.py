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

def get_normalization_params(feat_max, feat_min, max_power = 24):
    #normX = (X - min) / (max - min)
    divisor = feat_max - feat_min
    divisor_rec = 1/divisor
    powers_of_2 = get_rec_powers_of_2(divisor_rec, max_power)

    divisor_mask = get_divisor_mask(powers_of_2)

    resultDict = {
        "min_feature": feat_min,
        "divisor_mask": divisor_mask
    }

    return resultDict