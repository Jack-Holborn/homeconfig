pipeline {
	agent {
		kubernetes {
			cloud 'kubernetes'
			inheritFrom 'kube-agent'
			instanceCap 1
			namespace 'devops-tools'
			serviceAccount 'jenkins-admin'
		}
	}
	stages {
		stage('Build') {
			steps {
				sh 'echo "Stage de build OK"'
			}
		}
		stage ('Test') {
			steps {
				sh 'echo "Stage de test OK"'
			}
		}
		stage ('Deploy') {
			when {
				branch 'production'
			}
			steps {
				sh 'echo "Stage de Deploiement OK"'
			}
		}
	}
}
