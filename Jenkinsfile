pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = 'LKIAQAAAAAAAIOFPSI36'
        AWS_SECRET_ACCESS_KEY = 'p4VoUAkjIKZKyTAQco/KtX5fRIZjDye/DuxJvo+C'
        AWS_REGION = 'eu-north-1'
        AWS_ENDPOINT_URL = 'http://localhost:4566'  // LocalStack endpoint
    }

    stages {
        stage('Start LocalStack') {
            steps {
                script {
                    def localstack_running = sh(script: "docker ps | grep localstack || true", returnStdout: true).trim()
                    if (!localstack_running) {
                        sh 'docker run -d --name localstack -p 4566:4566 localstack/localstack'
                        sh 'sleep 5'  // Give it time to start
                    }
                }
            }
        }

        stage('Clone Repository') {
            steps {
                git 'https://github.com/ShivamChavan01/Terraform-Nginx-EC2-Deployment'
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }

        stage('Verify Nginx') {
            steps {
                script {
                    def instance_ip = sh(script: "terraform output public_ip", returnStdout: true).trim()
                    sh "curl -I http://${instance_ip}"
                }
            }
        }
    }

    post {
        success {
            echo '🚀 Deployment Successful!'
        }
        failure {
            echo '❌ Deployment Failed'
        }
    }
}
