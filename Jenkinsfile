pipeline {
    agent any

    environment {
        SONAR_AUTH_TOKEN = credentials('sonar-token')
        DOCKER_REGISTRY  = 'localhost:9082'
        IMAGE_NAME       = 'myapp'
        IMAGE_TAG        = '1.0'
        NEXUS_CRED_ID    = 'nexus-docker-cred'
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'master',
                    url: 'https://github.com/swetha-200160/java-project.git'
            }
        }

        stage('Build Project') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {   // <<----- CHANGE THIS NAME
                    sh """
                        mvn sonar:sonar \
                        -Dsonar.projectKey=my-java-project \
                        -Dsonar.host.url=http://localhost:9000 \
                        -Dsonar.login=${SONAR_AUTH_TOKEN}
                    """
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 2, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Push to Nexus Registry') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${NEXUS_CRED_ID}", usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh """
                        docker login ${DOCKER_REGISTRY} -u $USER -p $PASS
                        docker push ${DOCKER_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}
                    """
                }
            }
        }

        stage('Pull Image from Nexus Registry') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${NEXUS_CRED_ID}", usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh """
                        docker login ${DOCKER_REGISTRY} -u $USER -p $PASS
                        docker pull ${DOCKER_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}
                    """
                }
            }
        }
    }
}
