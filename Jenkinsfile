// WIP ...
pipeline {
    agent any

    environment {
        TF_VAR_access_key = credentials('AWS_ACCESS_KEY_ID')
        TF_VAR_secret_key = credentials('AWS_SECRET_ACCESS_KEY')
        TF_VAR_remote_state = credentials('remote_state')
        TF_VAR_aws_region = credentials('aws_region')
        TF_VAR_branch_name = "${BRANCH_NAME}"
        TF_VAR_project_name = env.GIT_URL.replace('.git', '').split('/').last()                              
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    
                    checkout scm
                }
            }
        }

        stage('Terraform backend') {
            steps {
                script {
                    
                    sh '''
                      cat > backend.tf <<EOF
                    provider "aws" {
                        region = "$TF_VAR_aws_region"
                    }
                    terraform {
                        required_version = ">= 0.13.5"
                        required_providers {
                            aws = {
                                source  = "hashicorp/aws"
                                version = ">= 4.67.0"
                            }
                        }
                        backend "s3" {
                            bucket         = "$TF_VAR_remote_state"
                            dynamodb_table = "$TF_VAR_remote_state"
                            region         = "$TF_VAR_aws_region"
                            key            = "$TF_VAR_project_name"
                        }
                    }
                    EOF
                    '''
                    sh 'cat backend.tf'
                }
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    
                    sh 'terraform init'
                    sh 'terraform workspace select ${TF_VAR_branch_name} || terraform workspace new ${TF_VAR_branch_name}'
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