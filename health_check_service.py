from flask import Flask, jsonify
import threading
import time
import json
from kafka import KafkaProducer

app = Flask(__name__)

producer = KafkaProducer(bootstrap_servers=[
    'kafka-0.kafka-headless.kafka.svc.cluster.local:9092',
    'kafka-1.kafka-headless.kafka.svc.cluster.local:9092',
    'kafka-2.kafka-headless.kafka.svc.cluster.local:9092'
])

def perform_health_checks():
    while True:
        health_check_data = {
            "service_name": "MyService",
            "status": "OK",
            "timestamp": time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime())
        }
        producer.send('health_checks_topic', json.dumps(health_check_data).encode('utf-8'))
        time.sleep(30)

@app.route('/check_health', methods=['GET'])
def check_health():
    return jsonify({"message": "Health checks are being performed and sent to Kafka."})

if __name__ == "__main__":
    threading.Thread(target=perform_health_checks, daemon=True).start()
    app.run(host='0.0.0.0', port=5000)
