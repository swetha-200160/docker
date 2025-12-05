pipeline {
    agent any

    stages {

        stage('Checkout Code') {
            steps {
                git 'https://github.com/swetha-200160/java-project.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat """
                    docker build -t localhost:8082/myapp:latest .
                """
            }
        }

        stage('Login to Nexus Docker Registry') {
            steps {
                bat """
                    echo yourpassword | docker login localhost:8082 -u admin --password-stdin
                """
            }
        }

        stage('Push Docker Image to Nexus') {
            steps {
                bat """
                    docker push localhost:8082/myapp:latest
                """
            }
        }
    }
}
