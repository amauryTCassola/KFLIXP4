def write(file, string):
    file.write(string+"\n")

def writeLines(file, lines):
    for line in lines:
        write(file, line)

def createNormalizeAction(precision=32):
    file = open("normalize.p4", "w")

    writeLines(file, [
        "//APPROXIMATE NORMALIZATION",
        "//Inputs:",
        "//feature: the feature value, padded to TIMESTAMP_WIDTH",
        "//min_feature: the minimal value of the feature from the dataset",
        "//divisor_mask: a "+str(precision)+"-bit mask representing the power of 2 decomposition of (max-min)",
        "//mult_factor: a value for multiplication",
        "",
        "//Outputs:",
        "//meta.return_normalize: a 10-bit value with the normalized feature value",
        "",
        "#define DIV_MASK_WIDTH "+str(precision),
        "",
    ])

    writeLines(file, [
        "action normalize(bit<TIMESTAMP_WIDTH> feature, bit<TIMESTAMP_WIDTH> min_feature, bit<DIV_MASK_WIDTH> divisor_mask, bit<TIMESTAMP_WIDTH> mult_factor){",
        "",
            "\tbit<TIMESTAMP_WIDTH> dividend;",
            "\tif(feature >= min_feature){",
                "\t\tdividend = feature - min_feature;",
            "\t} else {",
                "\t\tdividend = 0;",
            "\t}",
            "",
            "\tbit<TIMESTAMP_WIDTH> normalized_feature;",
            "\tnormalized_feature = 0;",
            "",
            "\tbit<DIV_MASK_WIDTH> div_mask = divisor_mask;",
            "\tbit<DIV_MASK_WIDTH> mask = 1;",
            "\tbit<DIV_MASK_WIDTH> mask_result = (div_mask & mask);",
            "\tbit<8> shift_amount = 1;",
            "",
            "\tnormalized_feature = normalized_feature + (bit<TIMESTAMP_WIDTH>)mask_result*(dividend >> shift_amount);",
            "",
        ])
    
    for i in range(2, precision+1):
        writeLines(file, [
            "\tshift_amount = "+str(i)+";",
            "\tdiv_mask = div_mask >> 1;",
            "\tmask_result = (div_mask & mask);",
            "\tnormalized_feature = normalized_feature + (bit<TIMESTAMP_WIDTH>)mask_result*(dividend >> shift_amount);",
            "",
        ])

    writeLines(file, [
        "",
        "\tmeta.return_normalize = (bit<NORMALIZED_WIDTH>)(normalized_feature + (dividend*mult_factor));",
        "}",
    ])

if __name__ == '__main__':
    createNormalizeAction(32)
