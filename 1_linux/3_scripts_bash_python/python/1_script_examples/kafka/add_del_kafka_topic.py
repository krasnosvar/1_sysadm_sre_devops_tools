from kafka import KafkaConsumer
from kafka.admin import KafkaAdminClient, NewTopic
from kafka.errors import (
    KafkaError,
    TopicAlreadyExistsError,
    UnknownTopicOrPartitionError,
)

topic_names = ['topic1', 'topic2', 'topic3' , 'topic3']

def create_topics(topic_names):

    existing_topic_list = consumer.topics()
    print(list(consumer.topics()))
    topic_list = []
    pending_topic_names = set()
    for topic in topic_names:
        if topic not in existing_topic_list and topic not in pending_topic_names:
            print(f'Topic : {topic} added ')
            topic_list.append(NewTopic(name=topic, num_partitions=3, replication_factor=3))
            pending_topic_names.add(topic)
        else:
            print(f'Topic : {topic} already exist ')
    try:
        if topic_list:
            admin_client.create_topics(new_topics=topic_list, validate_only=False)
            print("Topic Created Successfully")
        else:
            print("Topic Exist")
    except TopicAlreadyExistsError as e:
        print(f"Topic Already Exist: {e}")
    except KafkaError as e:
        print(e)

def delete_topics(topic_names):
    try:
        admin_client.delete_topics(topics=topic_names)
        print("Topic Deleted Successfully")
    except UnknownTopicOrPartitionError as e:
        print(f"Topic Doesn't Exist: {e}")
    except KafkaError as e:
        print(e)


consumer = KafkaConsumer(
    bootstrap_servers='kafk-server-1.local:9093,kafk-server-2.local:9093,kafk-server-3.local:9093',
    security_protocol="SASL_PLAINTEXT",
    sasl_mechanism="PLAIN",
    sasl_plain_username="kafkauser",
    sasl_plain_password="password"
    )
admin_client = KafkaAdminClient(
    bootstrap_servers='kafk-server-1.local:9093,kafk-server-2.local:9093,kafk-server-3.local:9093',
    security_protocol="SASL_PLAINTEXT",
    sasl_mechanism="PLAIN",
    sasl_plain_username="kafkauser",
    sasl_plain_password="password"
    )
create_topics(topic_names)
consumer.close()
admin_client.close()
