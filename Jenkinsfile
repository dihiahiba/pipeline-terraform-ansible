pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('jenkins-aws') // Utilise l'ID du credential
        AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws') // L'ID de credential est utilisé pour les deux clés
        SSH_KEY               = '/home/jenkins/.ssh/mariam-key.pem'   // Chemin de la clé SSH privée
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
                    
                    // Ajouter l'IP publique au fichier d'inventaire Ansible
                    writeFile(file: 'hosts.ini', text: """
                        [ec2]
                        ${public_ip}

                        [ec2:vars]
                        ansible_user=ubuntu
                        ansible_ssh_private_key_file=${env.SSH_KEY}
                    """, append: true) // Ajouter à la fin du fichier
                }
            }
        }

        stage('Ansible Setup') {
            steps {
                script {
                    // Lire l'IP publique de l'instance
                    def public_ip = readFile('hosts.ini').trim()

                    // Exécuter le playbook Ansible pour configurer l'instance
                    sh '''
                    ansible-playbook -i hosts.ini playbook.yml
                    '''
                }
            }
        }
    }
}
