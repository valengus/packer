pipeline {
  agent {label 'packer'}

  parameters {
    booleanParam(name: 'RefreshOnly', defaultValue: true, description: 'Read Jenkinsfile and exit.')
    choice(name: 'PACKER_PROVIDER', choices: ['qemu', 'virtualbox-iso', 'vmware-iso' ],  description: 'build provider')
    string(name: 'PACKER_BOX', defaultValue: 'windows-11-pro', description: '*.pkr.hcl file name')
  }

  triggers {
      pollSCM 'H/5 *  * * *'
  }

  stages {

    stage('Info') {
      when { expression { return params.RefreshOnly == false } }
      steps {
        script {
          if (PACKER_PROVIDER == 'qemu') { VAGRANT_PROVIDER = 'libvirt' } 
          else if (PACKER_PROVIDER == 'virtualbox-iso') { VAGRANT_PROVIDER = 'virtualbox' } 
          else if (PACKER_PROVIDER == 'vmware-iso') { VAGRANT_PROVIDER = 'vmware' }
        }
        echo "> building $params.PACKER_BOX box for $params.PACKER_PROVIDER provider"
        sh 'packer --version'
        sh 'vagrant --version'
        sh 'ansible --version'
      }
    }

    // stage('Build') {
    //   when { expression { return params.RefreshOnly == false } }
    //   steps {
    //     sh "packer build --only=$params.PACKER_PROVIDER'.'$params.PACKER_BOX $params.PACKER_BOX'.'pkr.hcl"
    //   }
    // }

    stage('Test') {
      when { expression { return params.RefreshOnly == false } }
      // environment {
      //   VAGRANT_DEFAULT_PROVIDER = VAGRANT_PROVIDER
      // }
      steps {

        echo "VAGRANT_PROVIDER: ${VAGRANT_PROVIDER}"
        sh "echo $VAGRANT_PROVIDER"
        sh "du -hs $params.PACKER_BOX-${VAGRANT_PROVIDER}.box"
        sh "vagrant box add $params.PACKER_BOX-test $params.PACKER_BOX-${VAGRANT_PROVIDER}.box"
        sh "env"
      }
    }

    stage('Release') {
      when { expression { return params.RefreshOnly == false } }
      steps {
          echo 'Release'
      }
    }

    stage('Cleanup') {
      when { expression { return params.RefreshOnly == false } }
      steps {
          echo 'cleanup'
          sh 'du -hs .'
      }
    }

  }
}