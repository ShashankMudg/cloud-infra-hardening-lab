import boto3
import requests
import time

# Configuration
REGION = "us-east-1"
# Replace with your CloudFront Domain Name or API Gateway Endpoint after deployment
TARGET_URL = "https://your-distribution-id.cloudfront.net/process" 

def simulate_sqli_attack():
    """
    Simulates a SQL Injection attack to trigger AWS WAF.
    """
    print("[!] Simulating SQL Injection attack on WAF...")
    payloads = [
        "1' OR '1'='1",
        "'; DROP TABLE users; --",
        "union select null, username, password from users--"
    ]
    
    for p in payloads:
        try:
            # Sending malicious payload in a POST request
            response = requests.post(TARGET_URL, data={"id": p})
            if response.status_status == 403:
                print(f"[*] Success: WAF blocked payload: {p}")
            else:
                print(f"[?] WAF did not block: {p} (Status: {response.status_code})")
        except Exception as e:
            print(f"[-] Error: {e}")

def trigger_guardduty_anomaly():
    """
    Simulates unauthorized API calls to trigger GuardDuty.
    Note: This requires valid AWS credentials with limited permissions.
    """
    print("\n[!] Simulating GuardDuty Anomaly (Unauthorized API Calls)...")
    client = boto3.client('iam', region_name=REGION)
    
    try:
        # Trying to list SSH Keys for a non-existent user to simulate discovery behavior
        client.list_ssh_public_keys(UserName='fake-user-admin')
    except Exception as e:
        print(f"[*] GuardDuty should log this unauthorized attempt: {e}")

if __name__ == "__main__":
    print("--- Hardened Fintech Incident Simulation ---")
    simulate_sqli_attack()
    trigger_guardduty_anomaly()
    print("\n[+] Simulation Complete. Check CloudWatch/GuardDuty console for findings.")