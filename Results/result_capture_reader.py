import pyshark
import ipaddress
import ast

featureList = [
    "PktCount",
    "SumPktLength", #in bytes!
    "FlowDuration",
    "IsVideo_GT",
    "Predictions",
    "IsVideo_pred"
]

#Timestamps are in microseconds in bmv2, so we need to extract them as such
flowTimestamps = dict()

def get_feature_list():
    return featureList



def start_new_flow(key, pkt, flowDict):
    thisFlow = dict()

    pktLength = len(pkt)
    timestamp = float(pkt.frame_info.time_relative) * 1000000 #seconds to microseconds

    thisFlow["PktCount"] = 1

    thisFlow["SumPktLength"] = pktLength

    flowTimestamps[key] = {
        "flowStartTS": timestamp,
    }

    thisFlow["FlowDuration"] = 0

    this_isVideo_pred = int(pkt.kflix._ws_lua_text.all_fields[0].showname_value)
    this_cluster = int(pkt.kflix._ws_lua_text.all_fields[1].showname_value)
    thisFlow["Predictions"] = [this_isVideo_pred]
    thisFlow["IsVideo_pred"] = this_isVideo_pred
    thisFlow["Cluster"] = this_cluster

    flowDict[key] = thisFlow

def update_pktLength(key, pkt, flowDict):
    thisLength = len(pkt)
    curSum = flowDict[key]["SumPktLength"]
    
    totalSum = curSum + thisLength
    flowDict[key]["SumPktLength"] = totalSum

def update_flowDuration(key, pkt, flowDict):
    thisTimestamp = float(pkt.frame_info.time_relative) * 1000000
    flowStartTS = flowTimestamps[key]["flowStartTS"]

    duration = thisTimestamp - flowStartTS

    flowDict[key]["FlowDuration"] = duration

def update_prediction(key, pkt, flowDict):
    this_isVideo_pred = int(pkt.kflix._ws_lua_text.all_fields[0].showname_value)
    this_cluster = int(pkt.kflix._ws_lua_text.all_fields[1].showname_value)
    flowDict[key]["Predictions"] += [this_isVideo_pred]
    flowDict[key]["IsVideo_pred"] = this_isVideo_pred
    flowDict[key]["Cluster"] = this_cluster

def update_flow_features(key, pkt, flowDict):
    thisFlow = flowDict[key]

    thisFlow["PktCount"] = thisFlow["PktCount"] + 1

    update_pktLength(key, pkt, flowDict)
    update_flowDuration(key, pkt, flowDict)
    update_prediction(key, pkt, flowDict)

def read_capture(capFile):
    param = { '-X': 'lua_script:kflix.lua'}
    with pyshark.FileCapture(capFile, custom_parameters=param) as capture:
        pkts = [pkt for pkt in capture if "kflix" in pkt and ("tcp" in pkt or "udp" in pkt)]

        flowDict = dict()

        for pkt in pkts:
            curTuple = []

            if("tcp" in pkt):
                curTuple = [
                    str(pkt.ip.src), 
                    str(pkt.ip.dst), 
                    str(pkt.tcp.srcport),
                    str(pkt.tcp.dstport),
                    str(pkt.ip.proto)
                ]
            else:
                curTuple = [
                    str(pkt.ip.src), 
                    str(pkt.ip.dst), 
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

def read_result_capture(videoCapFile, isVideoApp):
    result = read_capture(videoCapFile)

    for key in result.keys():
        keyArray = ast.literal_eval(key)
        src = keyArray[0]
        dst = keyArray[1]
        pktCount = result[key]["PktCount"]
        duration = result[key]["FlowDuration"]/1000000 #seconds

        if isVideoApp and pktCount >= 25 and not is_private_ip(src):
            result[key]["IsVideo_GT"] = 1
        else:
            result[key]["IsVideo_GT"] = 0

        result[key]["srcIP"] = src
        result[key]["dstIP"] = dst

    array = list(result.values())
    return array
