
## how to use it 
im using docker dekstop and wsl 2 in windows 11 
### install WSL2
use powershell
```
wsl --install
```
check version
```
wsl -l -v 
```
if already wsl2 to open your microsoft store and download ubuntu if not try this command:
```
wsl --set-version 2
```
### Docker 
download docker desktop 
```
https://www.docker.com/products/docker-desktop/
```
after installation make sure ur activate wsl integration to ubuntu: 
```
docker-dektop > settings > resources > wsl integration > checklist ubuntu 
```
activate too ur kubernetes engine 
```
docker-dektop > settings > checklist enable kubernetes
```
check into ur ubuntu docker and kubernetes already running
```
docker version
kubectl version
```

### build image
im using node 14 because the node-sass version : 4.13.1 and not support to latest node version

testing to build and run image 
```
docker build -t vue-snake:v1 . && docker run -dp 8080:8080
```
check ur image to ur browser :
```
http://localhost:8080
```
stop and remove the container after succesfully checking the image
```
docker container rm -f (container_id)
```
## now Gitlab Ci/CD 

create a repository and push ur code into gitlab repository 

### install gitlab runner
install the runner in ur ubuntu
```
sudo yum install gitlab-runner
```
check ur runner its already installed 
```
systemctl status gitlab-runner
```
### cheat sheat
```
sudo gitlab-runner start #for starting
sudo gitlab-runner stop  #for stoping
sudo gitlab-runner restart #for restarting
sudo gitlab-runner verify #for verify runner
```
### register ur runner using self runner hosted
```
on your gitlab page  goto repository > settings > cicd > expand runner
and then copy gitLab server url and registration token as shown below to ur host runner
```
### Configuration ur gitlab-ci.yaml
im using docker build and deploy for the stage, check the .gitlab-ci.yml for the variable needed
```
the variable its on your gitlab page  goto repository > settings > cicd > variable 
```
### explanation of variable
```
 $REGISTRY_USERNAME : gitlab username  
 $REGISTRY_PASSWORD : gitlab password
 $CI_REGISTRY_IMAGE : its predifined variable from gitlab for container registry
 $CI_PIPELINE_ID    : its predifined variable from gitlab for pipeline id
 $SSH_PASSWORD      : password ssh to ubuntu   
 $SERVER_USER       : server user ubuntu
 $SERVER_IP         : ubuntu ip 
 ```
 dont forget to create secret on ur ubuntu for pulling image in private registry
 ```
kubectl create secret docker-registry <secret-name> --docker-server=<your-registry-server> --docker-username=<your-name> --docker-password=<your-pswrd> --docker-email=<your-email>
 ```
### Run pipeline
```
on the page of gitlab goto pipeline > run pipeline 
```
in build job the command will be build a docker image and push it to gitlab registry
in deploy job the command will be ssh into local ubuntu and deploy all file in /deployment to kubernetes

### checking the deploy was succesfull
after run this command try to ur browser http://localhost:8080
```
kubectl port-forward svc/vue-snake-game 8080:8080
```

### here the video results
```
https://drive.google.com/file/d/1MB75aMf5QtHD57rtQin-fQLtzD7Fobh6/view?usp=sharing
```
## now monitoring 
im using helm package manager for my grafana and prometheus

### installing helm
this script from the official helm website
```
 curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
 chmod 700 get_helm.sh
 ./get_helm.sh
```
check the version 
```
helm version
```

### Installing prometheus and grafana

add repo
```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo update
```
check the repo list  
```
helm repo list
```

installing prometheus
```
helm install prometheus prometheus-community/kube-prometheus-stack
```

if the pods node exporter error
```
kubectl patch ds monitoring-prometheus-node-exporter --type "json" -p '[{"op": "remove", "path" : "/spec/template/spec/containers/0/volumeMounts/2/mountPropagation"}]'
```

go to grafana dashboard
```
 kubectl port-forward deployment/prometheus-grafana 3000
```
default user and pass
```
user: admin
pass: prom-prometheus
```
