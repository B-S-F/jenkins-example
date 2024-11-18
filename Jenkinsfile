pipeline {
    agent any
    stages {
        stage('RUN') {
            environment {
                HOME = "${env.WORKSPACE}"
                YAKU_API_TOKEN = credentials('yaku-token')
                YAKU_ENV_URL = "http://core-api-yaku.yaku.svc.cluster.local/api/v1"
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
        stage('Deploy') {
            steps {
                echo 'Deploying...'
                // Add deploy commands here, e.g., sh 'scp target/*.jar user@server:/path/to/deploy'
            }
        }
    }
}
