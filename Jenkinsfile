pipeline {
  agent any

  environment {
    IMAGE_NAME = "my-java-app"                      // local image name
    IMAGE_TAG  = "${env.BUILD_NUMBER ?: 'latest'}" // tag for image
    DOCKER_REG  = ""                                // set to dockerhub/repo if pushing
    CONTAINER_NAME = "java-app"
  }

  stages {
    stage('Checkout') {
      steps {
        git url: 'https://github.com/swetha-200160/docker.git', branch: 'main' // update to your repo
      }
    }

    stage('Build (Maven)') {
      steps {
        // If using Linux agent with maven installed:
        sh 'mvn -B clean package -DskipTests'

        // If on Windows agents, replace with: bat 'mvn -B clean package -DskipTests'
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          // build image using tag
          sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
        }
      }
    }

    stage('Optional: Push to Docker Registry') {
      when { expression { return env.DOCKER_REG != "" } }
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh '''
            docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${DOCKER_REG}:${IMAGE_TAG}
            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
            docker push ${DOCKER_REG}:${IMAGE_TAG}
            docker logout
          '''
        }
      }
    }

    stage('Deploy (stop old / run new)') {
      steps {
        script {
          // remove old container if exists
          sh '''
            if [ "$(docker ps -aq -f name=${CONTAINER_NAME})" ]; then
              docker rm -f ${CONTAINER_NAME} || true
            fi
            docker run -d -p 8085:8080 --name ${CONTAINER_NAME} ${IMAGE_NAME}:${IMAGE_TAG}
          '''
        }
      }
    }
  }

  post {
    success {
      echo "Pipeline finished successfully"
    }
    failure {
      echo "Pipeline failed"
    }
  }
}
