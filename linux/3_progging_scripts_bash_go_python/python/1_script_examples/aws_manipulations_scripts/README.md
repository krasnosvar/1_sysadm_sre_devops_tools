#### Scripts for S3


0. local execution - export credentials

```
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export AWS_SESSION_TOKEN=""
```


1. ```s3_cleaner.py``` - clean files in S3 older than * days
* Hardcoded variables ( can be changed)
```
duration = 86400*2 #2 days in epoch seconds
env_bucket = "dev-initial-dumps-bucket"
env_dir = "dev/"
```
