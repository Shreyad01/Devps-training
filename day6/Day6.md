**Project 01**

**Deploying a Node.js App Using Minikube Kubernetes**

**Overview**

This project guides you through deploying a Node.js application using Minikube Kubernetes. You'll use Git for version control, explore branching and fast-forward merges, and set up Kubernetes services and deployment pods, including ClusterIP and NodePort service types.

**Prerequisites**

- Minikube installed
- kubectl installed
- Git installed
- Node.js installed ([https://nodejs.org/en/download/package-manager/all#debian-and-ubuntu- based-linux-distributions](https://nodejs.org/en/download/package-manager/all#debian-and-ubuntu-based-linux-distributions))

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.001.png)

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.002.png)

`  `**Project Steps**

#### 1. Set Up Git Version Control
1. **Initialize a Git Repository**

Create a new directory for your project: 

`mkdir nodejs-k8s-project`

`cd nodejs-k8s-project`

Initialize a Git repository: 
`git init`

2. **Create a Node.js Application**

Initialize a Node.js project: `npm init -y`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.003.png)

Install Express.js: `npm install express`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.004.png)

Create an **index.js** file with the following content: 
```
const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
    res.send('Hello, Kubernetes!');
});

app.listen(port, () => {
    console.log(`App running at http://localhost:${port}`);
});
```


![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.005.png)


Create a **.gitignore** file to ignore node_modules: `node_modules`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.006.png)

3. **Commit the Initial Code**

Add files to Git: `git add .`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.007.png)

Commit the changes:

`git commit -m "Initial commit with Node.js app"`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.008.png)

#### 2. **Branching and Fast-Forward Merge**
1. **Create a New Branch**

Create and switch to a new branch feature/add-route: 
`git checkout -b feature/add-route`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.009.png)

2. **Implement a New Route**

Modify index.js to add a new route: 
```
   app.get('/newroute', (req, res) => {
   res.send('This is a new route!'); });
```

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.010.png)

`    `Commit the changes: `git add .`

`git commit -m "Add new route"`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.011.png)

3. **Merge the Branch Using Fast-Forward**

Switch back to the main branch: `git checkout master`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.012.png)

Merge the feature/add-route branch using fast-forward: 
`git merge --ff-only feature/add-route`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.013.png)

Delete the feature branch:

`git branch -d feature/add-route`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.014.png)

#### 3. **Containerize the Node.js Application**
1. **Create a Dockerfile**

Create a **Dockerfile** with the following content: 
```
FROM node:14
WORKDIR /app

COPY package\*.json ./ RUN npm install

COPY . .

EXPOSE 3000

CMD ["node", "index.js"]
```


![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.015.png)

2. **Build and Test the Docker Image**

Build the Docker image: 

`docker build -t nodejs-k8s-app .`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.016.png)

Run the Docker container to test: 

`docker run -p 3000:3000 nodejs-k8s-app`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.017.png)

1 Access `http://localhost:3000`to see the app running.

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.018.png)

#### 4. **Deploying to Minikube Kubernetes**
1. **Start Minikube**

Start Minikube:

`minikube start`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.019.png)

2. **Create Kubernetes Deployment and Service Manifests** Create a deployment.yaml file:

```
   apiVersion: apps/v1
kind: Deployment
metadata:
  name: nodejs-app
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
        image: nodejs-k8s-app:latest
        ports:
        - containerPort: 3000

```
![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.020.png)

Create a service.yaml file for ClusterIP: 
```
apiVersion: v1
kind: Service
metadata:
  name: nodejs-service
spec:
  selector:
    app: nodejs-app
  ports:
  - protocol: TCP
    port: 80
    targetPort: 3000
  type: ClusterIP
```

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.021.png)

Create a service-nodeport.yaml file for NodePort: 
```
apiVersion: v1
kind: Service
metadata:
  name: nodejs-service-nodeport
spec:
  selector:
    app: nodejs-app
  ports:
  - protocol: TCP
    port: 80
    targetPort: 3000
    nodePort: 30001
  type: NodePort
```

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.022.png)

3. **Apply Manifests to Minikube**

Apply the deployment:

`kubectl apply -f deployment.yaml`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.023.png)

Apply the ClusterIP service: 

`kubectl apply -f service.yaml`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.024.png)

Apply the NodePort service:

`kubectl apply -f service-nodeport.yaml`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.025.png)

4. **Access the Application**

Get the Minikube IP: `minikube ip`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.026.png)

1 Access the application using the NodePort:

` curl http://192.168.49.2:30001 `

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.027.png)

**Making Changes to the App and Redeploying Using Kubernetes**

#### 6. **Making Changes to the Node.js Application**
1. **Create a New Branch for Changes**

Create and switch to a new branch feature/update-message: 

`git checkout -b feature/update-message`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.028.png)

2. **Update the Application**

Modify index.js to change the message: 
```
const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
    res.send('Hello, Kubernetes! Updated version.');
});

app.get('/newroute', (req, res) => {
    res.send('This is a new route!');
});

app.listen(port, () => {
    console.log(`App running at http://localhost:${port}`);
});
```

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.029.png)

3. **Commit the Changes**

Add and commit the changes: `git add .`

`git commit -m "Update main route message"`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.030.png)

#### 7. **Merge the Changes and Rebuild the Docker Image**
1. **Merge the Feature Branch**

Switch back to the main branch: `git checkout master`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.031.png)

Merge the feature/update-message branch: `git merge --ff-only feature/update-message`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.032.png)

Delete the feature branch:

`git branch -d feature/update-message`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.033.png)

2. **Rebuild the Docker Image**

Rebuild the Docker image with a new tag: `docker build -t nodejs-k8s-app:v2 .`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.034.png)

#### 8. **Update Kubernetes Deployment**
1. **Update the Deployment Manifest**

Modify deployment.yaml to use the new image version: 
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nodejs-app
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
        image: shreyad01/node:nodejs-k8s-app_v2
        ports:
        - containerPort: 3000
```

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.035.png)

2. **Apply the Updated Manifest**

Apply the updated deployment: 
`kubectl apply -f deployment.yaml`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.036.png)

3. **Verify the Update**

Check the status of the deployment:

`kubectl rollout status deployment/nodejs-app`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.037.png)

#### 9. **Access the Updated Application**
1. **Access Through ClusterIP Service**

Forward the port to access the ClusterIP service: 
`kubectl port-forward service/nodejs-service 8083:80`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.038.png)

1 Open your browser and navigate to `http://localhost:8080` to see the updated message.

2. **Access Through NodePort Service**

1 Access the application using the NodePort:

`curl http://192.168.49.2:30001`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.039.png)

### Project 02 

**Deploying a Python Flask App Using Minikube Kubernetes**

**Overview**

This project guides you through deploying a Python Flask application using Minikube Kubernetes. You'll use Git for version control, explore branching and fast-forward merges, and set up Kubernetes services and deployment pods, including ClusterIP and NodePort service types.

**Prerequisites**

- Minikube installed
- kubectl installed
- Git installed
- Python installed

**Project Steps**

#### 1. **Set Up Git Version Control**
1. **Initialize a Git Repository**

Create a new directory for your project: 

`mkdir flask-k8s-project`

`cd flask-k8s-project`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.040.png)

Initialize a Git repository: 
sh
Copy code

`git init`

2. **Create a Python Flask Application**

Create a virtual environment: 
`python -m venv venv`
`source venv/bin/activate`

Install Flask: 
sh
Copy code
`pip install Flask`

Create an **app.py** file with the following content: 
python
Copy code
```
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello, Kubernetes!'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.041.png)

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.042.png)

Create a **requirements.txt** file to list the dependencies: 
Copy code

`Flask`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.043.png)

Create a **.gitignore** file to ignore venv: 
Copy code

`venv`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.044.png)

3. **Commit the Initial Code**

Add files to Git: 
+ `git add .`

Commit the changes:

`git commit -m "Initial commit with Flask app"`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.045.png)

#### 2. **Branching and Fast-Forward Merge**
+ 2.1. **Create a New Branch**

Create and switch to a new branch **feature/add-route**: 
`git checkout -b feature/add-route`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.046.png)

+ 2.2. **Implement a New Route**

Modify **app.py** to add a new route: 
```
@app.route('/newroute')
def new_route():
    return 'This is a new route!'
```

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.047.png)

+ Commit the changes: 
`git add .`

`git commit -m "Add new route"`

![](Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.048.png)

+ 2.3. **Merge the Branch Using Fast-Forward**

Switch back to the **main** branch: 
`git checkout master`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.049.png)

Merge the **feature/add-route** branch using fast-forward: 
`git merge --ff-only feature/add-route`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.050.png)

Delete the feature branch:

`git branch -d feature/add-route`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.051.png)

#### 3. **Containerize the Flask Application**
1. **Create a Dockerfile**

Create a **Dockerfile** with the following content: 
```
FROM python:3.8-slim
WORKDIR /app
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
COPY . .
EXPOSE 5000
CMD ["python", "app.py"]
```

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.052.png)

2. **Build and Test the Docker Image**

Build the Docker image: `docker build -t flask-k8s-app .`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.053.png)

Run the Docker container to test: `docker run -p 5000:5000 flask-k8s-app`

2 Access `http:192.168.56.13:5000` to see the app running.

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.054.png)

#### 4. **Deploying to Minikube Kubernetes**
1. **Start Minikube**

Start Minikube: minikube start

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.055.png)

2. **Create Kubernetes Deployment and Service Manifests** 

Create a **deployment.yaml** file:
```
   apiVersion: apps/v1
kind: Deployment
metadata:
  name: flask-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: flask-app
  template:
    metadata:
      labels:
        app: flask-app
    spec:
      containers:
      - name: flask-app
        image: flask-k8s-app:latest
        ports:
        - containerPort: 5000
```

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.056.png)

Create a **service.yaml** file for ClusterIP: 
```
apiVersion: v1
kind: Service
metadata:
  name: flask-service
spec:
  selector:
    app: flask-app
  ports:
  - protocol: TCP
    port: 80
    targetPort: 5000
  type: ClusterIP
```

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.057.png)

Create a **service-nodeport.yaml** file for NodePort: 
```
apiVersion: v1
kind: Service
metadata:
  name: flask-service-nodeport
spec:
  selector:
    app: flask-app
  ports:
  - protocol: TCP
    port: 80
    targetPort: 5000
    nodePort: 30001
  type: NodePort
```

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.058.png)

3. **Apply Manifests to Minikube**

Apply the deployment:

`kubectl apply -f deployment.yaml`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.059.png)

Apply the ClusterIP service: 

`kubectl apply -f service.yaml`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.060.png)

Apply the NodePort service:

`kubectl apply -f service-nodeport.yaml`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.061.png)

4. **Access the Application**

Get the Minikube IP: 
`minikube ip`

Access the application using the NodePort: 
`curl http://192.168.49.2:30002`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.062.png)

#### 5. **Clean Up** 

Stop Minikube: 

`minikube stop`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.063.png)

Delete Minikube cluster: 
   
`minikube delete`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.064.png)

#### 6. **Making Changes to the Flask Application**
1. **Create a New Branch for Changes**

Create and switch to a new branch feature/update-message: 

`git checkout -b feature/update-message`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.065.png)

2. **Update the Application**

Modify app.py to change the message: 
```
@app.route('/')
def hello_world():
    return 'Hello, Kubernetes! Updated version.'
cat 
@app.route('/newroute')
def new_route():
    return 'This is a new route!'
```

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.066.png)

3. **Commit the Changes**

Add and commit the changes: 

`git add .`

`git commit -m "Update main route message"`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.067.png)

#### 7. **Merge the Changes and Rebuild the Docker Image**
1. **Merge the Feature Branch**

Switch back to the main branch: 

`git checkout master`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.068.png)

Merge the feature/update-message branch: 

`git merge --ff-only feature/update-message`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.069.png)

Delete the feature branch:

`git branch -d feature/update-message`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.070.png)

2. **Rebuild the Docker Image**

Rebuild the Docker image with a new tag: 

`docker build -t flask-k8s-app:v2 .`

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.071.png)

#### 8. **Update Kubernetes Deployment**
1. **Update the Deployment Manifest**

Modify **deployment.yaml** to use the new image version: 
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: flask-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: flask-app
  template:
    metadata:
      labels:
        app: flask-app
    spec:
      containers:
      - name: flask-app
        image: shreyad01/node:flask-k8s-app_v2
        ports:
- containerPort: 5000
```

![](images/Aspose.Words.e14945ca-558a-4ac6-b29c-ab67d6867b10.072.png)

2. **Apply the Updated Manifest**

Apply the updated deployment: 
sh
Copy code

`kubectl apply -f deployment.yaml`

3. **Verify the Update**

Check the status of the deployment: 
sh
Copy code

`kubectl rollout status deployment/flask-app`

9. **Access the Updated Application**
1. **Access Through ClusterIP Service**

Forward the port to access the ClusterIP service: 

`kubectl port-forward service/flask-service 8080:80`

1 Open your browser and navigate to `http://192.168.49.2:8080` to see the updated message.

2. **Access Through NodePort Service**

1 Access the application using the NodePort:

`curl http://192.168.49.2:30001`


