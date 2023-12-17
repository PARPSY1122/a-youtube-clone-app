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

