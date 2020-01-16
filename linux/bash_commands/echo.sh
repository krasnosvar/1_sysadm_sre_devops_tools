#change pass in one line command ( only by root)
echo "passssssword" | passwd root --stdin > /dev/null
#echo multiple lines(and creates file if no exist)
echo -e "[vscale_scalet]\n0.0.0.0" > $(pwd)/\host
