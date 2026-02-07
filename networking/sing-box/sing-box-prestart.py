#!env python3

import os
import sys
import json
import requests
import argparse

def main(argv):
    parser = argparse.ArgumentParser(
                    prog='sing-box config generator',
                    description='generate config from template with outbounds')
    parser.add_argument("--configuration_url", required=True, type=str)
    parser.add_argument("--token", required=True, type=str)
    parser.add_argument("--clash_api_secret", type=str)
    parser.add_argument("--working_dir", type=str, required=True)

    args = parser.parse_args()

    config = None
    headers = {
      "accept": "application/vnd.github.raw+json",
      "authorization": "Bearer " + args.token,
      }

    try:
        r = requests.get(args.configuration_url, headers=headers, timeout=5)
        config = r.json()
    except Exception as e:
        print(e)
        exit(0) # maybe old one still can work
    
    if args.clash_api_secret:
        config["experimental"]["clash_api"]["secret"] = args.clash_api_secret
    
    try:
        os.makedirs(args.working_dir, exist_ok=True)
        os.chdir(args.working_dir)
        check_is_campus_network = requests.get("https://gw.buaa.edu.cn/cgi-bin/rad_user_info")
        if check_is_campus_network.ok and os.path.isfile("direct.json"):
            # is campus network

            for o in config["outbounds"]:
                o_type = o["type"]
                if o_type == "vmess" or \
                    o_type == "vless" or \
                    o_type == "trojan":
                    o["detour"] = "direct"
            
            config["outbounds"] = [ o for o in config["outbounds"] if o["tag"] != "direct"]
        else:
            if os.path.isfile("direct.json"):
                os.remove("direct.json")
        f = open("config.json", "w")
        json.dump(config, f, indent=2)
    except Exception as e:
        print(e)
        exit(-1)
        

if __name__ == "__main__":
    main(sys.argv)
