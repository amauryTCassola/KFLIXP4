/* -*- P4_16 -*- */
#include <core.p4>
#include <v1model.p4>
#include "kflix/definitions.p4"

parser MyParser(packet_in packet,
                out headers hdr,
                inout metadata meta,
                inout standard_metadata_t standard_metadata) {
    
    // state machine for  parser
    state start {
        transition parse_ethernet;
    }

    state parse_ethernet {
        packet.extract(hdr.ethernet);
        transition select(hdr.ethernet.etherType) {
            TYPE_IPV4: parse_ipv4;
            default: accept;
    }
}
    
    state parse_ipv4 {
        packet.extract(hdr.ipv4);
        transition select(hdr.ipv4.protocol) {
            6: parse_tcp;
            default: accept;
                }
            }

    state parse_tcp {
        packet.extract(hdr.tcp);
        transition accept;
    }
}

/*************************************************************************
************   C H E C K S U M    V E R I F I C A T I O N   *************
*************************************************************************/

control MyVerifyChecksum(inout headers hdr, inout metadata meta) {
    apply {  }
}

/*************************************************************************
**************  I N G R E S S   P R O C E S S I N G   *******************
*************************************************************************/

control MyIngress(inout headers hdr,
                  inout metadata meta,
                  inout standard_metadata_t standard_metadata) {

    #include "kflix/hashFunctions.p4"
    #include "kflix/featureExtractor.p4"

    action drop() {
        mark_to_drop(standard_metadata);
    }

    action ipv4_forward(macAddr_t dstAddr, egressSpec_t port) {
        standard_metadata.egress_spec = port;
        hdr.ethernet.srcAddr = hdr.ethernet.dstAddr;
        hdr.ethernet.dstAddr = dstAddr;
    }

    table ipv4_lpm {
        key = {
            hdr.ipv4.dstAddr: lpm;
        }
        actions = {
            ipv4_forward;
            drop;
            NoAction;
        }
        size = 1024;
        default_action = drop();
    }

    apply {
        if (hdr.ipv4.isValid()) {
            // apply basic ipv4 forwarding
            ipv4_lpm.apply();

            // Update key fields.
            tableCalculateHashKey.apply();
            tableUpdateSrcAddr.apply();
            tableUpdateDstAddr.apply();
            tableUpdateSrcPort.apply();
            tableUpdateDstPort.apply();
            tableUpdateProtocol.apply();

            // Set match flag if all key fields are equal.
            //That is, if there wasn't a collision
            if (hdr.ipv4.srcAddr == meta.srcAddr) {
                if (hdr.ipv4.dstAddr == meta.dstAddr) {
                    if (hdr.tcp.srcPort == meta.srcPort) {
                        if (hdr.tcp.dstPort == meta.dstPort) {
                            if(hdr.ipv4.protocol == meta.protocol){
                                tableSetMatch.apply();
                            }
                        }
                    }
                }
            }

            // update features (depending on match flag).
            if (meta.matchFlag == 1) {
                tableIncrementPktCount.apply();
                tableIncrementByteCount.apply();
            }
            else {
                tableResetPktCount.apply();
                tableResetByteCount.apply();
            }

            hdr.features.setValid();

            // If match flag == 0, multicast to the TurboFlow monitoring port.
            //if (tfMeta.matchFlag == 0) {
            //    apply(tiMcToCpu);
            //}
        }
    }
}

/*************************************************************************
****************  E G R E S S   P R O C E S S I N G   *******************
*************************************************************************/

control MyEgress(inout headers hdr,
                 inout metadata meta,
                 inout standard_metadata_t standard_metadata) {
    apply {  }
}

/*************************************************************************
*************   C H E C K S U M    C O M P U T A T I O N   **************
*************************************************************************/

control MyComputeChecksum(inout headers  hdr, inout metadata meta) {
     apply {
	update_checksum(
	    hdr.ipv4.isValid(),
            { hdr.ipv4.version,
	      hdr.ipv4.ihl,
              hdr.ipv4.diffserv,
              hdr.ipv4.totalLen,
              hdr.ipv4.identification,
              hdr.ipv4.flags,
              hdr.ipv4.fragOffset,
              hdr.ipv4.ttl,
              hdr.ipv4.protocol,
              hdr.ipv4.srcAddr,
              hdr.ipv4.dstAddr },
            hdr.ipv4.hdrChecksum,
            HashAlgorithm.csum16);
    }
}

/*************************************************************************
***********************  D E P A R S E R  *******************************
*************************************************************************/

control MyDeparser(packet_out packet, in headers hdr) {
    apply {
        packet.emit(hdr.ethernet);
        packet.emit(hdr.ipv4);
        packet.emit(hdr.tcp);
        packet.emit(hdr.features);
    }
}

/*************************************************************************
***********************  S W I T C H  *******************************
*************************************************************************/

V1Switch(
MyParser(),
MyVerifyChecksum(),
MyIngress(),
MyEgress(),
MyComputeChecksum(),
MyDeparser()
) main;