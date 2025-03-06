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
            def docker_running = bat(script: "docker info", returnStatus: true) == 0
            if (!docker_running) {
                error "Docker is not running. Please start Docker and try again."
            }
            def localstack_running = bat(script: "docker ps | findstr localstack", returnStdout: true).trim()
            if (!localstack_running) {
                bat 'docker run -d --name localstack -p 4566:4566 localstack/localstack'
                bat 'timeout /t 5'  // Give it time to start
            }
        }
    }
}



        stage('Clone Repository') {
    steps {
        git branch: 'main', url: 'https://github.com/ShivamChavan01/Terraform-Nginx-EC2-Deployment'
    }
}


        stage('Terraform Init') {
            steps {
                bat 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                bat 'terraform plan'
            }
        }

        stage('Terraform Apply') {
            steps {
                bat 'terraform apply -auto-approve'
            }
        }

        stage('Verify Nginx') {
            steps {
                script {
                    def instance_ip = bat(script: "terraform output public_ip", returnStdout: true).trim()
                    bat "curl -I http://${instance_ip}"
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
