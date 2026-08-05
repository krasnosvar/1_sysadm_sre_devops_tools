#Cat a File, Without the Comments
#https://kvz.io/cat-a-file-without-the-comments.html
cat /etc/squid/squid.conf | egrep -v "^\s*(#|$)"

#add nginx repo from cli
cat <<EOF > /etc/yum.repos.d/nginx.repo
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/\$releasever/\$basearch/
gpgcheck=0
enabled=1
EOF

