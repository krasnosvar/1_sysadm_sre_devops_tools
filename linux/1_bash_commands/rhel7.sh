#Если при выполнении команды возникает ошибка:
[root@v663000app1 ~]# subscription-manager register --org="domain" --activationkey="RedHat 7"
Unable to verify server's identity: [SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed (_ssl.c:579)

в файле /etc/rhsm/rhsm.conf закомментить прокси значения
если не поможет- попробовать пройти по ссылке и сделать как тут говорят:
#4.6.2. Resolving error “Unable to verify server's identity: certificate verify failed”
https://access.redhat.com/documentation/en-us/red_hat_subscription_management/1/html/rhsm/certs-troubleshoot-verify
