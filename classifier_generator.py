features = [
    {
        "name": "PktCount",
        "min": 0,
        "divisor_mask": 5592384
    },
    {
        "name": "SumPktLength",
        "min": 0,
        "divisor_mask": 5592384
    },{
        "name": "MaxPktLength",
        "min": 0,
        "divisor_mask": 5592384
    },{
        "name": "MinPktLength",
        "min": 0,
        "divisor_mask": 5592384
    },{
        "name": "MeanPktLength",
        "min": 0,
        "divisor_mask": 5592384
    },{
        "name": "SumIat",
        "min": 0,
        "divisor_mask": 5592384
    },{
        "name": "MaxIat",
        "min": 0,
        "divisor_mask": 5592384
    },{
        "name": "MinIat",
        "min": 0,
        "divisor_mask": 5592384
    },{
        "name": "MeanIat",
        "min": 0,
        "divisor_mask": 5592384
    },{
        "name": "FlowDuration",
        "min": 0,
        "divisor_mask": 5592384
    },{
        "name": "InitialWindow",
        "min": 0,
        "divisor_mask": 5592384
    },{
        "name": "SumWindow",
        "min": 0,
        "divisor_mask": 5592384
    },{
        "name": "MaxWindow",
        "min": 0,
        "divisor_mask": 5592384
    },{
        "name": "MinWindow",
        "min": 0,
        "divisor_mask": 5592384
    },{
        "name": "MeanWindow",
        "min": 0,
        "divisor_mask": 5592384
    },
]

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
        "SumPktLength":5,
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
        "SumPktLength":20,
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
        "SumPktLength":15,
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


import json

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
            "\tbit<TIMESTAMP_WIDTH> clus"+str(index)+"Dist;",
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
        "table tableClassifier {",
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
        "\tbit<DIV_MASK_WIDTH> divisor_mask",
    ])

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
        "\tnormalize(featPadded, min_feature, divisor_mask);",
        "",
        "\tbit<NORMALIZED_WIDTH> normalized_feature;",
        "\tnormalized_feature = meta.return_normalize;",
        "",
    ])

    for index in range(len(clusters)):
        writeLines(file, [
            "\tbit<TIMESTAMP_WIDTH> clus"+str(index)+"Dist;",
            "\tregisterDistances.read(clus"+str(index)+"Dist, "+str(index)+");",
            "\tclus"+str(index)+"Dist = clus"+str(index)+"Dist + (bit<TIMESTAMP_WIDTH>)((normalized_feature - cluster"+str(index)+")*(normalized_feature - cluster"+str(index)+"));",
            "\tregisterDistances.write("+str(index)+", clus"+str(index)+"Dist);\n\n",
        ])

    write(file, "}")

def writeFeatureCalcTable(file, feature):

    tableName = "tableCalc"+feature+"Dists"
    actionName = "actionCalc"+feature+"Dists"
    defaultCall = "("

    for i in range(len(clusters)):
        defaultCall = defaultCall+"0,"

    defaultCall = defaultCall + "0,0)"


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
    classifier = open("kflix/onlineClassifier.p4", "w")
    clusterNumber = len(clusters)
    write(classifier, '#define CLUSTER_NUMBER '+str(clusterNumber))
    write(classifier, "register<bit<TIMESTAMP_WIDTH>>(CLUSTER_NUMBER) registerDistances;")

    writeResetDistances(classifier)
    writeClassify(classifier)
    writeFeatureCalcs(classifier)

    classifier.close()

def getIpForwardingEntries(dictionary):
    dictionary["table_entries"] = [
        {
        "table": "MyIngress.ipv4_lpm",
        "default_action": True,
        "action_name": "MyIngress.drop",
        "action_params": { }
      },
      {
        "table": "MyIngress.ipv4_lpm",
        "match": {
          "hdr.ipv4.dstAddr": ["10.0.1.1", 32]
        },
        "action_name": "MyIngress.ipv4_forward",
        "action_params": {
          "dstAddr": "08:00:00:00:01:11",
          "port": 1
        }
      },
      {
        "table": "MyIngress.ipv4_lpm",
        "match": {
          "hdr.ipv4.dstAddr": ["10.0.2.2", 32]
        },
        "action_name": "MyIngress.ipv4_forward",
        "action_params": {
          "dstAddr": "08:00:00:00:02:22",
          "port": 2
        }
      },
      {
        "table": "MyIngress.ipv4_lpm",
        "match": {
          "hdr.ipv4.dstAddr": ["10.0.3.3", 32]
        },
        "action_name": "MyIngress.ipv4_forward",
        "action_params": {
          "dstAddr": "08:00:00:00:03:00",
          "port": 3
        }
      },
      {
        "table": "MyIngress.ipv4_lpm",
        "match": {
          "hdr.ipv4.dstAddr": ["10.0.4.4", 32]
        },
        "action_name": "MyIngress.ipv4_forward",
        "action_params": {
          "dstAddr": "08:00:00:00:04:00",
          "port": 4
        }
      }
    ]

def getFeatureEntries(feature, dictionary):
    paramsDict = {}
    featureName = feature["name"]
    
    tableName = "MyIngress.tableCalc"+featureName+"Dists"
    actionName = "MyIngress.actionCalc"+featureName+"Dists"

    for clusterIndex in range(len(clusters)):
        paramsDict["cluster"+str(clusterIndex)] = clusters[clusterIndex][featureName]

    paramsDict["min_feature"] = feature["min"]
    paramsDict["divisor_mask"] = feature["divisor_mask"]

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
        paramsDict["cluster"+str(clusterIndex)] = clusters[clusterIndex]["isVideo"]

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
    runtime = open("kflix/s1-runtime.json", "w")
    dictionary = getTableEntriesDictionary()
    json_object = json.dumps(dictionary, indent=4)
    runtime.write(json_object)

if __name__ == '__main__':
    createOnlineClassifier()
    createTableEntries()
