# pip3 install minio
from minio import Minio
import urllib3

# https://github.com/minio/minio-py/issues/593#issuecomment-352385122
httpClient = urllib3.PoolManager(
                timeout=urllib3.Timeout.DEFAULT_TIMEOUT,
                        cert_reqs='CERT_NONE',
                        retries=urllib3.Retry(
                            total=5,
                            backoff_factor=0.2,
                            status_forcelist=[500, 502, 503, 504]
                        )
            )

client = Minio(
    "minio.domain.local",
    access_key="",
    secret_key="",
    secure=True,
    http_client=httpClient
)

buckets = client.list_buckets()
for bucket in buckets:
    print(bucket.name, bucket.creation_date)
