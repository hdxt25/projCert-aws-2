pipeline {
    agent {
        dockerfile {
            filename 'Dockerfile'
            dir './agent'
            args '--name test-server -u root:root -v /var/run/docker.sock:/var/run/docker.sock'
            reuseNode true
        }
    }

    environment {
        DOCKER_IMAGE = "hdxt25/php-website:${BUILD_NUMBER}"
        DOCKER_CONTAINER = "php-container"
    }

    stages {  
        stage('Install Puppet Agent') {
            steps {
                
                sh 'ansible-playbook -i inventory ./ansible/install-puppet.yml --connection=local --become'
            }        
        }

        stage('Install Docker with Ansible') {
            steps {
                sh 'ansible-playbook -i inventory ./ansible/install-docker.yml --connection=local --become'
            }
        }
        stage('Check versions of all installed software in test-server') {
            steps {
                sh '''
                    echo "==== Software Versions on Test Server ===="
            
                    echo "SSH version:"
                    ssh -V || echo "SSH not installed"
            
                    echo "Python version:"
                    python3 --version || echo "Python not installed"
            
                    echo "Git version:"
                    git --version || echo "Git not installed"
            
                    echo "Puppet version:"
                    puppet --version || echo "Puppet not installed"
            
                    echo "Ansible version:"
                    ansible --version || echo "Ansible not installed"
            
                    echo "Docker version:"
                    docker --version || echo "Docker not installed"
            
                    echo "Docker Image Name: ${DOCKER_IMAGE}"
                    echo "Docker Container Name: ${DOCKER_CONTAINER}"
            
                    echo "========================================="
                '''
            }
        }

        stage('Build and Run Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-cred', 
                                             usernameVariable: 'DOCKER_USER', 
                                             passwordVariable: 'DOCKER_PASS')]) {
                        sh """
                            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                            docker build -t ${DOCKER_IMAGE} .
                            docker run -d --name ${DOCKER_CONTAINER} -p 8081:80 ${DOCKER_IMAGE}
                            docker push ${DOCKER_IMAGE}
                            docker logout
                        """
                    }
                }        
            }
            post {
                failure {
                    echo 'Build failed. Cleaning up container...'
                    script {
                        sh 'docker rm -f ${DOCKER_CONTAINER} || true'
                    }
                }
            }
        }
    }
}

