pipeline {
    agent {
        dockerfile {
            filename 'agent/Dockerfile'
            dir './agent'
            args '--name test-server -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    environment {
        DOCKER_IMAGE = "hdxt25/php-website:${BUILD_NUMBER}"
        DOCKER_CONTAINER = "php-container"
    }

    stages {
        stage('Install Puppet Agent') {
            steps {
                sh 'ansible-playbook -i inventory ./ansible/install-puppet.yml --connection=docker'
            }        
        }

        stage('Install Docker with Ansible') {
            steps {
                sh 'ansible-playbook -i inventory ./ansible/install-docker.yml --connection=docker'
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
        }
    }

    post {
        failure {
            echo 'Build failed. Cleaning up container...'
            sh 'docker rm -f ${DOCKER_CONTAINER} || true'
        }
    }
}
