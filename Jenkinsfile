pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('jenkins-aws') // Utilise l'ID du credential AWS
        AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws') // L'ID de credential est utilisé pour les deux clés
        SSH_KEY = '/home/jenkins/.ssh/mariam-key.pem'   // Chemin de la clé SSH privée pour l'accès à l'instance EC2
    }

    stages {
        stage('Terraform Init') {
            steps {
                script {
                    // Initialiser Terraform dans le répertoire Terraform
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
                    // Appliquer la configuration Terraform et créer l'instance EC2
                    sh '''
                    cd Terraform
                    terraform apply -auto-approve
                    '''
                    
            
            // Récupérer l'adresse IP publique de l'instance EC2
            def public_ip = sh(script: '''
            terraform output -raw instance_public_ip
            ''', returnStdout: true).trim()

            // Créer le fichier d'inventaire avec le bon format
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
                    // Exécuter le playbook Ansible pour configurer l'instance EC2 avec Apache, PHP, et l'application PHP
                    sh '''
                    cd Ansible
                    ansible-playbook -i ../hosts.ini playbook.yml
                    '''
                }
            }
        }
    }
}
