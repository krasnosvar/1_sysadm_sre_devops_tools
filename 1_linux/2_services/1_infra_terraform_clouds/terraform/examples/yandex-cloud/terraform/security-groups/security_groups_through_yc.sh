# 0. 

yc init                                     
Welcome! This command will take you through the configuration process.
Pick desired action:
 [1] Re-initialize this profile 'default' with new settings 
 [2] Create a new profile
 [3] Switch to and re-initialize existing profile: 'a'
 [4] Switch to and re-initialize existing profile: 'b'
 [5] Switch to and re-initialize existing profile: 'c'
Please enter your numeric choice: 4
Please go to https://oauth.yandex.ru/authorize?response_type=token&client_id= in order to obtain OAuth token.

Please enter OAuth token: <token>
You have one cloud available: 'cloud' (id = <id>). It is going to be used by default.
Please choose folder to use:
 [1] default (id = <id>)
 [2] Create a new folder
Please enter your numeric choice: 1
Your current folder has been set to 'default' (id = <id>).
Do you want to configure a default Compute zone? [Y/n] n



yc config profile activate <a>

#2. Create security group that will be needed for both Gitlab and Kubernetes.

yc vpc security-group create --name yc-security-group --network-name default \
--rule 'direction=ingress,port=443,protocol=tcp,v4-cidrs=0.0.0.0/0' \
--rule 'direction=ingress,port=80,protocol=tcp,v4-cidrs=0.0.0.0/0' \
--rule 'direction=ingress,from-port=0,to-port=65535,protocol=any,predefined=self_security_group' \
--rule 'direction=ingress,from-port=0,to-port=65535,protocol=any,v4-cidrs=[10.96.0.0/16,10.112.0.0/16]' \
--rule 'direction=ingress,from-port=0,to-port=65535,protocol=tcp,v4-cidrs=[198.18.235.0/24,198.18.248.0/24]' \
--rule 'direction=egress,from-port=0,to-port=65535,protocol=any,v4-cidrs=0.0.0.0/0' \
--rule 'direction=ingress,protocol=icmp,v4-cidrs=[10.0.0.0/8,192.168.0.0/16,172.16.0.0/12]' 


