pipeline { agent any
  environment {
    NEXUS_REG = "localhost:8083"
    IMAGE = "${NEXUS_REG}/docker-hosted/my-java-app:latest"
    CONTAINER = "myapp-from-nexus"
  }
  stages {
    stage('Docker Login') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'nexus-docker-cred', usernameVariable: 'NEXUS_USER', passwordVariable: 'NEXUS_PASS')]) {
          bat 'echo %NEXUS_PASS% | docker login %NEXUS_REG% -u %NEXUS_USER% --password-stdin'
        }
      }
    }
    stage('Pull & Run') {
      steps {
        bat '''
          docker pull %IMAGE%
          docker rm -f %CONTAINER% || echo none
          docker run -d -p 8085:8080 --name %CONTAINER% %IMAGE%
        '''
      }
    }
  }
  post { always { bat 'docker logout %NEXUS_REG% || echo logout' } }
}
