pipeline {
    agent any

    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "M363"

    }

    stages {
        
        stage('parameterize'){
        steps {
                 script{
                properties([parameters([string(defaultValue: 'MyLife', description: '', name: 'name', trim: false)])])
                }
              }
        }
        stage('Build') {
            steps {

                git credentialsId: 'Gothub-id', url: 'https://github.com/prathap363/jjpipelinetrigger.git'
                sh "mvn -Dmaven.test.failure.ignore=true clean package"
                sh 'bin/makeindex'

            }

            post {
                // If Maven was able to run the tests, even if some of the test
                // failed, record the test results and archive the jar file.

                success {
                    
                //    junit '**/target/surefire-reports/TEST-*.xml'
                    archiveArtifacts 'index.jsp'
                }
            }
        }
        
        
        stage('Deploy'){
        steps([$class: 'BapSshPromotionPublisherPlugin']) {
            sshPublisher(
                continueOnError: false, failOnError: true,
                publishers: [
                    sshPublisherDesc(
                        configName: "sshfordeploy",
                        verbose: true,
                        transfers: [
                            sshTransfer(
                                sourceFiles: "index.jsp",
                                remoteDirectory:"/home/cloud_user/test" ,
                                execCommand:"cd /home/cloud_user/test/ && ./script.sh" ,
                                )
                        ]
                    )
                ]
            )
        }    
        }

    }
}
