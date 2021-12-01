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
          if (PACKER_PROVIDER == 'qemu') { BOX_SUFFIX = 'libvirt' }
          else if (PACKER_PROVIDER == 'virtualbox-iso') { BOX_SUFFIX = 'virtualbox' }
          else if (PACKER_PROVIDER == 'vmware-iso') { BOX_SUFFIX = 'vmware' }
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

      steps {
        script {
          if (PACKER_PROVIDER == 'qemu') { env.VAGRANT_DEFAULT_PROVIDER = 'libvirt' }
          else if (PACKER_PROVIDER == 'virtualbox-iso') { env.VAGRANT_DEFAULT_PROVIDER = 'virtualbox' }
          else if (PACKER_PROVIDER == 'vmware-iso') { env.VAGRANT_DEFAULT_PROVIDER = 'vmware_desktop' }
        }
        sh "du -hs $params.PACKER_BOX-${BOX_SUFFIX}.box"
        sh "vagrant box add --force $params.PACKER_BOX-test $params.PACKER_BOX-${BOX_SUFFIX}.box"
        sh "vagrant init $params.PACKER_BOX-test"
        sh "vagrant up"
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