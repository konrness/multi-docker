set -e

docker build -t konrness/fibonacci-client:latest -t konrness/fibonacci-client:$SHA -f ./client/Dockerfile ./client
docker build -t konrness/fibonacci-server:latest -t konrness/fibonacci-server:$SHA -f ./server/Dockerfile  ./server
docker build -t konrness/fibonacci-worker:latest -t konrness/fibonacci-worker:$SHA -f ./worker/Dockerfile  ./worker

docker push konrness/fibonacci-client:latest
docker push konrness/fibonacci-server:latest
docker push konrness/fibonacci-worker:latest

docker push konrness/fibonacci-client:$SHA
docker push konrness/fibonacci-server:$SHA
docker push konrness/fibonacci-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/client-deployment server=konrness/fibonacci-client:$SHA
kubectl set image deployments/server-deployment server=konrness/fibonacci-server:$SHA
kubectl set image deployments/worker-deployment server=konrness/fibonacci-worker:$SHA