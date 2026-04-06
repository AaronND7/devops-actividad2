#!/usr/bin/env python3
"""
Script para gestionar instancias EC2 en AWS
Autor: DevOps Student
"""

import boto3
import sys
import argparse
from datetime import datetime

class EC2Manager:
    def __init__(self, region='us-east-1'):
        self.ec2_client = boto3.client('ec2', region_name=region)
        self.ec2_resource = boto3.resource('ec2', region_name=region)

if __name__ == "__main__":
    print("Script EC2 - Estructura inicial")
