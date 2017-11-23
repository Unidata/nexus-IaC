#!/usr/bin/env groovy

def buildStateHasChanged = false

pipeline {
    agent {
        label 'jenkins-slaves-t2small'  // Run pipeline on a t2.small slave.
    }
    
    options {
        skipDefaultCheckout()  // The default checkout doesn't init submodules.
    }
    
    stages {
        stage('Clone sources') {
            steps {
                // Need to jump through some extra hoops because of the submodules.
                // See https://stackoverflow.com/questions/42290133.
                checkout([$class: 'GitSCM',
                          branches: [[name: '*/master']],
                          doGenerateSubmoduleConfigurations: false,
                          extensions: [[$class: 'SubmoduleOption',
                                        disableSubmodules: false,
                                        parentCredentials: false,
                                        recursiveSubmodules: true,
                                        reference: '',
                                        trackingSubmodules: false]],
                          submoduleCfg: [],
                          userRemoteConfigs: [[url: 'https://github.com/cwardgar/nexus-IaC.git']]
                ])
            }
        }
    
        stage('Test in Docker') {
            steps {
                withCredentials([string(credentialsId: 'nexus-iac-vault-password', variable: 'VAULT_PASSWORD')]) {
                    ansiColor('xterm') {
                        sh "$WORKSPACE/scripts/test_in_docker.sh"
                    }
                }
            }
        }
        
        stage('Prepare and configure tools') {
            steps {
                withCredentials([string(credentialsId: 'nexus-iac-vault-password', variable: 'VAULT_PASSWORD')]) {
                    ansiColor('xterm') {
                        sh "$WORKSPACE/scripts/prepare_tools.sh"
                    }
                }
            }
        }
        
        stage('Create Nexus image') {
            steps {
                withCredentials([string(credentialsId: 'nexus-iac-vault-password', variable: 'VAULT_PASSWORD')]) {
                    sh "$WORKSPACE/scripts/create_image.sh"
                }
            }
        }
        
        stage('Reprovision production server') {
            steps {
                ansiColor('xterm') {
                    sh "$WORKSPACE/scripts/provision_prod.sh"
                }
            }
        }
    
        stage('Delete old images') {
            steps {
                sh "$WORKSPACE/scripts/delete_old_images.sh"
            }
        }
    }
    
    post {
        always {
            deleteDir()
        }
        
        // Only send email on failure or when a previously-failing build succeeds. See https://goo.gl/6T2DQb.
        
        success {
            // The 'when' directive is only supported within a 'stage' directive. Therefore,
            // to get conditional execution, we must resort to scripted pipeline code.
            // See https://jenkins.io/doc/book/pipeline/syntax/#when
            // See https://jenkins.io/doc/book/pipeline/syntax/#script
            script {
                if (buildStateHasChanged == true) {
                    mail to: "cwardgar@ucar.edu",
                         subject: "Jenkins build is back to normal: ${currentBuild.fullDisplayName}",
                         body: "See <${currentBuild.absoluteUrl}>"
                }
            }
        }
        
        // Apparently, if a previously-failing build succeeds, the 'changed' closure will be invoked before
        // the 'success' closure. Thus, 'success' will see the updated value of 'buildStateHasChanged'.
        // See https://goo.gl/6T2DQb.
        changed {
            script {
                // There is a variable -- ${currentBuild.result} -- that one would expect to be suitable for this
                // purpose. However, that variable is never set during the pipeline. See https://goo.gl/6T2DQb.
                buildStateHasChanged = true
            }
        }
        
        failure {
            mail to: "cwardgar@ucar.edu",
                 subject: "Build failed in Jenkins: ${currentBuild.fullDisplayName}",
                 body: "See <${currentBuild.absoluteUrl}>"
        }
    }
}
