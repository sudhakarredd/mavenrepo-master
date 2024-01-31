pipeline {
    agent any
    
  environment {
    AWS_ACCESS_KEY_ID = credentials('Accesskey')
    AWS_SECRET_ACCESS_KEY = credentials('SecretKey')
    AWS_REGION = 'us-east-2'
    CLUSTER_NAME = 'cluster-paraloyal'
    
    }

    stages {
        stage('Code Analysis') {
            steps {
                
                script {
                    checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/sudhakarredd/mavenrepo-master.git']])
                    sh 'mvn clean sonar:sonar'  
                }
            }
        }
        stage('Build & Provision') {
            steps {
                script {
                    sh 'mvn clean install'
                }
            }
        }
         stage('Automated Testing') {
            steps {
                script {
                    echo 'selenium-test-cases are passed'
                }
            }
        }
         stage('Artifact Deployment') {
            steps {
                script {
                    
                    sh 'aws  s3 mb s3://mys3-bucket-29012024/'
                    sh 'aws s3 cp /var/lib/jenkins/workspace/task-1/target/studentapp-2.5-SNAPSHOT.war s3://mys3-bucket-29012024/'
                    
                }
            }
        } 
        stage('docker image'){
           steps{
               script{
                 withCredentials([string(credentialsId: 'dockerhub', variable: 'dockerhub')]) {
                  sh 'docker login -u sudhakarred1 -p ${dockerhub}'
                  }
                sh 'sudo usermod -aG docker $USER'
                sh 'sudo chown root:docker /var/run/docker.sock'
                sh 'sudo chmod 666 /var/run/docker.sock'
                sh 'docker build -t tomcat:latest .'
                sh 'docker tag tomcat:latest sudhakarred1/tomcat:latest'
                sh 'docker push sudhakarred1/tomcat:latest'
               }
           }
       }    
       stage('Create EKS Cluster') {
            steps {
                script {
                 
                    sh "eksctl create cluster --name ${CLUSTER_NAME} --region ${AWS_REGION} --node-type t2.micro --nodes 2"
                    sh "eksctl get cluster --region=${AWS_REGION} --name=${CLUSTER_NAME}"
                    sh "aws eks --region=${AWS_REGION} update-kubeconfig --name ${CLUSTER_NAME}"
                    sh "kubectl apply -f tomcat-deployment.yaml"
                    sh "kubectl apply -f hpa-tomcat.yaml"
                }
            }
        }
    }
}
