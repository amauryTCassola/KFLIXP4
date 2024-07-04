from decimal import Decimal
import matplotlib.pyplot as plt
import numpy as np

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

# def test_normalization(x, x_scaled, featureParamsList):
#     n = len(x)
#     errors = [0 for i in range(len(featureParamsList))]
#     maxErrors = [0 for i in range(len(featureParamsList))]

#     for index in range(len(x)):
#         approxNorms = []
#         for param in featureParamsList:
#             name = param["name"]
#             mult_factor = param["mult_factor"]
#             div_mask = param["divisor_mask"]
#             min = param["min"]
#             value = x.iloc[index][name]
#             norm_value = normalize(value, min, div_mask, mult_factor)
#             approxNorms.append(norm_value)

#         for i in range(len(featureParamsList)):
#             error = abs(round(x_scaled[index][i]) - approxNorms[i])
#             errors[i] = errors[i] + error

#             # if error > 10:
#             #     print("problem: "+featureParamsList[i]["name"])
#             #     print("original value:"+ str(x.iloc[index][featureParamsList[i]["name"]]))
#             #     print("normalized: "+ str(round(x_scaled[index][i])))
#             #     print("approx: "+str(approxNorms[i]))
#             #     print("div_mask: "+str(featureParamsList[i]["divisor_mask"]))
#             #     print("mult_factor: "+str(featureParamsList[i]["mult_factor"]))

#             if error > maxErrors[i]:
#                 maxErrors[i] = error


#     meanErrors = [0 for i in range(len(featureParamsList))] 
#     for i in range(len(errors)):
#         meanErrors[i] = errors[i]/n

#     print("Mean errors: ")
#     print(meanErrors)
#     print("\nMax errors:")
#     print(maxErrors)

if __name__ == '__main__':

    result = normalize(8192, 0, 1048592, 0, 32)
    print(result)

    exit()
    values = np.array([i for i in range(1, 1001)])
    feat_max = max(values)
    feat_min = min(values)
    normParams = get_normalization_params(feat_max, feat_min, 1024, 32)

    print(normParams)

    normGTs = np.array([])
    normApprox =  np.array([])
    errors =  []

    for value in values:
        normalized_GT = ((value - feat_min) / (feat_max - feat_min))*1024
        normalized_approx = normalize(value, feat_min, normParams["divisor_mask"], normParams["mult_factor"], max_power = 16)
        
        error = abs(normalized_GT - normalized_approx)
        errors.append(error)

        normGTs = np.append(normGTs, [normalized_GT])
        normApprox = np.append(normApprox, [normalized_approx])

    max_error = max(errors)
    min_error = min(errors)
    sum_errors = sum(errors)
    mean_error = sum_errors/len(errors)

    print("max ", max_error)
    print("mean ", mean_error)

    plt.figure()
    plt.plot(values, normGTs)
    plt.xlabel("Valor de Atributo")
    plt.ylabel("Valor Normalizado")
    plt.title('Normalização Min-Max')

    plt.figure()
    plt.plot(values, normApprox)
    plt.xlabel("Valor de Atributo")
    plt.ylabel("Valor Normalizado")
    plt.title('Normalização Aproximada')
    plt.show()