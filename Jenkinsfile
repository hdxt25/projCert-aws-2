pipeline {
    agent {
        dockerfile {
            filename 'agent/Dockerfile'   // Path to your Dockerfile
            dir './agent'                 // Directory containing Dockerfile
            args '--name test-server' 
            args '-v /var/run/docker.sock:/var/run/docker.sock'         // optional: Jenkins node label with Docker installed
        }
    }

    stages {
        stage('Install Puppet Agent on Slave(Job 1)') {
            steps {
                    sshagent(['test-server-ssh']) {
                        sh 'ansible-playbook -i inventory ./ansible/install-puppet.yml --connection=docker'
                    }
            }        
        }

        stage('Install Docker with Ansible (Job 2)') {
            steps {
                sshagent(['test-server-ssh']) {
                    sh 'ansible-playbook -i inventory ./ansible/install-docker.yml --connection=docker'
                }
            }
        }    

        stage('Build and Push Docker Image') {
            environment {
                DOCKER_IMAGE = "hdxt25/php-website:${BUILD_NUMBER}"
                DOCKER_CONTAINER = "php-container"
            }
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-cred', 
                                             usernameVariable: 'DOCKER_USER', 
                                             passwordVariable: 'DOCKER_PASS')]) {
                        sh """
                            # Login to Docker Hub
                            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin

                            # Build the Docker image
                            docker build -t ${DOCKER_IMAGE} .

                            # Push the Docker image
                            docker run -d --name ${DOCKER_CONTAINER} -p 8081:80 ${DOCKER_IMAGE}

                            # Logout for security
                            docker logout
                        """
                    }
                }        
            }
        }
    }
    
    post {
        failure {
            echo 'Job 3 failed. Cleaning up container on test server...'
                sh """
                    docker rm -f $DOCKER_CONTAINER || true
                """
        }
    }
}
