# Steps to Perform before running Jenkins pipeline

1. Install the AWS Credentials plugin and create credential for access keys in Jenkins
2. Create a hosted zone on aws and register the namespaces created in your hosted_zone on your domain registrar like hostinger.
3. Run Terraform Plan - Checkbox
4. Run Terraform Apply - Checkbox
5. The domain will be live on the internet with HTTPS secure connection.

# Handling Errors

1. 502 Bad Gateway
<img width="1459" height="643" alt="Screenshot 2026-01-05 at 12 07 27 PM" src="https://github.com/user-attachments/assets/4920f984-4fbd-4e9d-a125-a8fd33420ddb" />

This error is mainly due to instances not being healthy. So check in Load Balancer if any instances are not healthy. This could be due to heath check configured on wrong port.
