#!/bin/bash

# Variables
APP_NAME="nat-go-app"
NAMESPACE="nat-go-app"
REGISTRY="localhost:5000" # Для локального registry

echo "Building Docker image..."
docker build -t $APP_NAME:latest .

# Если используете локальный registry
echo "Pushing to local registry..."
docker tag $APP_NAME:latest $REGISTRY/$APP_NAME:latest
docker push $REGISTRY/$APP_NAME:latest

echo "Deploying to k3s..."
kubectl apply -f namespace.yaml
kubectl apply -f configmap.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f ingress.yaml

echo "Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod -l app=$APP_NAME -n $NAMESPACE --timeout=60s

echo "Deployment complete!"
echo "Check pods:"
kubectl get pods -n $NAMESPACE
echo "Check service:"
kubectl get svc -n $NAMESPACE
echo "Check ingress:"
kubectl get ingress -n $NAMESPACE
