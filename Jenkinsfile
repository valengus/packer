pipeline {
  agent {label 'packer'}

  // options {
  //   skipDefaultCheckout()
  // }

  parameters {
    choice(name: 'PACKER_PROVIDER', choices: ['qemu', 'virtualbox-iso', 'vmware-iso' ],  description: 'build provider')
    string(name: 'PACKER_BOX', defaultValue: 'windows-11', description: '*.pkr.hcl file name')
  }

  triggers {
      pollSCM 'H/5 *  * * *'
  }

  stages {

    stage('Build') {
      steps {
        echo '> building $params.PACKER_BOX'
        echo '> for $params.PACKER_PROVIDER'
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