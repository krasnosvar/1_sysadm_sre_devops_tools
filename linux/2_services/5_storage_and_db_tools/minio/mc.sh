# install minio client
# https://min.io/docs/minio/linux/reference/minio-mc.html
curl https://dl.min.io/client/mc/release/linux-amd64/mc \                                                         
  --create-dirs \
  -o ~/minio-binaries/minio-client


# add alias
mc alias set ALIAS HOSTNAME ACCESS_KEY SECRET_KEY
 ~/go/bin/mc alias set --insecure minio https://minio.local RootUser Rootuserpass

 #create bucket
 ~/go/bin/mc mb minio/kestra
 

# copy all from bucket to local
# https://min.io/docs/minio/linux/reference/minio-mc/mc-cp.html
~/minio-binaries/minio-client cp --recursive minio-remote-alias/bucket-name/ ~/Downloads/bucket-name/

