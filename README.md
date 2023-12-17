# It is a NodeJs based  YOUTUBE-CLONE Project 
i have to covered  CICD Jenkins
And  code analysis and bug identification using Sonarqube. 
Image Build & Container create purpose using Docker 
Code & Vulnerabilities  checking purpose using  Trivy
Monitoring purpose prometheus datasource and node_exporter and dashboard purpose using grafana
Deploying into kubernaties, and also monitoring node server install prometheus into Eks cluster with the help of    helm(helm is a package manager using to install kubernates dependencys)
With the help of heml we can run metric files Deployment.yaml(node configuration file) & Service.yaml(service config file) 
Enabel Email notification for every build info configured SMTP server
Configuring  github-webhooks and poll GITScms for CICD autometically trigger build steps.   

# installing jenkins and sonarqube docker trivy using terraform 
source for main server (goto git hub =>a-youtube-clone.app=> servers =>  jenkins-sonar-docker => terraform files (main.tf and provider.tf & install.sh))

downlod this files in your local desktop
inside files open vscode change some settings(like ami region)
open terminal(vscode)

# configue aws user with secrete credentials with admin full access roles assigning

goto Aws => IAM =>Roles =>create role=> ec2 =>name:jenkins=>create
then goto  awsaccess_key & secrets_keys  generate. copy both keys

# install awscli  and terraform in your desktop
once installed completed open terminal(vscode)
$ aws configure
$ <pest awsaccesskey>
$ <pest secretkey>
$ <region> [ex:us-east-2]
$ <json>

then 
$ terraform init
$ terraform plan
$ terraform validate
$ terraform apply --auto-approve

# aws dashboard
go and refresh the instance is running stage connect intance.
$ sudo apt update
$ sudo systemctl status jenkins

# browser 
copy ip address:8080 for jenkins
<copy ip address>:9000 for sonarqube

# in jenkins server 
once default settings is completed 
manage jenkins=> plugins=> install sonarqube-scanner & sonarqube-qualitygates & eclips tumarin & node js & docker(1-5)
then goto tools=> configure jdk17(install from adoptium.net(17.0.8+1)) & node16(install from node16) & sonar-scanner & docker(install from dockerhub (latest))
then goto credentials=> add credential => using secret text=>(generatedsonarusertoken)=>name:sonar-token=>discription:sonar-token
then goto credentials=> add credential => using username& passwd=>dockerhub username =>passwd:dockerhub passwd=>name:docker-hub=> discription:docker-hub
manage jenkins=> system => addsonarqube-server=>name:sonar-server=><provide sonarqube ip>:9000=>credentials:sonat-token
goto dash board=>newitem(youtube-clone) select declarative pipeline (provided in git hub)


# install prometheus and grafana using terraform 

source for monitoring server (goto git hub =>a-youtube-clone.app=> servers => monitoring-server => terraform files (main.tf and provider.tf & install.sh))

downlod this files in your local desktop
inside files open vscode change some settings(like ami region)
open terminal(vscode)

terraform init
$ terraform plan
$ terraform validate
$ terraform apply --auto-approve

Now we can try to access it via the browser. I'm going to be using the IP address of the Ubuntu server. You need to append port 9090 to the IP.
<public-ip:9090>
# goto instance(monitoring-server) terminal
$ sudo apt update
$ sudo vim /etc/prometheus/prometheus.yml
add these content in end of file
  - job_name: node_export
    static_configs:
      - targets: ["<publicipof2nd instance>:9100"]
    save and exit
$ promtool check config /etc/prometheus/prometheus.yml
$ curl -X curl -X POST <publicipof2nd instance>/-/reload
$ http://<ip>:9090/targets

# grafana configuration and add prometheus dashboard into grafana

Go to http://<ip>:3000 and log in to the Grafana using default credentials. The username is admin, and the password is admin as well.
When you log in for the first time, you get the option to change the password.
To visualize metrics, you need to add a data source first.
Click Add data source and select Prometheus.
For the URL, enter http://localhost:9090 and click Save and test. You can see Data source is working.
name: prometheus
promethues serverurl: http://<ip>:9090
save and test
then goto dashboards
import dashboard
1860(for prometheus)
name:nodeexporter
selectdatasource: promtheus
import
Let's Monitor JENKINS SYSTEM & Need Jenkins up and running machine
Goto Manage Jenkins --> Plugins --> Available Plugins
Search for Prometheus and install it
Once that is done you will Prometheus is set to /Prometheus path in system configurations
uncheck last 2 checkboxs and apply and save
# To create a static target, you need to add job_name with static_configs.
$ sudo vim /etc/prometheus/prometheus.yml
  - job_name: 'jenkins'
    metrics_path: '/prometheus'
    static_configs:
      - targets: ['<jenkins-ip>:8080']
$ promtool check config /etc/prometheus/prometheus.yml
$ curl -X POST http://localhost:9090/-/reload

then build and watch grafana dashboard
# then install awscli (befor to install assign admin fullaccess role to the main instance)

# after install awscli 

$curl --slient --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp

$ cd temp/

$sudo mv /tmp/eksctl bin

$eksctl version
 # assign Admin access role to main instance 

 $cd ~
 # create cluster EKS_CLUSTRE

 $ eksctl create cluster --name EKS_CLUSTRE \
 > -- region us-east-2
 > -- node_type t2.small
 > -- nodes 3

 $kubectl get nodes
 $kubectl get svc

# insatall helm
 $ curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
 $ chmod 700 get_helm.sh
 $ ./get_helm.sh 
# add stable repo through helm
 $helm repo add stable  https://charts.helm.sh/stable
# add prometheus repo
$ helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
# create seperate namespace for prometheus
$ kubectl create namespace prometheus
# install prometheus through helm
$ helm install stable prometheus-community/kube-prometheus-stack -n prometheus
# check prometheus pods
$ kubectl get pods -n promethues
# check prometheus services
$ kubectl get svc -n promethues
# to expose the service to external world we create load balencer open file and change app protocol ip 8080 to 9090 and session efficiency type= LoadBalencer 
$ kubectl edit svc stable-kube-prometheus-sta-prometheus -n prometheus
- appProtocol:http
  name: reload-web
  port: 9090
  # change sessionAffinity: type
  type: LoadBalancer
  :wq!
  # to check service
  $ kubectl get svc -n promethues
  #copy load balancer id and search google with extension :9090
  # then go to graffan server add kubectl database in graffana server
  add datasource
  name:prometheus-EKS
  url:https://<loadbalancerid>:9090
  save&test
  #then add import dashboard for kubernates dashboard
  name: 15760
  datasource: prometheus-eks
  import
  # we can import kubernates cluster dashboard also
  name: 17119
  datasource: prometheus-eks
  import

  # configure the jenkins pipeline to deploy application on AWS EKS
  # go to managejenkins-plugins-download
  k8s
  k8s client APi
  k8s credentials 
  k8s cli

 # go to terminal /home/ubuntu/.kube configfile download to desktop
 open downloade file in notepad sava as secret.txt
 go to manage jenkins-> credentials->add credentials->with secret textfile
 id: kubernates
 choosefile: secret.txt
 save
 #then goto pipeline before post stage
 add 
 stage('deploy kubernates'){
  steps{
    script{
      dir('kubernates'){
        withKubeConfig(caCetificate: '', clusterName: '', contextName: '', credentialId: 'kubernates', namespace: '', ristrictKubeConfigAccess: false, serverUrl: ''){
        sh 'kubectl delete --all pods'
        sh 'kubectl apply -f deployment.yaml'
        sh 'kubectl apply -f service.yaml'
        }
      }
    }
  }
 }

 Apply & save build now
 # set trigger and verify the CICD pipeline

 goto github settings=>developer settings=>personalaccesstoken=>classic=>createtoken and copy the tocken
 goto jenkins server=>pipline configure=> github project=>provide project url
 :https://github.com/ajay/a-youtube-clone.com
 theen goto build triggers=>github hook triggers for gitscm polling
 then goto github=>open project settings=>under general=>createwebhooks
 addwebhooks=>payloadurl: <jenkinsip>:8080/github-webhook
 addwebhook
 then goto jenkins server apply & save build now
 change any thing from main code and push to git hub main folder the autometically build pipeline
 ex open gitbash $git clone https://github.com/ajay/a-youtube-clone.com
 $ cd a-youtube-clone
 $ ls
 $ vi read.me
 #changge some content in read me file
 $ git add .
 $ git commit -m "test file changed"
 $ git push origin main
 #in terminal 
 $ kubectl get svc
 # copy loadbalancer id past in google  

