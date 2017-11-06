pipeline {
    agent any
    
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
        // LOOK: I'm not sure that this works.
        changed {
            // The 'when' directive is only supported within a 'stage' directive. Therefore,
            // to get conditional execution, we must resort to scripted pipeline code.
            // See https://jenkins.io/doc/book/pipeline/syntax/#when
            // See https://jenkins.io/doc/book/pipeline/syntax/#script
            script {
                if (currentBuild.result == 'SUCCESS') {
                    mail to: "cwardgar@ucar.edu",
                         subject: "Jenkins build is back to normal: ${currentBuild.fullDisplayName}",
                         body: "See <${currentBuild.absoluteUrl}>"
                }
            }
        }
        failure {
            mail to: "cwardgar@ucar.edu",
                 subject: "Build failed in Jenkins: ${currentBuild.fullDisplayName}",
                 body: "See <${currentBuild.absoluteUrl}>"
        }
    }
}
