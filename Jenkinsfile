pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('jenkins-aws') // Utilise l'ID du credential AWS
        AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws') // Utilise l'ID du credential AWS
        SSH_KEY = '/home/jenkins/.ssh/mariam-key.pem' // Chemin de la clé privée SSH
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
                    cd Terraform
                    terraform output -raw instance_public_ip
                    ''', returnStdout: true).trim()

                    // Créer le fichier d'inventaire Ansible
                    writeFile file: 'hosts.ini', text: """
                    [ec2]
                    ${public_ip}

                    [ec2:vars]
                    ansible_user=ubuntu
                    ansible_ssh_private_key_file=${env.SSH_KEY}
                    """
                }
            }
        }

        stage('Ansible Setup') {
            steps {
                script {
                    // Exécuter le playbook Ansible pour configurer l'instance
                    sh '''
                    cd Ansible
                    ansible-playbook -i ../hosts.ini playbook.yml
                    '''
                }
            }
        }
    }
}
