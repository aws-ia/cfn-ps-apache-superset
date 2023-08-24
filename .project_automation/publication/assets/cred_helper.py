#!/usr/bin/env python3
import boto3
import json
import sys
import argparse

# https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-sourcing-external.html

def _transform_creds(result, ak, sk):
    AK = result[ak]
    SAK = result[sk]
    transformed_creds = {
          "Version": 1,
          "AccessKeyId": AK,
          "SecretAccessKey": SAK
    }
    return transformed_creds

def fetch_creds(region_name, secret_name, ak, sk, pr):
    ssm = boto3.Session(profile_name=pr).client('secretsmanager', region_name=region_name)
    value = ssm.get_secret_value(SecretId=secret_name)
    value = json.loads(value["SecretString"])
    return _transform_creds(value, ak, sk)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        prog="cred_helper.py",
        description="Snags creds from Secrets manager for use in an AWS profile. Leveraging botocore builtins.",
    )
    parser.add_argument(
            "--region",
        type=str,
        help="region name. otherwise use the default.",
        required=True
    )
    parser.add_argument(
        "--secret-name",
        type=str,
        help="secret name to fetch",
        required=True
    )
    parser.add_argument(
        "--access-key-index",
        type=str,
        help="secret name to fetch",
        required=True
    )
    parser.add_argument(
        "--secret-access-key-index",
        type=str,
        help="secret name to fetch",
        required=True
    )
    parser.add_argument(
        "--secret-profile",
        type=str,
        help="profile to use when fetching the secret",
        required=False,
        default="default"
    )
    args = parser.parse_args()
    try:
        parsed_creds = fetch_creds(
            args.region,
            args.secret_name,
            args.access_key_index,
            args.secret_access_key_index,
            args.secret_profile
        )
        json.dump(parsed_creds, sys.stdout, indent=2)
    except:
        raise
