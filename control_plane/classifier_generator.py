import json
from rich import print
from normalizer_generator import createNormalizeAction

def write(file, string):
    file.write(string+"\n")

def writeLines(file, lines):
    for line in lines:
        write(file, line)

def writeResetDistances(file):
    write(file, "action actionResetDistances() {")
    for index in range(len(clusters)):
        write(file, "\tregisterDistances.write("+str(index)+", (bit<DISTANCE_WIDTH>)0);")
    
    write(file, "}\n")

    writeLines(file, [
        "table tableResetDistances {",
            "\tactions = {",
                "\t\tactionResetDistances();",
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
            "\tbit<DISTANCE_WIDTH> clus"+str(index)+"Dist;",
            "\tregisterDistances.read(clus"+str(index)+"Dist, "+str(index)+");"
        ])

    writeClassificationIf(file, 0)

    write(file, "\thdr.features.isVideo = (bit<16>)result;")

    write(file, "}")

    defaultCall = "actionClassify("
    for i in range(len(clusters)):
        if i is not len(clusters)-1:
            defaultCall = defaultCall+"0,"
        else:
            defaultCall = defaultCall+"0);"

    writeLines(file, [
        "table tableClassify {",
           "\tactions = {",
                "\t\tactionClassify;",
            "\t}",
            "\tkey = {",
                "\t\tmeta.pktCount: ternary;",
            "\t}",
            "\tdefault_action = "+defaultCall,
        "}"
    ])

def writeFeatureCalcAction(file, feature):
    write(file, "action actionCalc"+feature+"Dists(")
    for index in range(len(clusters)):
        write(file, "\tbit<NORMALIZED_WIDTH> cluster"+str(index)+",")

    writeLines(file, [
        "\tbit<TIMESTAMP_WIDTH> min_feature,",
        "\tbit<DIV_MASK_WIDTH> divisor_mask,",
        "\tbit<TIMESTAMP_WIDTH> mult_factor",
    ])

    if(["SumIat","MaxIat","MinIat","MeanIat","FlowDuration",].__contains__(feature)):
        writeLines(file, [
            ") {",
            "",
            "\tbit<TIMESTAMP_WIDTH> featPadded;",
            "\tregister"+feature+".read(featPadded, meta.hashKey);",
            "",
        ])
    elif(feature == "IsTCP"):
        writeLines(file, [
            ") {",
            "",
            "\tbit<1> feature;",
            "\tregister"+feature+".read(feature, meta.hashKey);",
            "\tbit<TIMESTAMP_WIDTH> featPadded;",
            "\tfeatPadded = (bit<TIMESTAMP_WIDTH>) feature;",
            "",
        ])
    else:
        writeLines(file, [
            ") {",
            "",
            "\tbit<FEATURE_WIDTH> feature;",
            "\tregister"+feature+".read(feature, meta.hashKey);",
            "\tbit<TIMESTAMP_WIDTH> featPadded;",
            "\tfeatPadded = (bit<TIMESTAMP_WIDTH>) feature;",
            "",
        ])

    writeLines(file, [
        "\tnormalize(featPadded, min_feature, divisor_mask, mult_factor);",
        "",
        "\tbit<NORMALIZED_WIDTH> normalized_feature;",
        "\tnormalized_feature = meta.return_normalize;",
        "",
    ])

    for index in range(len(clusters)):
        writeLines(file, [
            "\tcalc_distance(normalized_feature, cluster"+str(index)+", "+str(index)+");",
        ])

    write(file, "}")

def writeFeatureCalcTable(file, feature):

    tableName = "tableCalc"+feature+"Dists"
    actionName = "actionCalc"+feature+"Dists"
    defaultCall = "("

    for i in range(len(clusters)):
        defaultCall = defaultCall+"0,"

    defaultCall = defaultCall + "0,0,0)"


    writeLines(file, [
        "table "+tableName+" {",
        "\tactions = {",
        "\t\t"+actionName+";",
        "\t}",
        "\tkey = {",
        "\t\tmeta.pktCount: ternary;",
        "\t}",
        "\tdefault_action = "+actionName+defaultCall+";",
        "}"
    ])

def writeFeatureCalcs(file):
    for feature in features:
        writeFeatureCalcAction(file, feature["name"])
        writeFeatureCalcTable(file, feature["name"])

def createOnlineClassifier():
    classifier = open("onlineClassifier.p4", "w")
    clusterNumber = len(clusters)

    writeResetDistances(classifier)
    writeClassify(classifier)
    writeFeatureCalcs(classifier)

    classifier.close()

def getIpForwardingEntries(dictionary):
    dictionary["table_entries"] = [
      {
        "table": "MyIngress.ipv4_lpm",
        "action_name": "MyIngress.ipv4_forward",
        "action_params": {
          "dstAddr": "08:00:00:00:01:11",
          "port": 1
        },
        "priority": 0
      },
    ]

def getFeatureEntries(feature, dictionary):
    paramsDict = {}
    featureName = feature["name"]
    
    tableName = "MyIngress.tableCalc"+featureName+"Dists"
    actionName = "MyIngress.actionCalc"+featureName+"Dists"

    for clusterIndex in range(len(clusters)):
        paramsDict["cluster"+str(clusterIndex)] = round(clusters[clusterIndex][featureName])

    paramsDict["min_feature"] = int(feature["min"])
    paramsDict["divisor_mask"] = int(feature["divisor_mask"])
    paramsDict["mult_factor"] = int(feature["mult_factor"])

    dict = {
        "table": tableName,
        "action_name": actionName,
        "action_params": paramsDict,
        "priority": 1
      },

    dictionary["table_entries"] += dict

def getClassifierEntry(dictionary):
    paramsDict = {}

    for clusterIndex in range(len(clusters)):
        paramsDict["cluster"+str(clusterIndex)] = int(clusters[clusterIndex]["isVideo"])

    classifyDict = {
        "table": "MyIngress.tableClassify",
        "action_name": "MyIngress.actionClassify",
        "action_params": paramsDict,
        "priority": 1
      },

    dictionary["table_entries"] += classifyDict

def getTableEntriesDictionary():
    dictionary = {
        "target": "bmv2",
        "p4info": "build/main.p4.p4info.txt",
        "bmv2_json": "build/main.json",
        "table_entries": []
    }

    getIpForwardingEntries(dictionary)

    for feature in features:
        getFeatureEntries(feature, dictionary)
        
    getClassifierEntry(dictionary)

    return dictionary

def createTableEntries():
    runtime = open("s1-runtime.json", "w")
    dictionary = getTableEntriesDictionary()
    json_object = json.dumps(dictionary, indent=4)
    runtime.write(json_object)

def generateClassifier(featureParamsList, centroids):
    global features
    features = featureParamsList
    global clusters 
    clusters =  centroids
    createOnlineClassifier()
    createTableEntries()

if __name__ == '__main__':
    with open('trainer_result.json') as trainer_result:
        result_dict = json.load(trainer_result)
        featParamsList = result_dict["featureParams"]
        centroidList = result_dict["centroids"]
        generateClassifier(featParamsList, centroidList)
    createNormalizeAction()
    