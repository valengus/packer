pipeline {
  agent {label 'packer'}

  stages {

    stage('Build') {
      steps {
        echo 'Build'
      }
    }

    stage('Test') {
      steps {
        echo 'Test'
      }
    }

    stage('Release') {
      steps {
          echo 'release'
      }
    }

    stage('Cleanup') {
      steps {
          echo 'cleanup'
      }
    }

  }
}
