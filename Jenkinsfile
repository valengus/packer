pipeline {
  agent {label 'packer'}

  parameters {
    gitParameter (name: 'BRANCH', type: 'PT_BRANCH', defaultValue: 'main')
    booleanParam (name: 'RefreshOnly', defaultValue: true, description: 'Read Jenkinsfile and exit.')
    choice (name: 'PACKER_PROVIDER', choices: ['qemu', 'virtualbox-iso', 'vmware-iso' ],  description: 'build provider')
    string (name: 'PACKER_BOX', defaultValue: 'windows-11-pro', description: '*.pkr.hcl file name')
    string (name: 'CLOUD_TOKEN', defaultValue: '', description: 'token for vagrant cloud')
  }

  triggers {
      pollSCM 'H/5 *  * * *'
  }

  environment {
    CLOUD_TOKEN = "$params.CLOUD_TOKEN"
  }

  stages {

    stage('Info') {
      when { expression { return params.RefreshOnly == false } }
      steps {
        script {
          echo "Git BRANCH is ${params.BRANCH}"
          git branch: "${params.BRANCH}", url: 'https://github.com/valengus/packer.git'

          if (PACKER_PROVIDER == 'qemu') { 
            BOX_SUFFIX = 'libvirt'
            env.VAGRANT_DEFAULT_PROVIDER = 'libvirt'
          }
          else if (PACKER_PROVIDER == 'virtualbox-iso') { 
            BOX_SUFFIX = 'virtualbox' 
            env.VAGRANT_DEFAULT_PROVIDER = 'virtualbox'
          }
          else if (PACKER_PROVIDER == 'vmware-iso') { 
            BOX_SUFFIX = 'vmware'
            env.VAGRANT_DEFAULT_PROVIDER = 'vmware_desktop'
          }
        }
        echo "> building CLOUD_TOKEN box for $params.PACKER_PROVIDER provider"
        sh 'packer --version'
        sh 'vagrant --version'
        sh 'ansible --version'
        sh 'env'
      }
    }

    stage('Build') {
      when { expression { return params.RefreshOnly == false } }
      steps {
        sh "packer build --force --only=$params.PACKER_PROVIDER'.'$params.PACKER_BOX $params.PACKER_BOX'.'pkr.hcl"
      }
    }

    stage('Test') {
      when { expression { return params.RefreshOnly == false } }

      steps {
        sh "du -hs $params.PACKER_BOX-${BOX_SUFFIX}.box"
        // sh "vagrant box add --force $params.PACKER_BOX-test $params.PACKER_BOX-${BOX_SUFFIX}.box"
        // sh "rm -f ./Vagrantfile"
        // sh "vagrant init $params.PACKER_BOX-test"
        // sh "vagrant up"
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