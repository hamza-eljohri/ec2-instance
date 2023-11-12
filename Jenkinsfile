// WIP ...
pipeline {
    agent any

    environment {
        TF_VAR_access_key = credentials('AWS_ACCESS_KEY_ID')
        TF_VAR_secret_key = credentials('AWS_SECRET_ACCESS_KEY')
        TF_VAR_remote_state = credentials('remote_state')
        TF_VAR_aws_region = credentials('aws_region')
        TF_VAR_branch_name = "${BRANCH_NAME}"
        TF_VAR_project_name = "${JOB_BASE_NAME}"
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
                    terraform init
                    echo $TF_VAR_branch_name
                    echo $TF_VAR_project_name
                    echo $TF_VAR_aws_region
                    echo $TF_VAR_remote_state
                    '''
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