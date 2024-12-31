pipeline {
    agent any

    environment {
        // Docker image name (replace 'ayoubbale/simple-java-app' with your details)
        DOCKER_IMAGE = 'ayoubbale/simple-java-app'
        // Docker Hub credentials (replace with your actual credentials ID in Jenkins)
        DOCKER_CREDENTIALS_ID = '8e05ab4c-bbb6-4c95-8140-c3b40569e8d1'
    }

    stages {
        stage('Clone Repository') {
            steps {
                // Cloning your GitHub repository
                git 'https://github.com/Bo-Ayoub/simple-java-maven-project.git'
            }
        }

        stage('Install Maven') {
            steps {
                script {
                    // Install Maven if it is not already available
                    sh '''
                    if ! [ -x "$(command -v mvn)" ]; then
                        echo "Maven is not installed. Installing Maven..."
                        sudo apt update
                        sudo apt install -y maven
                    else
                        echo "Maven is already installed."
                    fi
                    '''
                }
            }
        }

        stage('Build and Test') {
            steps {
                script {
                    // Build and run tests using Maven
                    sh 'mvn clean install'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image
                    sh 'docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} .'
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    // Login to Docker Hub using credentials stored in Jenkins
                    withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS_ID}", usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                    }

                    // Push Docker image to Docker Hub
                    sh 'docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}'
                }
            }
        }

        stage('Deploy Dockerized Project') {
            steps {
                script {
                    // Pull the Docker image from Docker Hub
                    sh 'docker pull ${DOCKER_IMAGE}:${BUILD_NUMBER}'

                    // Stop any running container with the same name
                    sh 'docker stop mycontainer || true'

                    // Remove the container if exists
                    sh 'docker rm mycontainer || true'

                    // Run the Docker container
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
