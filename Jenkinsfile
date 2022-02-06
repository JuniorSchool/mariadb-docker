pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building..'
				sh 'docker build -t hammadrauf/mariadb .'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
				sh 'docker push hammadrauf/mariadb'
            }
        }
    }
}
