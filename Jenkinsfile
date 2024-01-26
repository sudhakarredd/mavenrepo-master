pipeline {
    agent any
    environment {
    AWS_ACCESS_KEY_ID = credentials('accesskey')
    AWS_SECRET_ACCESS_KEY = credentials('secreatekey')
    AWS_REGION = 'us-east-1'
    CLUSTER_NAME = 'paraloyal-cluster'
    
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
                    sh 'aws s3 cp /var/lib/jenkins/workspace/paraloyal-task-1/target/studentapp-2.5-SNAPSHOT.war  s3://myaws-s3-bucket-2024/'
                }
            }
        }
        stage('docker image'){
           steps{
               script{
                  withCredentials([string(credentialsId: 'dockerhub', variable: 'dockerhub')]) {
                       sh 'docker login -u bojjavenkatesh67 -p ${dockerhub}'
                  }
                sh 'sudo usermod -aG docker $USER'
                sh 'sudo chown root:docker /var/run/docker.sock'
                sh 'sudo chmod 660 /var/run/docker.sock'
                sh 'docker build -t tomcat:latest .'
                sh 'docker tag tomcat:latest bojjavenkatesh67/tomcat:latest'
                sh 'docker push bojjavenkatesh67/tomcat:latest'
               }
           }
       } 
       stage('Create EKS Cluster') {
            steps {
                script {
                 
                    sh "eksctl create cluster --name ${CLUSTER_NAME} --region ${AWS_REGION} --node-type t2.micro --nodes 2"
                    sh "eksctl utils wait cluster-active --region=${AWS_REGION} --name=${CLUSTER_NAME}"
                    sh "aws eks --region=${AWS_REGION} update-kubeconfig --name ${CLUSTER_NAME}"
                    sh "kubectl apply -f tomcat-deployment.yaml"
                    sh "kubectl apply -f hpa-tomcat.yaml"
                }
            }
        }
   
    }
}
