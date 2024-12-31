pipeline {
    agent {
        docker {
            image 'maven:3.8.7-openjdk-17' // Maven Docker image with OpenJDK 17
        }
    }

    environment {
        DOCKER_IMAGE = 'ayoubbale/simple-java-app'
        DOCKER_CREDENTIALS_ID = '8e05ab4c-bbb6-4c95-8140-c3b40569e8d1'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/Bo-Ayoub/simple-java-maven-project.git'
            }
        }

        stage('Build and Test') {
            steps {
                script {
                    sh 'mvn clean install'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} .'
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS_ID}", usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                    }
                    sh 'docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}'
                }
            }
        }

        stage('Deploy Dockerized Project') {
            steps {
                script {
                    sh 'docker pull ${DOCKER_IMAGE}:${BUILD_NUMBER}'
                    sh 'docker stop mycontainer || true'
                    sh 'docker rm mycontainer || true'
                    sh 'docker run -d --name mycontainer ${DOCKER_IMAGE}:${BUILD_NUMBER}'
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline finished successfully.'
        }

        failure {
            echo 'Pipeline failed.'
        }
    }
}
