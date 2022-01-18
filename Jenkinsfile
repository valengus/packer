pipeline {
  agent {label 'packer'}

  parameters {
    gitParameter (name: 'BRANCH', type: 'PT_BRANCH', defaultValue: 'origin/main')
    booleanParam (name: 'RefreshOnly', defaultValue: true, description: 'Read Jenkinsfile and exit.')
    choice (name: 'PACKER_PROVIDER', choices: ['qemu', 'virtualbox-iso', 'vmware-iso' ],  description: 'build provider')
    choice (name: 'PACKER_BOX', choices: ['windows-11-pro', 'windows-2019', 'windows-2022' ],  description: 'os')
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
          userRemoteConfigs: [[ url: 'https://github.com/valengus/packer.git' ]],
          branches: [ [name: "${params.BRANCH}"] ]
        ])
      }
    }

    stage('PreCleanup') {
      when { expression { return params.RefreshOnly == false } }

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
        sh 'vagrant destroy -f || true'
        sh 'rm -f ./Vagrantfile'
        sh "vagrant box remove $params.PACKER_BOX-test || true"
        sh "sudo find /var/lib/libvirt/images | grep -P \"$params.PACKER_BOX-test.*box.img\"  | xargs -d\"\\n\" sudo rm || true"
      }
    }

    stage('Info') {
      when { expression { return params.RefreshOnly == false } }

      steps {
        echo "Git BRANCH is ${params.BRANCH}"
        echo "> box for $params.PACKER_PROVIDER provider"
        sh 'packer --version'
        sh 'vagrant --version'
        sh 'ansible --version'

      }
    }

    stage('Build') {
      when { expression { return params.RefreshOnly == false } }
      steps {
        echo "> building $params.PACKER_BOX "
        sh "packer build --force -only=$params.PACKER_PROVIDER'.'$params.PACKER_BOX -except=vagrant-cloud  build_$params.PACKER_BOX'.'pkr.hcl"
      }
    }

    stage('Test') {
      when { expression { return params.RefreshOnly == false } }

      steps {
        echo "> Test"
        sh "vagrant box add --force $params.PACKER_BOX-test $params.PACKER_BOX-${BOX_SUFFIX}.box"
        sh "vagrant init $params.PACKER_BOX-test"
        sh "vagrant up --provider=${env.VAGRANT_PROVIDER}"
        sh "sleep 300"
        sh "vagrant status"
      }

    }

    stage('Release') {
      when { expression { return params.RefreshOnly == false } }
      steps {
          sh "du -hs $params.PACKER_BOX-${BOX_SUFFIX}.box"
          sh "packer build --force -only=null.release build_$params.PACKER_BOX'.'pkr.hcl"
      }
    }

    stage('Cleanup') {
      when { expression { return params.RefreshOnly == false } }
      steps {
        echo 'cleanup'
        sh 'vagrant destroy -f'
        sh "vagrant box remove $params.PACKER_BOX-test || true"
        sh "sudo find /var/lib/libvirt/images | grep -P \"$params.PACKER_BOX-test.*box.img\"  | xargs -d\"\\n\" sudo rm || true"
      }
    }

  }
}