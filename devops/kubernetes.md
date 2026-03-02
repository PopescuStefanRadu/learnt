kind - best
kubectl - main base tool
kubectx - uses kubectl
kubens - uses kubectl
k9s - uses kubectl

echo "source <(kubectl completion bash)" >> ~/.bashrc # add autocomplete permanently to your bash shell.


helm install incubator/sparkoperator --namespace demo --generate-name


kubectl create serviceaccount spark -n demo


kubectl create clusterrolebinding spark-role --clusterrole=edit --serviceaccount=demo:spark --namespace=demo 

https://github.com/GoogleCloudPlatform/spark-on-k8s-operator
