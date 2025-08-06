#If an error occurs when executing the command:
[root@v663000app1 ~]\# subscription-manager register --org="domain" --activationkey="RedHat 7"
Unable to verify server's identity: [SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed (_ssl.c:579)

# in file /etc/rhsm/rhsm.conf comment out proxy values
# if it doesn't help - try following the link and doing as they say:
# #4.6.2. Resolving error “Unable to verify server's identity: certificate verify failed”
https://access.redhat.com/documentation/en-us/red_hat_subscription_management/1/html/rhsm/certs-troubleshoot-verify
