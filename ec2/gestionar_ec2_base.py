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
    
    def listar_instancias(self):
        """Listar todas las instancias EC2"""
        try:
            response = self.ec2_client.describe_instances()
            print("=== INSTANCIAS EC2 ===")
            
            for reservation in response['Reservations']:
                for instance in reservation['Instances']:
                    instance_id = instance['InstanceId']
                    state = instance['State']['Name']
                    instance_type = instance['InstanceType']
                    
                    print(f"ID: {instance_id}")
                    print(f"Estado: {state}")
                    print(f"Tipo: {instance_type}")
                    print("-" * 30)
                    
        except Exception as e:
            print(f"Error al listar instancias: {e}")
            return False
        return True
    
    def iniciar_instancia(self, instance_id):
        """Iniciar una instancia EC2"""
        try:
            response = self.ec2_client.start_instances(InstanceIds=[instance_id])
            print(f"✅ Instancia {instance_id} iniciada correctamente")
            return True
        except Exception as e:
            print(f"❌ Error al iniciar instancia {instance_id}: {e}")
            return False
    
    def detener_instancia(self, instance_id):
        """Detener una instancia EC2"""
        try:
            response = self.ec2_client.stop_instances(InstanceIds=[instance_id])
            print(f"✅ Instancia {instance_id} detenida correctamente")
            return True
        except Exception as e:
            print(f"❌ Error al detener instancia {instance_id}: {e}")
            return False
    
    def terminar_instancia(self, instance_id):
        """Terminar una instancia EC2"""
        try:
            response = self.ec2_client.terminate_instances(InstanceIds=[instance_id])
            print(f"✅ Instancia {instance_id} terminada correctamente")
            return True
        except Exception as e:
            print(f"❌ Error al terminar instancia {instance_id}: {e}")
            return False

if __name__ == "__main__":
    print("Script EC2 - Estructura inicial")
