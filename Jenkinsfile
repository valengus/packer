properties([disableConcurrentBuilds()])


pipeline {
  agent {label 'packer'}

  parameters {
    gitParameter (name: 'BRANCH', type: 'PT_BRANCH', defaultValue: 'origin/main')
    booleanParam (name: 'RefreshJFOnly', defaultValue: true, description: 'Read Jenkinsfile and exit.')

    choice (name: 'PACKER_PROVIDER', choices: ['qemu', 'virtualbox-iso', 'vmware-iso' ],  description: 'build provider')
    choice (name: 'PACKER_BOX', choices: ['windows10-22h2-x64', 'windows-2022-standard-core', 'windows-2022-standard' ],  description: 'os')

    string (name: 'CLOUD_TOKEN', defaultValue: '', description: 'token for vagrant cloud')
  }
    

  triggers {
      pollSCM 'H/5 *  * * *'
  }

  environment {
    CLOUD_TOKEN = "$params.CLOUD_TOKEN"
    TMPDIR = "/var/tmp"
  }

  stages {

    stage('Checkout') {
      steps {
        cleanWs()
        checkout([
          $class: 'GitSCM',
          doGenerateSubmoduleConfigurations: false,
          userRemoteConfigs: [[ url: "$env.GIT_URL" ]],
          branches: [ [name: "${params.BRANCH}"] ]
        ])
      }
    }


    stage('Info') {
      when { expression { return params.RefreshJFOnly == false } }

      steps {
        script {
          if (PACKER_PROVIDER == 'qemu') {
            BOX_SUFFIX = 'libvirt'
            env.VAGRANT_PROVIDER = 'libvirt'
          }
          else if (PACKER_PROVIDER == 'virtualbox-iso') { 
            BOX_SUFFIX = 'virtualbox' 
            env.VAGRANT_PROVIDER = 'virtualbox'
          }
          else if (PACKER_PROVIDER == 'vmware-iso') { 
            BOX_SUFFIX = 'vmware'
            env.VAGRANT_PROVIDER = 'vmware_desktop'
          }
          env.RELEASE_BOX = "$params.PACKER_BOX-${BOX_SUFFIX}.box"
        }
        echo "Git BRANCH is ${params.BRANCH}"
        echo "> box for $params.PACKER_PROVIDER provider"
        sh 'packer --version'
        sh 'vagrant --version'
        sh 'ansible --version'

      }
    }

    stage('Build') {
      when { expression { return params.RefreshJFOnly == false } }

      steps {
        echo "> building $params.PACKER_BOX "
        sh "packer build --force -only=windows'.'$params.PACKER_PROVIDER'.'$params.PACKER_BOX ./windows.pkr.hcl"
      }
    }


  }
}