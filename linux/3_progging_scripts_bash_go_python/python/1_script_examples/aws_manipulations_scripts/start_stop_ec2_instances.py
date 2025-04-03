# how to use:
# 1. export AWS creds
# 2. execute script:
# to start only TYPE1 host and TYPE2
# python3 start_stop_ec2_instances.py start type12
# to stop all
# python3 start_stop_ec2_instances.py stop all

# needed packages:
# pip install boto3
# pip install awscli

import sys
import json
import boto3

region = 'us-east-1'

# 'start' or "stop"
action = sys.argv[1]
# STOP ALL argument "all"
stop_all = sys.argv[2]

tag_value = 'tag:Env'
instance_type_1_tag_key = 'type-1'
instance_type_2_tag_key = "type-2"

# Create EC2 client
ec2 = boto3.client('ec2', region_name=region)


instance_details = []
def get_ec2_instances_and_create_list():
    try:
        # Get all instances
        # response = ec2_client.describe_instances()
        response = ec2.describe_instances()
        # Iterate through reservations and instances
        for reservation in response['Reservations']:
            for instance in reservation['Instances']:
                # Get instance name from tags if it exists
                if 'Tags' in instance:
                    for tag in instance['Tags']:
                        if tag['Key'] == 'Name' and stop_all == 'all' and 'dev' in tag['Value']:
                            instance_name = tag['Value']
                            # Get instance ID
                            instance_id = instance['InstanceId']
                            # Get instance state
                            instance_state = instance['State']['Name']
                            # Add instance details to list
                            instance_details.append({
                                'Instance ID': instance_id,
                                'Name': instance_name,
                                'State': instance_state
                            })
                        elif tag['Key'] == 'Name' and instance_type_1_tag_key in tag['Value'] or instance_type_2_tag_key in tag['Value']:
                            instance_name = tag['Value']
                            # Get instance ID
                            instance_id = instance['InstanceId']
                            # Get instance state
                            instance_state = instance['State']['Name']
                            # Add instance details to list
                            instance_details.append({
                                'Instance ID': instance_id,
                                'Name': instance_name,
                                'State': instance_state
                            })
    except Exception as e:
        print(f"Error retrieving EC2 instances: {str(e)}")


# Print instance details
def print_info_ec2_instances():
    if instance_details:
        print(f"\nEC2 {instance_type_1_tag_key, instance_type_2_tag_key} Instances {region} state:")
        print("-" * 80)
        for instance in instance_details:
            # print(f"Instance ID: {instance['Instance ID']}")
            print(f"Name: {instance['Name']}")
            print(f"State: {instance['State']}")
            print("-" * 80)
    else:
        print(f"EC2 {instance_type_1_tag_key, instance_type_2_tag_key} instances not found in {region} region")


def start_stop_ec2_instances():
    clean_start_stop_list = []
    for instance in instance_details:
        instance_id_to_action = instance['Instance ID']
        clean_start_stop_list.append(instance_id_to_action)
        if action == "stop":
            print(f"Stopping {instance['Name']}")
            ec2.stop_instances(InstanceIds=[instance_id_to_action])
        elif action == "start":
            print(f"Starting {instance['Name']}")
            ec2.start_instances(InstanceIds=[instance_id_to_action])
    print(f"Action: {action}, to Instances:{clean_start_stop_list}")


if __name__ == "__main__":
    get_ec2_instances_and_create_list()
    # print_info_ec2_instances()
    start_stop_ec2_instances()
