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
                sh '''
                    releaseStatus=$(cat release_status.txt)
                    echo $releaseStatus
                '''
            }
        }
        stage('Release approved') {
            when {
                expression { releaseStatus == "pending" }
            }
            steps {
                sh 'echo "Release has been approved"'
            }
        }
    }
}
