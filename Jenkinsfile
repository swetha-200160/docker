pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/swetha-200160/java-project.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("localhost:8082/myapp:latest")
                }
            }
        }

        stage('Login to Nexus') {
            steps {
                script {
                    sh "docker login localhost:8082 -u admin -p yourpassword"
                }
            }
        }

        stage('Push to Nexus') {
            steps {
                script {
                    dockerImage.push()
                }
            }
        }
    }
}
