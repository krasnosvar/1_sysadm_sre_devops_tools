#decode base64 encrypted data
echo 'aXRzLW5vdC1hLXNlY3JldA==' | base64 -d
#or
base64 -d <<< aXRzLW5vdC1hLXNlY3JldA==

#or with openssl
$ openssl enc -base64 <<< 'Hello, World!'
SGVsbG8sIFdvcmxkIQo=
$ openssl enc -base64 -d <<< SGVsbG8sIFdvcmxkIQo=
Hello, World!
