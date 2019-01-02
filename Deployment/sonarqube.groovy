
pipeline {

    agent any

    options {
        buildDiscarder(
            logRotator(
                numToKeepStr: '5',
                daysToKeepStr: '30',
                artifactDaysToKeepStr: '30',
                artifactNumToKeepStr: '3'
            )
        )
        disableConcurrentBuilds()
        timeout(time: 60, unit: 'MINUTES')
    }
	
	   parameters {
        string(name: 'GitCred', description: 'Jenkins-stored Git credential with which to execute git commands')
        string(name: 'GitProjUrl', description: 'SSH URL from which to download the Jenkins git project')
        string(name: 'GitProjBranch', description: 'Project-branch to use from the Jenkins git project')
    }


    stages {
        stage ('Prepare Instance Environment') {
            steps {
                deleteDir()
                git branch: "${GitProjBranch}",
                    credentialsId: "${GitCred}",
                    url: "${GitProjUrl}"
			}
		}
		stage('Sonarqube') {
			environment {
				scannerHome = tool 'sonar-scanner'
			}
			steps {
				withSonarQubeEnv('Sonar') {
					sh "${scannerHome}/bin/sonar-scanner"
				}
			}
		}
	}
}