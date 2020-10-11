pipeline {
  environment {
    registry = "prathap363/docker-test-training1"
    registryCredential = 'dockerhub-prathap363'
    dockerImage = ''
  }
  tools {
      // Install the Maven version configured as "M3" and add it to the path.
      maven "M363"
  }
  agent {
    docker {
        image 'maven:3-alpine'
        label 'docker-master'
        args  '-v /tmp:/tmp'
    }
  }
  stages {
   stage('parameterize'){
     steps {
           script{
          properties([parameters([string(defaultValue: 'MyLife', description: '', name: 'name', trim: false)])])
          }
         }
    }
    stage('Cloning Git') {
      steps {
        git credentialsId: 'Gothub-id', url: 'https://github.com/prathap363/jjpipelinetrigger.git'
      }
    }
    stage('Building code') {
      steps{
        script {
          sh "mvn -Dmaven.test.failure.ignore=true clean package"
          sh 'bin/makeindex' 
        }
      }
    }
    stage('Building image') {
      steps{
        script {
          sh "mvn -Dmaven.test.failure.ignore=true clean package"
          sh 'bin/makeindex' 
          dockerImage = docker.build registry + ":$BUILD_NUMBER"
        }
      }
    }

    stage('Building codebase') {
      when {
        branch 'production'
          anyOf {
              environment name: 'DEPLOY_TO', value: 'production'
              environment name: 'DEPLOY_TO', value: 'staging'
                }
            }
      
      steps{
        script {
         // sshPublisher(publishers: [sshPublisherDesc(configName: 'sshfordeploy', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: 'cd /home/cloud_user/test && ./script.sh', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '/home/cloud_user/test', remoteDirectorySDF: false, removePrefix: '', sourceFiles: 'index.jsp')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
          sshPublisher(publishers: [sshPublisherDesc(configName: 'sshfordeploy', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: 'cd /home/cloud_user/test && ./script.sh', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '/home/cloud_user/test', remoteDirectorySDF: false, removePrefix: '', sourceFiles: 'index.html')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])

        }
      }
    }
    stage('Deploy Image') {
      steps{
        script {
          docker.withRegistry( '', registryCredential ) {
            dockerImage.push()
          }
        }
      }
    }
    stage('Remove Unused docker image') {
      steps{
        sh "docker rmi $registry:$BUILD_NUMBER"
      }
    }
  }
}
