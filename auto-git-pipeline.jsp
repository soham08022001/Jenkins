pipeline {
    agent any
    stages {
        stage('Pull') {
            steps {
                git 'https://github.com/soham08022001/studentapp-ui.git'
            }
        }
        stage('Build') {
            steps { 
                 sh '/opt/maven/bin/mvn clean package '
            }
        }
        stage('Test') {
            steps {
                withSonarQubeEnv(installationName: 'sonarqube', credentialsId: 'sonar-creds') {
                sh '/opt/maven/bin/mvn sonar:sonar'
                }
            }
        }
        stage('Deploy') {
            steps {
                deploy adapters: [tomcat9(credentialsId: 'tomcat-creds', path: '', url: 'http://172.31.6.187:8080')], contextPath: '/', war: '**/*.war'
            }
        }
    }
}