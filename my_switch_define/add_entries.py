import json
import p4runtime_sh.shell as sh
my_dev1_addr='localhost:9559'
my_dev1_id=0
p4info_txt_fname='main.p4info.txt'
p4prog_binary_fname='main.json'
import p4runtime_sh.shell as sh

sh.setup(device_id=my_dev1_id,
         grpc_addr=my_dev1_addr,
         election_id=(0, 1), # (high_32bits, lo_32bits)
         config=sh.FwdPipeConfig(p4info_txt_fname, p4prog_binary_fname))

f = open('s1-runtime.json')
data = json.load(f)

entries = data["table_entries"]

for entry in entries:
    table_name = entry["table"]
    action_name = entry["action_name"]
    priority = entry["priority"]
    params_dict = entry["action_params"]
    action_params = []
    for key in params_dict.keys():
        newParam = dict()
        newParam["name"] = key
        newParam["value"] = params_dict[key]
        action_params.append(newParam)

    te = sh.TableEntry(table_name)(action=action_name)
    te.priority = priority
    for param in action_params:
        param_name = param["name"]
        param_value = str(param["value"])
        te.action[param_name] = param_value

    te.insert()

sh.teardown()
