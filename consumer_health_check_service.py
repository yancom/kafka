from flask import Flask, jsonify
from kafka import KafkaConsumer
import json

app = Flask(__name__)

consumer = KafkaConsumer(
    'health_checks_topic',
    bootstrap_servers=[
        'kafka-0.kafka-headless.kafka.svc.cluster.local:9092',
        'kafka-1.kafka-headless.kafka.svc.cluster.local:9092',
        'kafka-2.kafka-headless.kafka.svc.cluster.local:9092'
    ],
    auto_offset_reset='latest',
    enable_auto_commit=True,
    group_id='health-check-consumer-group'
)

latest_health_check = {}

for message in consumer:
    latest_health_check = json.loads(message.value)

@app.route('/get_latest_health_check', methods=['GET'])
def get_latest_health_check():
    return jsonify(latest_health_check)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5001)
