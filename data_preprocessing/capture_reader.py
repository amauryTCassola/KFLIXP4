import pyshark
import ipaddress
import ast

featureList = [
    "PktCount",
    "SumPktLength",
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
    "MeanWindow",
    "IsTCP"
]

def get_feature_list():
    return featureList

#Timestamps are in microseconds in bmv2, so we need to extract them as such
flowTimestamps = dict()

def start_new_flow(key, pkt, flowDict, copy=False):
    thisFlow = dict()

    pktLength = len(pkt)
    timestamp = pkt.frame_info.time_relative * 1000000 #seconds to microseconds

    thisFlow["PktCount"] = 1

    thisFlow["SumPktLength"] = pktLength
    thisFlow["MaxPktLength"] = pktLength
    thisFlow["MinPktLength"] = pktLength
    thisFlow["MeanPktLength"] = pktLength

    flowTimestamps[key] = {
        "flowStartTS": timestamp,
        "lastPktTS": timestamp
    }

    thisFlow["SumIat"] = 0
    thisFlow["MaxIat"] = 0
    thisFlow["MinIat"] = 0
    thisFlow["MeanIat"] = 0
    thisFlow["FlowDuration"] = 0

    if("tcp" in pkt):
        TCPWindow = pkt.tcp.window.size.value
        if copy:
            thisFlow["InitialWindow"] = flowDict[key]["InitialWindow"]
        else:
            thisFlow["InitialWindow"] = TCPWindow
        thisFlow["SumWindow"] = TCPWindow
        thisFlow["MaxWindow"] = TCPWindow
        thisFlow["MinWindow"] = TCPWindow
        thisFlow["MeanWindow"] = TCPWindow
        thisFlow["IsTCP"] = 1
    else:
        thisFlow["InitialWindow"] = 0
        thisFlow["SumWindow"] = 0
        thisFlow["MaxWindow"] = 0
        thisFlow["MinWindow"] = 0
        thisFlow["MeanWindow"] = 0
        thisFlow["IsTCP"] = 0

    flowDict[key] = thisFlow

def update_pktLength(key, pkt, flowDict):
    thisLength = len(pkt)
    curSum = flowDict[key]["SumPktLength"]
    curMax = flowDict[key]["MaxPktLength"]
    curMin = flowDict[key]["MinPktLength"]
    curCount = flowDict[key]["PktCount"]

    if thisLength > curMax:
        flowDict[key]["MaxPktLength"] = thisLength

    if thisLength < curMin:
        flowDict[key]["MinPktLength"] = thisLength
    
    totalSum = curSum + thisLength
    flowDict[key]["SumPktLength"] = totalSum

    mean = totalSum/curCount
    flowDict[key]["MeanPktLength"] = mean

def reset_iat(key, thisTimestamp, flowDict):
    firstPktTS = flowTimestamps[key]["lastPktTS"]
    thisIat = thisTimestamp - firstPktTS

    flowDict[key]["SumIat"] = thisIat
    flowDict[key]["MaxIat"] = thisIat
    flowDict[key]["MinIat"] = thisIat
    flowDict[key]["MeanIat"] = thisIat

def increment_iat(key, thisTimestamp, flowDict, count):
    lastPktTS = flowTimestamps[key]["lastPktTS"]
    thisIat = thisTimestamp - lastPktTS

    sumIat = flowDict[key]["SumIat"]
    maxIat = flowDict[key]["MaxIat"]
    minIat = flowDict[key]["MinIat"]

    if thisIat > maxIat:
        flowDict[key]["MaxIat"] = thisIat

    if thisIat < minIat:
        flowDict[key]["MinIat"] = thisIat

    totalSum = sumIat + thisIat
    flowDict[key]["SumIat"] = totalSum

    meanIat = totalSum/count
    flowDict[key]["MeanIat"] = meanIat

def update_iat(key, pkt, flowDict):
    thisTimestamp = pkt.frame_info.time_relative * 1000000
    curCount = flowDict[key]["PktCount"]

    if curCount == 2:
        reset_iat(key, thisTimestamp, flowDict)
    else:
        increment_iat(key, thisTimestamp, flowDict, curCount-1)

    flowTimestamps[key]["lastPktTS"] = thisTimestamp

def update_flowDuration(key, pkt, flowDict):
    thisTimestamp = pkt.frame_info.time_relative * 1000000
    flowStartTS = flowTimestamps[key]["flowStartTS"]

    duration = thisTimestamp - flowStartTS

    flowDict[key]["FlowDuration"] = duration

def update_window(key, pkt, flowDict):
    thisWindow = pkt.tcp.window.size.value
    curSum = flowDict[key]["SumWindow"]
    curMax = flowDict[key]["MaxWindow"]
    curMin = flowDict[key]["MinWindow"]
    curCount = flowDict[key]["PktCount"]

    if thisWindow > curMax:
        flowDict[key]["MaxWindow"] = thisWindow

    if thisWindow < curMin:
        flowDict[key]["MinWindow"] = thisWindow
    
    totalSum = curSum + thisWindow
    flowDict[key]["SumWindow"] = totalSum

    mean = totalSum/curCount
    flowDict[key]["MeanWindow"] = mean

def update_flow_features(key, pkt, flowDict):
    thisFlow = flowDict[key]

    thisFlow["PktCount"] = thisFlow["PktCount"] + 1

    update_pktLength(key, pkt, flowDict)
    update_iat(key, pkt, flowDict)
    update_flowDuration(key, pkt, flowDict)
    if("tcp" in pkt):
        update_window(key, pkt, flowDict)

def read_capture(capFile):
    with pyshark.FileCapture(capFile, use_ek=True) as capture:
        pkts = [pkt for pkt in capture if "ip" in pkt and ("tcp" in pkt or "udp" in pkt)]

        flowDict = dict()

        for pkt in pkts:
            curTuple = []

            if("tcp" in pkt):
                curTuple = [
                    str(pkt.ip.src.value), 
                    str(pkt.ip.dst.value), 
                    str(pkt.tcp.srcport),
                    str(pkt.tcp.dstport),
                    str(pkt.ip.proto)
                ]
            else:
                curTuple = [
                    str(pkt.ip.src.value), 
                    str(pkt.ip.dst.value), 
                    str(pkt.udp.srcport),
                    str(pkt.udp.dstport),
                    str(pkt.ip.proto)
                ]

            curKey = str(curTuple)

            if curKey not in flowDict:
                start_new_flow(curKey, pkt, flowDict)
            else:
                update_flow_features(curKey, pkt, flowDict)

        return flowDict

        
def read_nonvideo_capture(capFile):
    result = read_capture(capFile)
    array = list(result.values())
    return array

def is_private_ip(address):
    return ipaddress.ip_address(address).is_private

def read_video_capture(videoCapFile):
    tempVideoDict = read_capture(videoCapFile)
    videoArray = []

    for key in tempVideoDict.keys():
        keyArray = ast.literal_eval(key)
        src = keyArray[0]
        duration = tempVideoDict[key]["FlowDuration"]/1000000 #seconds
        pktCount = tempVideoDict[key]["PktCount"]
        if pktCount > 25 and duration > 10 and not is_private_ip(src):
            videoArray.append(tempVideoDict[key])

    return videoArray