pipeline {
  agent {label 'packer'}

  parameters {
    booleanParam(name: 'RefreshOnly', defaultValue: true, description: 'Read Jenkinsfile and exit.')
    choice(name: 'PACKER_PROVIDER', choices: ['qemu', 'virtualbox-iso', 'vmware-iso' ],  description: 'build provider')
    string(name: 'PACKER_BOX', defaultValue: 'windows-11', description: '*.pkr.hcl file name')
  }

  triggers {
      pollSCM 'H/5 *  * * *'
  }

  stages {

    stage('Build') {
      when { expression { return params.RefreshOnly == false } }
      steps {
        echo "> building $params.PACKER_BOX"
        echo "> for $params.PACKER_PROVIDER"
      }
    }

    stage('Test') {
      when { expression { return params.RefreshOnly == false } }
      steps {
        echo 'Test'
      }
    }

    stage('Release') {
      when { expression { return params.RefreshOnly == false } }
      steps {
          echo 'release'
      }
    }

    stage('Cleanup') {
      when { expression { return params.RefreshOnly == false } }
      steps {
          echo 'cleanup'
      }
    }

  }
}