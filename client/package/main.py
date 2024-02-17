#import yaml
from datetime import datetime
import boto3
import pytz
from slack_sdk import WebClient

# インスタンスの情報取得
def get_instances(ec2_client):
  response = ec2_client.describe_instances()
  
  instances = []
  for reservation in response['Reservations']:
      for instance in reservation['Instances']:
          instances.append(instance)

  return instances

# タグのkeyに対するvalueを取得
def get_tag_value(tag_key, instance):
  tag_value = ""
  if 'Tags' in instance:
    tag_value = [tag['Value'] for tag in instance['Tags'] if tag.get('Key') == tag_key]
  return tag_value[0]

# 起動・停止時刻の判定
def is_match_time(time, current_time_hour):
  
  if current_time_hour == time:
    return True
  else:
    return False

# Slackに通知する処理
def post_slack_alert(token, channel, mention, message_text):
  attachments = [
    {
      "fallback":"instance-ctl",
      "color":"#228b22",
      "fields":[
          {
            "title":"instance-ctl",
            "value":mention + "\n" + message_text
          }
      ]
    }
  ]

  client = WebClient(token)
  result = client.chat_postMessage(channel, attachments)

def lambda_handler(event, context):
  # エラー検知のテスト用
  if "error" in event:
    raise Exception

  # 現在の時刻を取得する。
  current_time_hour_jst = datetime.now(pytz.timezone('Asia/Tokyo')).strftime("%H:%M").split(':')[0]

  # ec2の情報を取得する
  ec2_client = boto3.client('ec2')
  instances=get_instances(ec2_client)

  start_instances = []
  stop_instances  = []

  for instance in instances:
    instance_id = instance['InstanceId']

    # インスタンス起動
    start_time=get_tag_value("start_time", instance)
    if is_match_time(start_time, current_time_hour_jst) and instance['State']['Name'] == "stopped" :
      ec2_client.start_instances(InstanceIds=[instance_id])
      start_instances.append(instance_id + "(" + get_tag_value("Name", instance) + ")")
    
    # インスタンス停止
    stop_time=get_tag_value("stop_time", instance)
    if is_match_time(stop_time, current_time_hour_jst)  and instance['State']['Name'] == "running" :
      ec2_client.stop_instances(InstanceIds=[instance_id])
      stop_instances.append(instance_id + "(" + get_tag_value("Name", instance) + ")")

  # 結果を出力
  message = "[" + ", ".join(start_instances) + "]が起動しました。[" + ", ".join(stop_instances) + "]が停止しました。"
  print(message)

#lambda_handler("test", "test")