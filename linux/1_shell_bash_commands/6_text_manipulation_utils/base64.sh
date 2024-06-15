#encode 
base64 <<< 12345
#or
echo "12345"| base64 

#decode base64 encrypted data
echo 'aXRzLW5vdC1hLXNlY3JldA==' | base64 -d
#or
base64 -d <<< aXRzLW5vdC1hLXNlY3JldA==


#or with openssl
#encode
$ openssl enc -base64 <<< 'Hello, World!'
SGVsbG8sIFdvcmxkIQo=
#decode
$ openssl enc -base64 -d <<< SGVsbG8sIFdvcmxkIQo=
Hello, World!


#ERRORs
#newline invisible symbol in decoded string
# https://stackoverflow.com/questions/68163881/base64-encoding-is-adding-a-new-line
# "echo -n" removes the trailing newline character.
# please use echo -n to remove the line break before redirecting to base64; 
# and use base64 -w 0 to prevent base64 itself to add line break into the output.
echo -n 'mypassword' | base64 -w 0
