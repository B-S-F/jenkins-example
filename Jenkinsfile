pipeline {
    agent any
    stages {
        stage('RUN') {
            environment {
                HOME = "${env.WORKSPACE}"
                YAKU_API_TOKEN = credentials('yaku-token')
                YAKU_ENV_URL = "http://xx/api/v1"
                CONFIG_ID = "23"
                RELEASE_ID = "321"
                NAMESPACE_ID = "164"
            }
            steps {
                sh(
                    script: "./yaku_run.sh",
                    label: 'Run Yaku'
                )
            }
        }
        stage('Release approved') {
            when {
                expression { 
                    fileExists('.release_status') && readFile('.release_status').trim() == "pending"
                }
            }
            steps {
                sh 'echo "Release has been approved"'
            }
        }
    }
}
