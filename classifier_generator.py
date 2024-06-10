clusters = [
    {
        "PktCount":0,
        "SumPktLength":0,
        "MaxPktLength":0,
        "MinPktLength":0,
        "MeanPktLength":0,
        "SumIat":0,
        "MaxIat":0,
        "MinIat":0,
        "MeanIat":0,
        "FlowDuration":0,
        "InitialWindow":0,
        "SumWindow":0,
        "MaxWindow":0,
        "MinWindow":0,
        "MeanWindow":0,
        "isVideo": 0,
    },
    {
        "PktCount":5,
        "PktLength":5,
        "MaxPktLength":5,
        "MinPktLength":5,
        "MeanPktLength":5,
        "SumIat":5,
        "MaxIat":5,
        "MinIat":5,
        "MeanIat":5,
        "FlowDuration":5,
        "InitialWindow":5,
        "SumWindow":5,
        "MaxWindow":5,
        "MinWindow":5,
        "MeanWindow":5,
        "isVideo": 1,
    },
    {
        "PktCount":20,
        "PktLength":20,
        "MaxPktLength":20,
        "MinPktLength":20,
        "MeanPktLength":20,
        "SumIat":20,
        "MaxIat":20,
        "MinIat":20,
        "MeanIat":20,
        "FlowDuration":20,
        "InitialWindow":20,
        "SumWindow":20,
        "MaxWindow":20,
        "MinWindow":20,
        "MeanWindow":20,
        "isVideo": 0,
    },
    {
        "PktCount":15,
        "PktLength":15,
        "MaxPktLength":15,
        "MinPktLength":15,
        "MeanPktLength":15,
        "SumIat":15,
        "MaxIat":15,
        "MinIat":15,
        "MeanIat":15,
        "FlowDuration":15,
        "InitialWindow":15,
        "SumWindow":15,
        "MaxWindow":15,
        "MinWindow":15,
        "MeanWindow":15,
        "isVideo": 1,
    },
    
]

features = [
    "PktCount",
    "PktLength",
    "MaxPktLength",
    "MinPktLength",
    "MeanPktLength",
    "SumIat",
    "MaxIat",
    "MinIat",
    "MeanIat",
    "FlowDuration",
    "InitialWindow",
    "SumWindow",
    "MaxWindow",
    "MinWindow",
    "MeanWindow"
]

def write(file, string):
    file.write(string+"\n")

def writeLines(file, lines):
    for line in lines:
        write(file, line)

def writeResetDistances(file):
    write(file, "action actionResetDistances() {")
    for index in range(len(clusters)):
        write(file, "\tregisterDistances.write("+str(index)+", (bit<TIMESTAMP_WIDTH>)0);")
    
    write(file, "}\n")

    writeLines(file, [
        "table tableResetDistances {",
            "\tactions = {",
                "\t\tctionResetDistances();",
            "\t}",
            "\tdefault_action = actionResetDistances();",
        "}"
    ])

def writeClassificationIf(file, index):
    if index is len(clusters)-1:
        writeLines(file, [
            "\t\tresult = cluster"+str(index)+";",
            "\t\thdr.features.cluster = (bit<16>)"+str(index)+";",
        ])
        return
    

    write(file, "\tif(")

    for i in range(index+1,len(clusters)):
        if i is not len(clusters)-1:
            write(file, "\t\t clus"+str(index)+"Dist <= clus"+str(i)+"Dist &&")
        else:
            write(file, "\t\t clus"+str(index)+"Dist <= clus"+str(i)+"Dist")
        
    writeLines(file, [
        "\t) {",
        "\t\tresult = cluster"+str(index)+";",
        "\t\thdr.features.cluster = (bit<16>)"+str(index)+";",
        "\t} else {"
    ])

    writeClassificationIf(file, index+1)

    write(file, "\t}")


def writeClassify(file):
    write(file, "action actionClassify(")
    for index in range(len(clusters)):
        if index is not len(clusters)-1:
            write(file, "\tbit<BOOLEAN> cluster"+str(index)+",")
        else:
            write(file, "\tbit<BOOLEAN> cluster"+str(index))
    
    writeLines(file, [
        ") {",
        "\tbit<BOOLEAN> result;",
        "\tresult = 0;"
    ])

    for index in range(len(clusters)):
        writeLines(file, [
            "\tbit<TIMESTAMP_WIDTH> clus"+str(index)+"Dist;",
            "\tregisterDistances.read(clus"+str(index)+"Dist, "+str(index)+");"
        ])

    writeClassificationIf(file, 0)

    write(file, "\thdr.features.isVideo = (bit<16>)result;")

    write(file, "}")

    writeLines(file, [
        "table tableClassifier {",
           "\tactions = {",
                "\t\tactionClassify;",
            "\t}",
            "\tkey = {",
                "\t\tmeta.pktCount: ternary;",
            "\t}",
            "\tdefault_action = actionClassify(0,0,0,0,0,0,0,0,0,0);",
        "}"
    ])

def writeFeatureCalcAction(file, feature):
    write(file, "action actionCalc"+feature+"Dists(")
    for index in range(len(clusters)):
        if index is not len(clusters)-1:
            write(file, "\tbit<TIMESTAMP_WIDTH> cluster"+str(index)+",")
        else:
            write(file, "\tbit<TIMESTAMP_WIDTH> cluster"+str(index))

    writeLines(file, [
        ") {",
        "\tbit<FEATURE_WIDTH> feature;",
        "\tregister"+feature+".read(feature, meta.hashKey);",
        "\tbit<TIMESTAMP_WIDTH> featPadded;",
        "\tfeatPadded = (bit<TIMESTAMP_WIDTH>) feature;"
    ])

    for index in range(len(clusters)):
        writeLines(file, [
            "\tbit<TIMESTAMP_WIDTH> clus"+str(index)+"Dist;",
            "\tregisterDistances.read(clus"+str(index)+"Dist, "+str(index)+");",
            "\tclus"+str(index)+"Dist = clus"+str(index)+"Dist + ((featPadded - cluster"+str(index)+")*(featPadded - cluster"+str(index)+"));",
            "\tregisterDistances.write("+str(index)+", clus"+str(index)+"Dist);\n\n"
        ])

    write(file, "}")

def writeFeatureCalcTable(file, feature):
    writeLines(file, [
        "table tableCalc"+feature+"Dists {",
        "\tactions = {",
        "\t\tactionCalc"+feature+"Dists;",
        "\t}",
        "\tkey = {",
        "\t\tmeta.pktCount: ternary;",
        "\t}",
        "\tdefault_action = actionCalc"+feature+"Dists(0,0,0,0,0,0,0,0,0,0);",
        "}"
    ])

def writeFeatureCalcs(file):
    for feature in features:
        writeFeatureCalcAction(file, feature)
        writeFeatureCalcTable(file, feature)

def createOnlineClassifier():
    classifier = open("onlineClassifier.p4", "w")
    clusterNumber = len(clusters)
    write(classifier, '#define CLUSTER_NUMBER '+str(clusterNumber))
    write(classifier, "register<bit<TIMESTAMP_WIDTH>>(CLUSTER_NUMBER) registerDistances;")

    writeResetDistances(classifier)
    writeClassify(classifier)
    writeFeatureCalcs(classifier)

    classifier.close()

if __name__ == '__main__':
    createOnlineClassifier()
