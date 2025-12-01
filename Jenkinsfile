pipeline {
  agent any

  environment {
    IMAGE_NAME = "simple-java-project"
    IMAGE_TAG  = "1.0.0"
    NEXUS_DOCKER = "<nexus-host>:5000" // replace with your nexus docker registry host:port
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build (Maven)') {
      steps {
        sh 'mvn -B -DskipTests package'
      }
    }

    stage('Build Docker image') {
      steps {
        sh 'docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .'
      }
    }

    stage('Login to Nexus Docker registry') {
      steps {
        // Credentials should be stored in Jenkins credentials and used via withCredentials
        sh 'docker login ${NEXUS_DOCKER} -u ${NEXUS_USER} -p ${NEXUS_PASS}'
      }
    }

    stage('Tag & Push to Nexus') {
      steps {
        sh 'docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${NEXUS_DOCKER}/${IMAGE_NAME}:${IMAGE_TAG}'
        sh 'docker push ${NEXUS_DOCKER}/${IMAGE_NAME}:${IMAGE_TAG}'
      }
    }

    stage('Optional: Deploy Maven artifact to Nexus') {
      steps {
        // This requires Jenkins to have settings.xml with server id 'nexus' and credentials
        sh 'mvn -s settings.xml deploy -DskipTests'
      }
    }
  }

  post {
    always {
      echo "Pipeline finished"
    }
  }
}
