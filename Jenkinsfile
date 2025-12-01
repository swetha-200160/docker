pipeline {
    agent any

    environment {
        IMAGE_NAME = "my-java-app"
        CONTAINER_NAME = "java-app"
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/<YOUR-USERNAME>/<YOUR-REPO>.git', branch: 'main'
            }
        }

        stage('Build Maven') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t my-java-app .'
            }
        }

        stage('Deploy Docker Container') {
            steps {
                sh '''
                if [ "$(docker ps -aq -f name=java-app)" ]; then
                    docker rm -f java-app
                fi

                docker run -d -p 8085:8080 --name java-app my-java-app
                '''
            }
        }
    }
}
