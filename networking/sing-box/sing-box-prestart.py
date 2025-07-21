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
    parser.add_argument("--save_to", required=True, type=str)
    parser.add_argument("--clash_api_secret", type=str)

    args = parser.parse_args()

    config = None
    headers = {
      "accept": "application/vnd.github.raw+json",
      "authorization": "Bearer " + args.token,
      }

    try:
        r = requests.get(args.configuration_url, headers=headers)
        config = r.json()
    except Exception as e:
        print(e)
        exit(0) # maybe old one still can work
    
    if args.clash_api_secret:
        config["experimental"]["clash_api"]["secret"] = args.clash_api_secret
    
    try:
        os.makedirs(os.path.dirname(args.save_to), exist_ok=True)
        f = open(args.save_to, "w")
        json.dump(config, f, indent=2)
    except Exception as e:
        print(e)
        exit(-1)
        

if __name__ == "__main__":
    main(sys.argv)
