-- declare our protocol
kflix_proto = Proto("kflix","KFlix Protocol")
-- create a function to dissect it
function kflix_proto.dissector(buffer,pinfo,tree)
    pinfo.cols.protocol = "KFLIX"
    local subtree = tree:add(kflix_proto,buffer(),"KFlix Protocol Data")
    subtree:add(buffer(0,2),"isVideo: " .. buffer(0,2):uint())
    subtree:add(buffer(2,2),"cluster: " .. buffer(2,2):uint())
    subtree:add(buffer(4,2),"etherType: " .. buffer(4,2):uint())

    local ip_dissector = Dissector.get("ip")
    ip_dissector:call(buffer(6):tvb(),pinfo,tree)
end

-- load the ethertype table
eth_table = DissectorTable.get("ethertype")
-- register our protocol to handle ethertype 0x1212
eth_table:add(0x1212,kflix_proto)