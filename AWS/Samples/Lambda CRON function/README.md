
### Create an IAM policy and execution role for your Lambda function

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:Start*",
        "ec2:Stop*"
      ],
      "Resource": "*"
    }
  ]
}
```


### Create Lambda functions that stop and start your EC2 instances

```python
import json
import boto3

region = ''
ec2 = boto3.resource('ec2', region_name = region)


def list_instances():
  '''
  Lists all the ec2 instances with their state, public Ip, name etc. 
  '''
    instances = {}
    for instance in ec2.instances.all():
        tags = [i for i in instance.tags if i.get('Value') == 'Cron']  

         if len(tags)>0:
            instances[instance.id] = {
                "id": instance.id,
                "type": instance.instance_type,
                "public_ip": instance.public_ip_address,
                "state": instance.state.get('Name'),
                # "tag": tags
                
                }
        
    for i in instances.items():
        print(i)
        
    return instances



def start_instance(id):
    ec2 = boto3.client('ec2')
    response = ec2.start_instances(InstanceIds=[id], DryRun = False)
    return response

def stop_instance(id):
    ec2 = boto3.client('ec2')
    response = ec2.stop_instances(InstanceIds=[id], DryRun=False)
    return response
   
def reboot_instance(INSTANCE_ID):
    ec2 = boto3.client('ec2')
    try:
        ec2.reboot_instances(InstanceIds=[INSTANCE_ID], DryRun=True)
    except Exception as e:
        if 'DryRunOperation' not in str(e):
            print("You don't have permission to reboot instancess.")
            raise
    
    try:
        response = ec2.reboot_instances(InstanceIds=[INSTANCE_ID], DryRun=False)
        print('Success', response)
    except Exception as e:
        print('Error', e)


def lambda_handler(event, context):
    print(event)
    instances = list_instances()
    elif event.get('action') == 'start':
        for i in instances.items():
            ins_id = i.id
            data = start_instance(ins_id)
    
    elif event.get('action') == 'stop':
        for i in instances.items():
            ins_id = i.id
            data = start_instance(ins_id)
 
    return {
        'statusCode': 200,
        'body': 'Job done'
    }
```


### Setup 2 cron's for lambda with action parameters to start and stop function:

- cron(0 8 ? * MON-FRI *) -> action 'start'
- cron(0 17 ? * MON-FRI *) -> action 'stop'