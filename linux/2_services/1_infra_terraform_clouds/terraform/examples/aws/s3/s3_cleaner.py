import boto3
import time
import sys


# vars ( vars 1)
# todays\'s epoch
_tday = time.time()
#checkpoint for deletion
_expire_limit =_tday - duration
# initialize s3 client
s3_client = boto3.client('s3')
_file_size = [] #just to keep track of the total savings in storage size
_del_size = 0


#user-modifiable variables ( vars 2 )
duration = 86400*2 #2 days in epoch seconds
my_bucket = "dev-initial-dumps-bucket"
my_ftp_key = "dev/"


#works to only get us key/file information
def get_key_info(bucket=my_bucket, prefix=my_ftp_key):
    print(f"Getting S3 Key Name, Size and LastModified from the Bucket: {bucket} with Prefix: {prefix}")
    key_names = []
    file_timestamp = []
    file_size = []
    kwargs = {"Bucket": bucket, "Prefix": prefix}
    while True:
        response = s3_client.list_objects_v2(**kwargs)
        for obj in response["Contents"]:
            # exclude directories/folder from results. Remove this if folders are to be removed too
            if "." in obj["Key"]:
                key_names.append(obj["Key"])
                file_timestamp.append(obj["LastModified"].timestamp())
                file_size.append(obj["Size"])
        try:
            kwargs["ContinuationToken"] = response["NextContinuationToken"]
        except KeyError:
            break

    key_info = {
        "key_path": key_names,
        "timestamp": file_timestamp,
        "size": file_size
    }
    print(f'All Keys in {bucket} with {prefix} Prefix found!')

    return key_info


# Check if date passed is older than date limit
def _check_expiration(key_date=_tday, limit=_expire_limit):
    if key_date < limit:
        return True


# connect to s3 and delete the file
def delete_s3_file(file_path, bucket=my_bucket):
    print(f"Deleting {file_path}")
    s3_client.delete_object(Bucket=bucket, Key=file_path)
    return True


# check size deleted
def _total_size_dltd(size):
    _file_size.append(size)
    _del_size = round(sum(_file_size)/1.049e+6, 2) #convert from bytes to mebibytes
    return _del_size


if __name__ == "__main__":
    try:
        s3_file = get_key_info()
        for i, fs in enumerate(s3_file["timestamp"]):
            file_expired = _check_expiration(fs)
            if file_expired: #if True is recieved
                file_deleted = delete_s3_file(s3_file["key_path"][i])
                if file_deleted: #if file is deleted
                    _del_size = _total_size_dltd(s3_file["size"][i])

        print(f"Total File(s) Size Deleted: {_del_size} MB")
        # debug
        # print(s3_file)
    except:
        print ("failure:", sys.exc_info()[1])
        print(f"Total File(s) Size Deleted: {_del_size} MB")
