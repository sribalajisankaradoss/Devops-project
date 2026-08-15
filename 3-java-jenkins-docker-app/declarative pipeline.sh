pipeline {
    agent {
        label 'Slave1'
    }

    stages {

        stage('Pull the code & move to correct dir') {
            steps {
                sh '''
                    rm -rf Devops-project
                    git clone https://github.com/sribalajisankaradoss/Devops-project.git
                    cd Devops-project/3-java-jenkins-docker-app

                    echo "Current directory:"
                    pwd

                    echo "Files:"
                    ls -la
                '''
            }
        }

        stage('Maven Install & Build') {
            steps {
                dir('Devops-project/3-java-jenkins-docker-app') {
                    sh '''
                        echo "Checking Maven installation..."

                        if command -v mvn >/dev/null 2>&1; then
                            echo "Maven is already installed."
                        else
                            echo "Maven is not installed. Installing Maven..."

                            sudo apt-get update
                            sudo apt-get install -y maven
                        fi

                        echo "Maven version:"
                        mvn --version

                        echo "Building Java application..."
                        mvn clean package
                    '''
                }
            }
        }

        stage('Docker Build') {
            steps {
                dir('Devops-project/3-java-jenkins-docker-app') {
                    sh '''
                        echo "Building Docker image..."
                        docker build -t java-jenkins-docker:latest .
                    '''
                }
            }
        }

        stage('Docker Run') {
            steps {
                dir('Devops-project/3-java-jenkins-docker-app') {
                    sh '''
                        echo "Starting Docker container..."
                        docker run --rm -d -p 8080:8080 java-jenkins-docker:latest
                    '''
                }
            }
        }
    }
}