
#idea: approximate a division by a series of byte shifts, decomposing the reciprocal of the divisor in powers of 2

from random import randint
from sklearn.preprocessing import minmax_scale

def get_rec_powers_of_2(x, max_power = 24):
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

def generateFeat():
    n = randint(200, 1000)
    feat = []
    for i in range(n):
        feat.append(randint(0, 64400))

    return feat

def calculation(accuracy = 10):
    feat1 = generateFeat()

    feat1Normalized = minmax_scale(feat1)

    _min = min(feat1)
    _max = max(feat1)

    divisor = _max - _min

    powers = get_rec_powers_of_2(1/divisor)

    feat1ApproxNorm = []

    for i in range(len(feat1)):
        dividend = feat1[i]-_min
        shiftedDividend = dividend << accuracy
        normalizedValue = 0
        for power in powers:
            normalizedValue = normalizedValue + (shiftedDividend >> power)

        feat1ApproxNorm.append(normalizedValue)

    print("|Value\t|Normalized\t|Normalized*1024\t|ApproxNorm\t|Error|")
    for i in range(len(feat1)):
        value = str(feat1[i])
        normalized = str(feat1Normalized[i])
        normalizedShifted = str(feat1Normalized[i]*(2**accuracy))
        approxNorm = str(feat1ApproxNorm[i])
        error = str( (feat1Normalized[i]*(2**accuracy)) - feat1ApproxNorm[i] )

        print("|"+value+"\t|"+normalized+"\t|"+normalizedShifted+"\t|"+approxNorm+"\t|"+error)


print(get_rec_powers_of_2(1/96))

exit()
divRec = 1/divisor

shift = 16

divRecK = get_dec(divRec, 10)

print(divRec)
print(divRecK)
print("\n\n")

for x in feat1:
    feat1ApproxNorm.append((x - min)*divRecK)


for i in range(len(feat1)):
    print(str(feat1[i]) + " : "+str(feat1Normalized[i]*(10**10))+" : "+str(feat1ApproxNorm[i])+": error: "+str((feat1Normalized[i]*(10**10)) - (feat1ApproxNorm[i])))




# 882
# 441 + 55 + 27 + 13 + 3 + 1 = 540
# 
# 
#