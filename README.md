# mc-01-despliegue-microservicio-node-docker-k8s-ngrok

Desarrollo y despliegue de un microservicio con Node.js, Docker, Kubernetes y Ngrok.

## **0. Acceder al directorio**
```bash
cd /Users/diego/Desktop/repos/algoristica/mc-01-despliegue-microservicio-node-docker-k8s-ngrok
```

---

## **1. Crear el Dockerfile.dev y el docker-compose.yml**

---

## **2. Levantar y acceder al contenedor**
```bash
docker-compose up -d --build
docker exec -it microservicio_dev sh
```

---

## **3. Inicializar el proyecto de Node.js (dentro del contenedor)**
```bash
npm init -y
npm install express cors dotenv
```

---

## **4. Crear la estructura del proyecto**
```bash
mkdir src
touch src/index.js .env
```

---

## **5. Modificar la sección de Scripts en el package.json**
```json
"scripts": {
  "start": "node src/index.js",
  "dev": "nodemon src/index.js"
}
```

### **Ejecutar el servidor en modo producción**
```bash
npm run start
```

### **Ejecutar el servidor en modo desarrollo con Nodemon (recarga automática)**
```bash
npm run dev
```

### **Probar la API con curl**
```bash
curl http://localhost:3000/api/saludo
```

---

## **6. Crear el Dockerfile (para producción)**

---

## **7. Crear la imagen**
```bash
docker build -t microservicio:v1 .
```

---

## **8. Verificar que la imagen fue creada**
```bash
docker images
```

---

## **9. Probar la imagen de Docker (detener el primer contenedor)**
```bash
docker run -p 3000:3000 microservicio:v1
```

### **Ejecutar un curl para probar**
```bash
curl http://localhost:3000/api/saludo
```

---

# **Despliegue del microservicio en Kubernetes**

## **10. Crear una carpeta k8s en la raíz del proyecto y agregar los archivos `deployment.yaml` y `service.yaml`**

---

## **11. Instalar kubectl**
```bash
brew install kubectl
kubectl version --client
```

---

## **12. Instalar y configurar Minikube en macOS**
```bash
brew install minikube
minikube version
```

---

## **13. Iniciar un clúster local con Minikube**
```bash
minikube start
minikube status
```

---

## **14. Verificar la configuración actual de Kubernetes**
```bash
kubectl config view --minify
kubectl config get-clusters
kubectl config get-contexts
```

### **Seleccionar el contexto**
```bash
kubectl config use-context minikube
```

### **Verificar los nodos**
```bash
kubectl get nodes
```

---

## **15. Verificar la imagen en Docker**
```bash
docker images | grep microservicio
```

---

## **16. Cargar la imagen local en Minikube**
```bash
minikube image load microservicio:v1
```

---

## **17. Verificar que Minikube tiene la imagen**
```bash
minikube ssh
docker images | grep microservicio
exit
```

---

## **18. Aplicar la configuración en Kubernetes**
```bash
kubectl apply -f k8s/
```

---

## **19. Verificar los pods**
```bash
kubectl get pods
```

---

## **20. Eliminar todos los pods**
```bash
kubectl delete pod --all
```

---

## **21. Obtener la IP de Minikube**
```bash
minikube ip
```

---

## **22. Verificar puertos en Kubernetes**
```bash
kubectl get services
```

---

## **23. Revisar logs**
```bash
kubectl logs -l app=microservicio
```

---

## **24. Hacer cambios en el microservicio y actualizar la imagen**

- Modificar el código
- Hacer build con una nueva versión:

```bash
docker build -t microservicio:v2 .
```

- Cargar la nueva imagen en Minikube:

```bash
minikube image load microservicio:v2
```

- Modificar `deployment.yaml` para apuntar a la nueva versión:

```yaml
containers:
  - name: microservicio
    image: microservicio:v2
    imagePullPolicy: Never
    ports:
      - containerPort: 3000
```

- Aplicar cambios:

```bash
kubectl apply -f k8s/
kubectl delete pod --all
```

---

## **25. Entrar al contenedor de Kubernetes**
```bash
kubectl exec -it $(kubectl get pod -l app=microservicio -o jsonpath="{.items[0].metadata.name}") -- sh
```

---

## **26. Ver endpoints del contenedor**
```bash
kubectl get endpoints microservicio-service
```

---

## **27. Exponer manualmente el servicio con Minikube**
```bash
minikube service microservicio-service --url
```

---

## **28. Logs del contenedor**
```bash
kubectl logs -l app=microservicio
```

---

## **29. Reiniciar Minikube**
```bash
minikube stop
minikube start
kubectl delete svc microservicio-service
kubectl apply -f k8s/service.yaml
```

---

## **30. Verificar puertos**
```bash
minikube ssh -- sudo netstat -tulnp | grep 63383
```

---

## **31. Hacer un port-forward**
```bash
kubectl port-forward svc/microservicio-service 8080:3000
```

---

# **Exponer el servicio con Ngrok**

## **32. Instalar y Configurar Ngrok**
```bash
brew install ngrok
```

### **Verificar la versión**
```bash
ngrok version
```

---

## **33. Crear una cuenta en Ngrok**

---

## **34. Agregar autenticación de Ngrok**
```bash
ngrok config add-authtoken 2sj9CTGXwPPYKNsJOMGZHAIxiKo_3khUYLpBJoyasDJ4L3cvG
```

---

## **35. Exponer el servicio con Ngrok**
```bash
ngrok http http://localhost:8080
```

### **Probar la API desde internet**
```bash
curl https://<URL_GENERADA_POR_NGROK>/api/saludo
```

# Solución a la práctica propuesta

## **1. Modificar el código del src/index.js**

## **2. Construir una nueva imagen con la versión v2.**
```bash
docker build -t microservicio:v2 .
```

## **3. Cargar la nueva imagen en Minikube..**
```bash
minikube image load microservicio:v2
```

## **4. Actualizar deployment.yaml para apuntar a la nueva imagen.**

## **5. Aplicar los cambios en Kubernetes.**
```bash
kubectl apply -f k8s/
kubectl delete pod --all
```

## **6. Verificar que el servicio sigue corriendo.**
```bash
kubectl get pods
kubectl get services
```

## **7. Hacer port-forward y usar ngrok.**
