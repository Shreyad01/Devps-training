## Project 01

In this project, you will develop a simple Node.js application, deploy it on a local Kubernetes cluster using Minikube, and configure various Kubernetes features. The project includes Git version control practices, creating and managing branches, and performing rebases. Additionally, you will work with ConfigMaps, Secrets, environment variables, and set up vertical and horizontal pod autoscaling.

**Project 01 Project Steps**

### 1.Setup Minikube and Git Repository

**Start Minikube**:

**1.2 Set Up Git Repository**

**Create a new directory for your project**:

`mkdir nodejs-k8s-project `

`cd nodejs-k8s-project`

**Initialize Git repository**: 

`git init`

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.001.png)

**Create a .gitignore file**:

```
node_modules/ 
.env
```

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.002.png)

**Add and commit initial changes**:

`git add .`

`git commit -m "Initial commit"`

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.003.png)

#### 2. **Develop a Node.js Application**
1. **Create the Node.js App Initialize the Node.js project**:

   `npm init -y`

   ![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.004.png)

   **Install necessary packages**: `npm install express body-parser`

   ![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.005.png)

   **Create app.js**:

```
  const express = require('express');
const bodyParser = require('body-parser');
const app = express();
const PORT = process.env.PORT || 3000;

app.use(bodyParser.json());

app.get('/', (req, res) => {
  res.send('Hello, World!');
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
```

   ![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.006.png)

**Update package.json** to include a start script:

```
   "scripts": {
   "start": "node app.js", }
```

   ![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.007.png)

2. **Commit the Node.js Application Add and commit changes**:

   `git add .`

   `git commit -m "Add Node.js application code"`

   ![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.008.png)

### 3. **Create Dockerfile and Docker Compose**
1. **Create a Dockerfile Add Dockerfile**:

```
# Use official Node.js image
FROM node:18

# Set the working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose the port on which the app runs
EXPOSE 3000

# Command to run the application
CMD [ "npm", "start" ]
```

  ![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.009.png)

  **Create a .dockerignore file**:

```
  node_modules 
  .npm
```

  ![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.010.png)

2. **Create docker-compose.yml (optional for local testing) Add docker-compose.yml**:

```
  version: '3'
services:
  app:
    build: .
    ports:
      - "3000:3000"
```

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.011.png)

**Add and commit changes**:

`git add Dockerfile docker-compose.yml`

`git commit -m "Add Dockerfile and Docker Compose configuration"`

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.012.png)

### 4. Build and Push Docker Image
1. **Build Docker Image**

**Build the Docker image**: `docker build -t nodejs-app:latest .`

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.013.png)

2. **Push Docker Image to Docker Hub Tag and push the image**:

   `docker tag nodejs-app:latest your-dockerhub-username/nodejs-app:latest`

   ![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.014.png)

   `docker push your-dockerhub-username/nodejs-app:latest`

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.015.png)

**Add and commit changes**:

`git add .`

`git commit -m "Build and push Docker image"`

![](Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.016.png)

### 5. **Create Kubernetes Configurations**
1. **Create Kubernetes Deployment Create kubernetes/deployment.yaml**:

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nodejs-app-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nodejs-app
  template:
    metadata:
      labels:
        app: nodejs-app
    spec:
      containers:
      - name: nodejs-app
        image: your-dockerhub-username/nodejs-app:latest
        ports:
        - containerPort: 3000
        env:
        - name: PORT
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: PORT
        - name: NODE_ENV
          valueFrom:
            secretKeyRef:
              name: app-secrets
              key: NODE_ENV
```

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.017.png)

2. **Create ConfigMap and Secret Create kubernetes/configmap.yaml**:

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
 data:
  PORT: "3000"
```

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.018.png)

**Create kubernetes/secret.yaml**:

```
apiVersion: v1
kind: Secret
metadata:
  name: app-secrets
type: Opaque
data:
  NODE_ENV: cHJvZHVjdGlvbmFs # Base64 encoded value for "production"
```

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.019.png)

**Add and commit Kubernetes configurations**:

`git add kubernetes/`

`git commit -m "Add Kubernetes deployment, configmap, and secret"`

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.020.png)

3. **Apply Kubernetes Configurations Apply the ConfigMap and Secret**:

   `kubectl apply -f kubernetes/configmap.yaml`

   ![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.021.png)

  `kubectl apply -f kubernetes/secret.yaml`

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.022.png)

**Apply the Deployment**:

`kubectl apply -f kubernetes/deployment.yaml`

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.023.png)

### 6. **Implement Autoscaling**
1. **Create Horizontal Pod Autoscaler Create kubernetes/hpa.yaml**:

```
  apiVersion: autoscaling/v2beta2
kind: HorizontalPodAutoscaler
metadata:
  name: nodejs-app-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: nodejs-app-deployment
  minReplicas: 2
  maxReplicas: 5
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50
```

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.024.png)

**Apply the HPA**:

`kubectl apply -f kubernetes/hpa.yaml`

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.025.png)

2. **Create Vertical Pod Autoscaler Create kubernetes/vpa.yaml**:

```
apiVersion: autoscaling.k8s.io/v1beta2
kind: VerticalPodAutoscaler
metadata:
  name: nodejs-app-vpa
spec:
  targetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: nodejs-app-deployment
  updatePolicy:
    updateMode: "Auto"
```

**Apply the VPA**:

`kubectl apply -f kubernetes/vpa.yaml`


![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.026.png)

### 7. Test the Deployment
1. **Check the Status of Pods, Services, and HPA Verify the Pods**:

   `kubectl get pods`

   ![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.027.png)

   **Verify the Services**: `kubectl get svc`

   ![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.028.png)

   **Verify the HPA**: `kubectl get hpa`

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.029.png)

2. **Access the Application Expose the Service**:

  `kubectl expose deployment nodejs-app-deployment --type=NodePort –name=nodejs-app- service`

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.030.png)

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.031.png)

**Get the Minikube IP and Service Port**: 

`minikube service nodejs-app-service –url`

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.032.png)

￿ **Access the Application** in your browser using the URL obtained from the previous command.

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.033.png)

### 8. **Git Version Control**
1. **Create a New Branch for New Features Create and switch to a new branch**:

   `git checkout -b feature/new-feature`

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.034.png)

**Make changes and commit**:

- Make some changes

`git add .`

`git commit -m "Add new feature"`

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.035.png)

**Push the branch to the remote repository**: 

`git push origin feature/new-feature`

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.036.png)

2. **Rebase Feature Branch on Main Branch**

**Switch to the main branch and pull the latest changes**:

`git checkout main`

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.037.png)

`git pull origin main`

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.038.png)

**Rebase the feature branch**: 

`git checkout feature/new-feature`

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.039.png)

`git rebase main`

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.040.png)

**Resolve conflicts if any, and continue the rebase**:

`git add .`

`git rebase --continue`

**Push the rebased feature branch**:

`git push origin feature/new-feature –force`

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.041.png)

### 9. **Final Commit and Cleanup**

**Merge feature branch to main**: 

`git checkout main`

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.042.png)

`git merge feature/new-feature`

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.043.png)

**Push the changes to the main branch**: 

`git push origin main`

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.044.png)

### Clean up :

g`it branch -d feature/new-feature`

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.045.png)

`git push origin --delete feature/new-feature`

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.046.png)

## Project 02

Deploy a Node.js application to Kubernetes with advanced usage of ConfigMaps and Secrets. Implement Horizontal Pod Autoscaler (HPA) with both scale-up and scale-down policies. The project will include a multi-environment configuration strategy, integrating a Redis cache, and monitoring application metrics.

**Project Setup**

### 1. Initialize a Git Repository

Create a new directory for your project and initialize Git:

`mkdir nodejs-advanced-k8s-project `

`cd nodejs-advanced-k8s-project`

`git init `

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.047.png)

2. **Create Initial Files**

Create the initial Node.js application and Docker-related files:

` npm init -y`

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.048.png)

`npm install express redis body-parser`

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.049.png)

**app.js**

```
const express = require('express');
const bodyParser = require('body-parser');
const redis = require('redis');
const app = express();
const PORT = process.env.PORT || 3000;

// Connect to Redis
const redisClient = redis.createClient({
  url: `redis://${process.env.REDIS_HOST}:${process.env.REDIS_PORT}`
});
redisClient.on('error', (err) => console.error('Redis Client Error', err));

app.use(bodyParser.json());

app.get('/', async (req, res) => {
  const visits = await redisClient.get('visits');
  if (visits) {
    await redisClient.set('visits', parseInt(visits) + 1);
  } else {
    await redisClient.set('visits', 1);
  }
  res.send(`Hello, World! You are visitor number ${visits || 1}`);
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
```

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.050.png)

**Dockerfile**

```
FROM node:18

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm", "start"]
```

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.051.png)

**.dockerignore**

```
node_modules 
.npm
```

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.052.png)

### 1. **Build and push Docker image:**

  `docker build -t your-dockerhub-username/nodejs-advanced-app:latest .`

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.053.png)

`docker push your-dockerhub-username/nodejs-advanced-app:latest`

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.054.png)

### 2. **Advanced Kubernetes Configuration**
1. **Deployment Configuration**

Create `kubernetes/deployment.yaml` to deploy the Node.js application with Redis dependency:

```
yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nodejs-advanced-app-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nodejs-advanced-app
  template:
    metadata:
      labels:
        app: nodejs-advanced-app
    spec:
      containers:
      - name: nodejs-advanced-app
        image: your-dockerhub-username/nodejs-advanced-app:latest
        ports:
        - containerPort: 3000
        env:
        - name: PORT
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: PORT
        - name: REDIS_HOST
          valueFrom:
            configMapKeyRef:
              name: redis-config
              key: REDIS_HOST
        - name: REDIS_PORT
          valueFrom:
            configMapKeyRef:
              name: redis-config
              key: REDIS_PORT
        - name: NODE_ENV
          valueFrom:
            secretKeyRef:
              name: app-secrets
              key: NODE_ENV
      - name: redis
        image: redis:latest
        ports:
        - containerPort: 6379
```

2. **ConfigMap for Application and Redis**

Create kubernetes/configmap.yaml to manage application and Redis configurations:

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  PORT: "3000"

---
apiVersion: v1
kind: ConfigMap
metadata:
  name: redis-config
data:
  REDIS_HOST: "redis"
  REDIS_PORT: "6379"
```

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.055.png)

3. **Secret for Sensitive Data**

Create kubernetes/secret.yaml to manage sensitive environment variables:

```
apiVersion: v1
kind: Secret
metadata:
  name: app-secrets
type: Opaque
data:
  NODE_ENV: cHJvZHVjdGlvbg== # Base64 encoded value for "production"
```

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.056.png)

4. **Service Configuration**

Create kubernetes/service.yaml to expose the Node.js application:

```
apiVersion: v1
kind: Service
metadata:
  name: nodejs-advanced-app-service
spec:
  selector:
    app: nodejs-advanced-app
  ports:
  - protocol: TCP
    port: 80
    targetPort: 3000
  type: LoadBalancer
```

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.057.png)

5. **Horizontal Pod Autoscaler with Scale-Up and Scale-Down Policies**

Create kubernetes/hpa.yaml to manage autoscaling:

```
apiVersion: autoscaling/v2beta2
kind: HorizontalPodAutoscaler
metadata:
  name: nodejs-advanced-app-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: nodejs-advanced-app-deployment
  minReplicas: 2
  maxReplicas: 5
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 70
```

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.058.png)

6. **Vertical Pod Autoscaler Configuration**

Create kubernetes/vpa.yaml to manage vertical scaling:

```
apiVersion: autoscaling.k8s.io/v1beta2
kind: VerticalPodAutoscaler
metadata:
  name: nodejs-advanced-app-vpa
spec:
  targetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: nodejs-advanced-app-deployment
  updatePolicy:
    updateMode: "Auto"
```

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.059.png)

7. **Redis Deployment**

Add a Redis deployment configuration to kubernetes/redis-deployment.yaml:

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
    spec:
      containers:
      - name: redis
        image: redis:latest
        ports:
        - containerPort: 6379
```

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.060.png)

Add Redis service configuration to kubernetes/redis-service.yaml:

```
apiVersion: v1
kind: Service
metadata:
  name: redis-service
spec:
  selector:
    app: redis
  ports:
  - protocol: TCP
    port: 6379
    targetPort: 6379
  type: ClusterIP
```

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.061.png)

8. **Apply Kubernetes Configurations**

Apply all configurations to your Minikube cluster: 
`kubectl apply -f kubernetes/redis-deployment.yaml`

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.062.png)

`kubectl apply -f kubernetes/redis-service.yaml`

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.063.png)

`kubectl apply -f kubernetes/configmap.yaml`

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.064.png)

`kubectl apply -f kubernetes/secret.yaml`

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.065.png)

`kubectl apply -f kubernetes/deployment.yaml`

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.066.png)

`kubectl apply -f kubernetes/service.yaml`

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.067.png)

`kubectl apply -f kubernetes/hpa.yaml`

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.068.png)

`kubectl apply -f kubernetes/vpa.yaml`

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.069.png)

9. **Verify Deployments and Services**

Check the status of your deployments and services: `kubectl get all`

Access the application via Minikube:

`minikube service nodejs-advanced-app-service –url`

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.070.png)

10. **Testing Scaling**

Simulate load on the application to test the HPA:

`kubectl run -i --tty --rm load-generator --image=busybox --restart=Never -- /bin/sh`

- Inside the pod, run the following command to generate load

`while true; do wget -q -O- http://nodejs-advanced-app-service; done`

11. **Validate Autoscaling Behavior**

Observe the HPA behavior: `kubectl get hpa`

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.071.png)

Watch the scaling events and verify that the application scales up and down based on the policies you configured.

## 3. Project Wrap-Up

**3.1 Review and Clean Up**

After completing the project, review the configurations and clean up the Minikube environment if needed:

`minikube delete`

![](images/Aspose.Words.2ba6b277-9cbb-4085-831f-42287bb78a56.072.png)
