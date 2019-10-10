pipeline {
    agent { label 'docker' }
    options {
        buildDiscarder(logRotator(numToKeepStr: '5', daysToKeepStr: '30'))
        timestamps()
    }
    environment {
        SCANNERS            = 'protex'
        PROJECT_NAME        = 'Inventory-Suite-Installer'
        PROTEX_PROJECT_NAME = 'bb-inventory-suite-installer'

        SLACK_SUCCESS = '#ima-build-success'
        SLACK_FAIL    = '#ima-build-failed'
    }
    stages {
        stage('Static Code Analysis') {
            steps {
                rbheStaticCodeScan()
            }
        }
    }
    post {
        failure {
            slackBuildNotify([failed: true, slackFailureChannel: env.SLACK_FAIL]) {}
        }
        success {
            slackBuildNotify([slackSuccessChannel: env.SLACK_SUCCESS]) {}
        }
    }
}
