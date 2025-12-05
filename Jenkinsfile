pipeline {
    agent any

    environment {
        REGISTRY_URL = "localhost:8082"
        IMAGE_NAME   = "myapp"
        IMAGE_TAG    = "latest"
        DOCKER_CREDS = "docker-nexus-creds"
        HOST_PORT    = "9090"   // Use a free port on Windows
        CONTAINER_PORT = "8080" // Internal container port
    }

    stages {

        stage('Login to Nexus Docker Registry') {
            steps {
                withCredentials([usernamePassword(credentialsId: DOCKER_CREDS, usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    bat """
                        echo %PASS% | docker login %REGISTRY_URL% -u %USER% --password-stdin
                    """
                }
            }
        }

        stage('Pull Image From Nexus') {
            steps {
                bat """
                    docker pull %REGISTRY_URL%/%IMAGE_NAME%:%IMAGE_TAG%
                """
            }
        }

        stage('Run Docker Container') {
            steps {
                bat """
                    docker stop myapp-container || echo Container not running
                    docker rm myapp-container || echo No container to remove
                    docker run -d --name myapp-container -p %HOST_PORT%:%CONTAINER_PORT% %REGISTRY_URL%/%IMAGE_NAME%:%IMAGE_TAG%
                """
            }
        }
    }

    post {
        always {
            bat "docker logout %REGISTRY_URL%"
        }
    }
}
