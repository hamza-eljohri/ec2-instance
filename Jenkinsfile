// WIP ...

pipeline {
    agent any

    environment {
        TF_VAR_access_key = credentials('AWS_ACCESS_KEY_ID')
        TF_VAR_secret_key = credentials('AWS_SECRET_ACCESS_KEY')
        TF_VAR_remote_state = credentials('remote_state')
        TF_VAR_AWS_REGION = credentials('aws_region')
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
                    withCredentials([
                        string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'ACCESS_KEY'),
                        string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'SECRET_KEY'),
                        string(credentialsId: 'remote_state', variable: 'REMOTE_STATE'),
                        string(credentialsId: 'aws_region', variable: 'AWS_REGION')
                    ]) {
                        // Create backend.tf dynamically using echo and variable substitution with sh
                        sh """
                        echo 'provider "aws" {' > backend.tf
                        echo '  region     = "${AWS_REGION}"' >> backend.tf
                        echo '  access_key = "${ACCESS_KEY}"' >> backend.tf
                        echo '  secret_key = "${SECRET_KEY}"' >> backend.tf
                        echo '}' >> backend.tf
                        echo '' >> backend.tf
                        echo 'terraform {' >> backend.tf
                        echo '  required_version = ">= 0.13.5"' >> backend.tf
                        echo '  required_providers {' >> backend.tf
                        echo '    aws = {' >> backend.tf
                        echo '      source  = "hashicorp/aws"' >> backend.tf
                        echo '      version = ">= 4.67.0"' >> backend.tf
                        echo '    }' >> backend.tf
                        echo '  }' >> backend.tf
                        echo '  backend "s3" {' >> backend.tf
                        echo '    bucket         = "${REMOTE_STATE}"' >> backend.tf
                        echo '    dynamodb_table = "${REMOTE_STATE}"' >> backend.tf
                        echo '    region         = "${AWS_REGION}"' >> backend.tf
                        echo '    key            = "${TF_VAR_project_name}"' >> backend.tf
                        echo '  }' >> backend.tf
                        echo '}' >> backend.tf
                        """
                    }
                    sh 'cat backend.tf'
                    sh 'terraform init'
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
