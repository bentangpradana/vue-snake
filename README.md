
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

1. Berapa lama waktu yang Anda habiskan untuk menyelesaikan coding test ini?
2. Apa yang Anda pelajari atau tantangan terbesar yang Anda hadapi selama pengerjaan
tugas ini?
3. Apakah ada alternatif solusi atau pendekatan lain yang Anda pertimbangkan? Jelaskan.
4. Bagaimana solusi yang Anda buat memastikan skalabilitas dan performa yang optimal?
5. Bagaimana Anda akan meningkatkan keamanan dalam pipeline ini jika diterapkan pada
lingkungan produksi?
6. Apakah ada langkah tambahan yang bisa dilakukan untuk monitoring dan logging di aplikasi
ini? (optional)

jawaban:

1. Menghabiskan waktu sekitar 2 hari untuk menyelesaikan tugas ini, mulai dari instalasi wsl,docker dekstop hingga penerapan pipeline dan monitoring menggunakan prometheus serta grafana.
2. Tantangan terbesar adalah memastikan integrasi yang baik antara docker, kubernetes, dan ci/cd pipeline di gitLab. mengkonfigurasi gitlab-ci.yml untuk membangun dan menerapkan automation ci/cd, serta mengatasi 
   masalah dengan node-exporter pada prometheus dan memastikan semuanya berjalan lancar.
3. Saya mempertimbangkan beberapa pendekatan alternatif, seperti menggunakan jenkins sebagai ci/cd pipeline daripada gitLab ci/cd namun pada akhirnya saya memutuskan untuk menggunakan gitlab ci/cd karena saya 
   merasa tidak perlu untuk menginstallasi jenkins dan hanya melakukan setup langsung ke runner dengan gitlab ci/cd . saya juga mempertimbangkan untuk menggunakan Minikube untuk menjalankan kubernetes secara 
   local, tetapi saya memilih docker desktop dikarenakan saya merasa lebih mudah untuk diintegrasikan dengan wsl 2 di windows 11.
4. Untuk memastikan skalabilitas dan performa, saya menggunakan kubernetes dengan menambah replika pod dengan menggunakan hpa. saya juga menerapkan monitoring dengan prometheus dan grafana untuk melihat performa 
   aplikasi dan cluster kubernetes, yang memungkinkan saya dapat mendeteksi dini terhadap masalah yang mungkin mempengaruhi kinerja dari aplikasi.
5. - penggunaan secrets semua kredensial dan informasi sensitif seperti username, password, dan token disimpan sebagai secrets di kubernetes dan gitLab ci/cdd, bukan hardcoded di file pipeline.
   - image scanning melakukan scanning terhadap docker image untuk memastikan tidak ada kerentanan sebelum dipush ke registry mungkin dengan menggunakan trivy.
   - menambahkan sonarqube dalam pipeline ci/cd untuk melakukan analisis code secara otomatis setiap kali ada perubahan code. sonarqube membantu mendeteksi bug, kerentanan keamanan, dan code smells. dengan ini, 
     kita bisa memastikan kualitas code yang lebih baik dan keamanan yang lebih ketat dalam pengembangan.
   - menggunakan RBAC di kubernetes untuk memastikan hanya user atau service account tertentu yang dapat mengakses dan mengelola resources.
   - monitoring dan logging memantau pipeline dan cluster secara terus-menerus untuk mendeteksi aktivitas mencurigakan.
6. - menambahkan loki sebagai solusi logging untuk aplikasi ataupun open telementry. ini akan memudahkan pengumpulan log aplikasi yang berjalan di dalam kubernetes.
   - mengintegrasikan alertmanager untuk mengirimkan notifikasi ketika ada masalah dalam cluster kubernetes, seperti pod yang gagal atau penggunaan resource yang tinggi.
   - mengkonfigurasi grafana dashboards yang lebih mendalam, dengan fokus pada monitoring resource cluster kubernetes dan juga pods aplikasi (cpu, memori, dll.) serta kinerja aplikasi.
