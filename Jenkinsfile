pipeline {
    agent any
    parameters {
        booleanParam(name: 'PLAN_TERRAFORM', defaultValue: false, description: 'Check to plan Terraform changes')
        booleanParam(name: 'APPLY_TERRAFORM', defaultValue: false, description: 'Check to apply Terraform changes')
        booleanParam(name: 'DESTROY_TERRAFORM', defaultValue: false, description: 'Check to destroy Terraform changes')
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', changelog: false, poll: false, url: 'https://github.com/ShubhamBhavsar101/terraform-aws-ec2-project'
            }
        }
        stage('Terraform Init') {
            steps {
                withCredentials([[ $class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'shubh-aws-cred']]){
                    script {
                        ansiColor('xterm') {
                            sh 'terraform init'
                        }
                    }
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                script {
                    if (params.PLAN_TERRAFORM) {
                        withCredentials([[ $class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'shubh-aws-cred']]){
                            ansiColor('xterm') {
                                sh 'terraform plan'
                            }
                        }
                    }
                }
            }

        }
        stage('Terraform Apply') {
            steps {
                script {
                    if (params.APPLY_TERRAFORM) {
                        withCredentials([[ $class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'shubh-aws-cred']]){
                            ansiColor('xterm') {
                                sh 'terraform apply -auto-approve'
                            }
                        }
                    }
                }
            }
        }
        stage('Terraform Destroy') {
            steps {
                script {
                    if (params.DESTROY_TERRAFORM) {
                        withCredentials([[ $class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'shubh-aws-cred']]){
                            sh 'terraform destroy -auto-approve'
                        }
                    }
                }
            }
        }
    }
}
