// WIP ...
pipeline {
    agent any

    environment {
        TF_VAR_access_key = credentials('AWS_ACCESS_KEY_ID')
        TF_VAR_secret_key = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    
                    checkout scm
                }
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                   
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }
}