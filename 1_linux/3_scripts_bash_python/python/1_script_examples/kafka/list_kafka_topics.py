#pip3 install kafka-python
from kafka import KafkaAdminClient


admin_client = KafkaAdminClient(bootstrap_servers='kafk-server-1.local:9093,kafk-server-2.local:9093,kafk-server-3.local:9093',
                                security_protocol="SASL_PLAINTEXT",
                                sasl_mechanism="PLAIN",
                                sasl_plain_username="kafkauser",
                                sasl_plain_password="password"
                                )
topic_list = admin_client.list_topics()

print("Topics in the Kafka cluster:")
for topic in topic_list:
    print(topic)
