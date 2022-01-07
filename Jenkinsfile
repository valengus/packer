def my_choices_list = []

node('master') {
   stage('prepare choices') {
       // read the folder contents
       def my_choices = sh script: "ls -1 /var", returnStdout:true
       // make a list out of it - I haven't tested this!
       my_choices_list = my_choices.trim().split("\n")
   }
}

pipeline {
  agent {label 'packer'}

  parameters {
    // choice (name: 'OPTION', choices: [my_choices_list])
    choice(name: 'OPTION', choices: my_choices_list)
    gitParameter (name: 'BRANCH', type: 'PT_BRANCH', defaultValue: 'origin/main')
    booleanParam (name: 'RefreshOnly', defaultValue: true, description: 'Read Jenkinsfile and exit.')
    choice (name: 'PACKER_PROVIDER', choices: ['qemu', 'virtualbox-iso', 'vmware-iso' ],  description: 'build provider')
    choice (name: 'PACKER_BOX', choices: ['windows-11-pro', 'windows-2019' ],  description: 'os')
    string (name: 'CLOUD_TOKEN', defaultValue: '', description: 'token for vagrant cloud')
  }

  triggers {
      pollSCM 'H/5 *  * * *'
  }

  environment {
    CLOUD_TOKEN = "$params.CLOUD_TOKEN"
  }

  stages {

    stage('Checkout') {
      steps {
        // cleanWs()
        checkout([
          $class: 'GitSCM',
          doGenerateSubmoduleConfigurations: false,
          userRemoteConfigs: [[ url: 'https://github.com/valengus/packer.git' ]],
          branches: [ [name: "${params.BRANCH}"] ]
        ])
      }
    }

    stage('Prepare') {
      when { expression { return params.RefreshOnly == false } }

      steps {
        script {
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
        sh 'vagrant destroy -f || true'
        sh "rm -f ./Vagrantfile"
        sh "vagrant box remove $params.PACKER_BOX-test || true"
        sh "sudo find /var/lib/libvirt/images | grep -P \"$params.PACKER_BOX-test.*box.img\"  | xargs -d\"\\n\" sudo rm || true"
      }
    }

    stage('Info') {
      when { expression { return params.RefreshOnly == false } }

      steps {
        echo "Git BRANCH is ${params.BRANCH}"
        echo "> building box for $params.PACKER_PROVIDER provider"
        sh 'packer --version'
        sh 'vagrant --version'
        sh 'ansible --version'
      }
    }

    stage('Build') {
      when { expression { return params.RefreshOnly == false } }
      
      steps {
        echo "Building $params.PACKER_BOX "
        sh "packer build --force -only=$params.PACKER_PROVIDER'.'$params.PACKER_BOX -except=vagrant-cloud  build_$params.PACKER_BOX'.'pkr.hcl"
      }
    }

    stage('Test') {
      when { expression { return params.RefreshOnly == false } }

      steps {
        // sh 'virsh pool-refresh default'
        sh "vagrant box add --force $params.PACKER_BOX-test $params.PACKER_BOX-${BOX_SUFFIX}.box"
        sh "vagrant init $params.PACKER_BOX-test"
        sh "vagrant up --provider=${env.VAGRANT_DEFAULT_PROVIDER}"
        sh "sleep 300"
        sh "vagrant status"
      }

    }

    stage('Release') {
      when { expression { return params.RefreshOnly == false } }
      steps {
          // script {
          //   env.RELEASE_BOX = "$params.PACKER_BOX-${BOX_SUFFIX}.box"
          // }
          echo "Release $params.PACKER_BOX-${BOX_SUFFIX}.box"
          sh "RELEASE_BOX=$params.PACKER_BOX-${BOX_SUFFIX}.box ; echo \$RELEASE_BOX"
          // sh "du -hs $params.PACKER_BOX-${BOX_SUFFIX}.box"
          // sh "RELEASE_BOX=$params.PACKER_BOX-${BOX_SUFFIX}.box ; packer build --force release_$params.PACKER_BOX'.'pkr.hcl"
      }
    }

    stage('Cleanup') {
      when { expression { return params.RefreshOnly == false } }
      steps {
        echo 'cleanup'
        sh 'vagrant destroy -f'
        sh "vagrant box remove $params.PACKER_BOX-test || true"
        sh "sudo find /var/lib/libvirt/images | grep -P \"$params.PACKER_BOX-test.*box.img\"  | xargs -d\"\\n\" sudo rm || true"
        sh "rm -f ./Vagrantfile"
      }
    }

  }
}