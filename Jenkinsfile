pipeline {
    agent any

    environment {
        IMAGE_NAME = "my-java-app"
        CONTAINER_NAME = "java-app"
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/swetha-200160/docker.git', branch: 'master'
            }
        }

        stage('Build Maven') {
            steps {
                bat 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat 'docker build -t my-java-app .'
            }
        }

        stage('Deploy Docker Container') {
            steps {
                bat '''
                docker ps -a --filter "name=java-app" -q > tmp.txt
                for /f %%i in (tmp.txt) do docker rm -f %%i
                docker run -d -p 8085:8080 --name java-app my-java-app
                '''
            }
        }
    }
}
