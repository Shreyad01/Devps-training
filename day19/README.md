## Project Overview

In this capstone project, you will create a comprehensive automated deployment pipeline for a web application on an AWS EC2 instance running Ubuntu using Ansible. You will follow best practices for playbooks and roles, implement version control, document and maintain your code, break down tasks into roles, write reusable and maintainable code, and use dynamic inventory scripts. This project will culminate in a fully functional deployment, demonstrating your mastery of Ansible for infrastructure automation.

## Project Objectives

+ Set up an AWS EC2 instance as a worker node.
+ Implement Ansible playbooks and roles following best practices.
+ Use version control to manage Ansible codebase.
+ Document Ansible roles and playbooks.
+ Break down deployment tasks into reusable roles.
+ Write reusable and maintainable Ansible code.
+ Use dynamic inventory scripts to manage AWS EC2 instances.
+ Deploy a web application on the EC2 instance.


## Project Components and Milestones

EC2 Instances given will have a tag of Role: webserver and Name: <Participants Name> so you will be able to ping each other VMs.

Example:
```
Instance 1
Role: webserver
Name: Bhavin
```

### Milestone 1: Environment Setup

#### Objective: Configure your development environment and AWS infrastructure.

**Tasks:**

+ Launch an AWS EC2 instance running Ubuntu.
+ Install Ansible and Git on your local machine or control node.

<br>

![alt text](images/image.png)

<br>

![alt text](images/image-7.png)

<br>

![alt text](images/image-1.png)

**Deliverables:**

+ AWS EC2 instance running Ubuntu.
+ Local or remote control node with Ansible and Git installed.

### Milestone 2: Create Ansible Role Structure

#### Objective: Organize your Ansible project using best practices for playbooks and roles.

**Tasks:**

+ Use Ansible Galaxy to create roles for web server, database, and application deployment.
+ Define the directory structure and initialize each role.

<br>

![alt text](images/image-2.png)

<br>

![alt text](images/image-3.png)

<br>

![alt text](images/image-4.png)

**Deliverables:**

+ Ansible role directories for webserver, database, and application.


### Milestone 3: Version Control with Git

#### Objective: Implement version control for your Ansible project.

**Tasks:**

+ Initialize a Git repository in your project directory.
+ Create a .gitignore file to exclude unnecessary files.
+ Commit and push initial codebase to a remote repository.

<br>

![alt text](images/image-5.png)

**Deliverables:**

+ Git repository with initial Ansible codebase.
+ Remote repository link (e.g., GitHub).

<br>

![alt text](images/image-6.png)

### Milestone 4: Develop Ansible Roles

#### Objective: Write Ansible roles for web server, database, and application deployment.

**Tasks:**

+ Define tasks, handlers, files, templates, and variables within each role.
+ Ensure each role is modular and reusable.

[frontend tasks file]()

```
---
- name: Install Nginx
  apt:
    name: nginx
    state: present
  become: true

- name: Ensure Nginx is running and enabled
  service:
    name: nginx
    state: started
    enabled: yes
  become: true

- name: Copy Nginx configuration file
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
  become: true
  notify:
    - Restart Nginx
  become: true

```

[frontend handlers file]()

```
---
- name: Restart Nginx
  service:
    name: nginx
    state: restarted
  become: true
```

[frontend vars file]()

```

server_name: 13.57.183.235  # ip address of the ec2 instance
root_dir: /usr/share/nginx/html
backend_host: 127.0.0.1  # ip address of backend host
backend_port: 3000  # port on which backend is listening
```

[frontend templates file]()

```
events {}

http {
    server {
        listen 80;
        server_name localhost;

        location / {
            root {{root_dir}};
            index index.html;
        }
        location /api/ {
            proxy_pass http://localhost:3000/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
```

[backend tasks file]()

```
---
- name: Install Node.js
  apt:
    name: nodejs
    state: present
    update_cache: yes

- name: Install npm
  apt:
    name: npm
    state: present

- name: Create application directory
  file:
    path: /usr/src/app
    state: directory

- name: Deploy backend application
  template:
    src: index.js.j2
    dest: /usr/src/app/index.js

- name: Deploy package.json
  copy:
    src: ../files/package.json
    dest: /usr/src/app/package.json

- name: Install Node.js dependencies
  npm:
    path: /usr/src/app
    state: present

- name: Start backend application
  shell: node /usr/src/app/index.js &
```

[backend vars file]()

```
db_host: localhost             # database host name
db_user: user              # database user name
db_password: password      # user password
db_name: tesDB                    # database name
```

[backend templates file]()

```
const express = require('express');
const mysql = require('mysql');
const app = express();
const port = 3000;

const connection = mysql.createConnection({
    host: '{{ db_host }}',
    user: '{{ db_user }}',
    password: '{{ db_password }}',
    database: '{{ db_name }}'
});

connection.connect((err) => {
    if (err) {
        console.error('Error connecting to the database:', err);
        return;
    }
    console.log('Connected to the MySQL database.');
});

app.get('/', (req, res) => {
    res.send('Hello from Node.js Backend!');
});

app.get('/data', (req, res) => {
    connection.query('SHOW DATABASES;', (err, results) => {
        if (err) throw err;
        res.send(results);
    });
});

app.listen(port, () => {
    console.log(`App running on http://localhost:${port}`);
});
```

[database tasks file]()

```
---
- name: Install MySQL
  apt:
    name: "{{ item }}"
    state: present
    update_cache: yes
  become: yes
  loop:
    - mysql-server
    - mysql-client
    - python3-mysqldb
    - libmysqlclient-dev

- name: Start and enable MySQL service
  service:
    name: mysql
    state: started
    enabled: yes
  become: yes

- name: Adding mysql config file
  template:
    src: .my.cnf.j2
    dest: /root/.my.cnf
  become: yes

- name: Ensure MySQL root password is set
  mysql_user:
    name: root
    host: localhost
    password: '{{ db_root_password }}'
    check_implicit_admin: yes
  become: yes

- name: Create application database and user
  mysql_db:
    name: '{{ db_name }}'
    state: present
  become: yes

- name: Create application user
  mysql_user:
    name: '{{ db_user }}'
    password: '{{ db_password }}'
    priv: '{{ db_name }}.*:ALL'
    state: present
  become: yes
```

[database vars file]()

```
---
db_user: user
db_password: user@123
db_root_password: password
db_name: testdb
```
**Deliverables:**

+ Completed Ansible roles for webserver, database, and application.

### Milestone 5: Documentation and Maintenance

#### Objective: Document your Ansible roles and playbooks for future maintenance.

**Tasks:**

+ Create README.md files for each role explaining purpose, variables, tasks, and handlers.
+ Add comments within your playbooks and roles to explain complex logic.

**Deliverables:**

+ README.md files for webserver, database, and application roles.
+ Well-documented playbooks and roles.


### Milestone 6: Dynamic Inventory Script

#### Objective: Use dynamic inventory scripts to manage AWS EC2 instances.

**Tasks:**

+ Write a Python script that queries AWS to get the list of EC2 instances.
+ Format the output as an Ansible inventory.

[ec2_inventory.py]()

```
#!/usr/bin/env python3

import json
import boto3

def get_inventory():
    ec2 = boto3.client(service_name='ec2', region_name='us-west-1')  # Specify your region
    response = ec2.describe_instances(Filters=[{'Name': 'tag:Name', 'Values': ['Shreya']}])
    
    inventory = {
        'all': {
            'hosts': [],
            'vars': {}
        },
        '_meta': {
            'hostvars': {}
        }
    }
    
    ssh_key_file = '/home/einfochips/Downloads/ansible-new.pem'  # Path to your SSH private key file
    ssh_user = 'ubuntu'  # SSH username
    
    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            public_dns = instance.get('PublicDnsName', instance['InstanceId'])
            inventory['all']['hosts'].append(public_dns)
            inventory['_meta']['hostvars'][public_dns] = {
                'ansible_host': instance.get('PublicIpAddress', instance['InstanceId']),
                'ansible_ssh_private_key_file': ssh_key_file,
                'ansible_user': ssh_user
            }

    return inventory

if __name__ == '__main__':
    print(json.dumps(get_inventory()))
```

+ change permission of inventory.py file

```
chmod +x ec2_inventory.py
```


**Deliverables:**

+ Dynamic inventory script to fetch EC2 instance details.
 + write folloeing content in ansible.cfg file

 ```
 [defaults]
inventory=/home/einfochips/Desktop/learning/day19/ec2_inventory.py
 ```

+ do `aws configure`
+ give `AWS Access Key ID` , `AWS Secret Access Key` , `Region name` and `output format `

<br>

![alt text](images/image-9.png)
+ to check if dynamic inventory works correctly use below command

```
ansible all --list-hosts
```
```
ansible all -m ping
```

<br>

![alt text](images/image-8.png)
### Milestone 7: Playbook Development and Deployment

#### Objective: Create and execute an Ansible playbook to deploy the web application.

**Tasks:**

+ Develop a master playbook that includes all roles.
+ Define inventory and variable files for different environments.
+ Execute the playbook to deploy the web application on the EC2 instance.

```
ansible-playbook deploy.yml
```
<br>

![alt text](images/image-10.png)

<br>

![alt text](images/image-11.png)

**Deliverables:**

+ Ansible playbook for web application deployment.
+ Successfully deployed web application on the EC2 instance.

<br>

![alt text](images/image-12.png)

<br>

![alt text](images/image-13.png)
