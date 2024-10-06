pipeline {
    agent any
    environment {
        // Chemin vers la clé SSH
        SSH_KEY               = '~/.ssh/mariam-key.pem'   // Chemin de la clé SSH privée
    }
    stages {
        stage('Terraform Init') {
            steps {
                script {
                    // Initialiser Terraform
                    sh '''
                    cd Terraform
                    terraform init
                    '''
                }
            }
        }
        
        stage('Terraform Apply') {
            steps {
                script {
                    // Appliquer la configuration Terraform et créer l'instance
                    sh '''
                    cd Terraform
                    terraform apply -auto-approve
                    '''
                    
                    // Récupérer l'adresse IP publique de l'instance EC2
                    def public_ip = sh(script: '''
                    terraform output -raw instance_public_ip
                    ''', returnStdout: true).trim()
                    
                    // Écrire l'IP publique dans un fichier pour l'utiliser avec Ansible
                    writeFile(file: 'public_ip.txt', text: public_ip)
                }
            }
        }

        stage('Ansible Setup') {
            steps {
                script {
                    // Lire l'IP publique de l'instance
                    def public_ip = readFile('public_ip.txt').trim()

                    // Créer le fichier d'inventaire Ansible pour l'instance EC2
                    writeFile(file: 'hosts.ini', text: """
                        [ec2]
                        ${public_ip}

                        [ec2:vars]
                        ansible_user=ubuntu
                        ansible_ssh_private_key_file=${env.SSH_KEY}
                    """)

                    // Exécuter le playbook Ansible pour configurer l'instance
                    sh '''
                    ansible-playbook -i hosts.ini playbook.yml
                    '''
                }
            }
        }
    }
}
