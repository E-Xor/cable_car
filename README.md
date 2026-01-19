## Run

./bin/dev # launches rails s and tailwind, see Procfile.dev

## How to Create Users via Rails Console

```bash
rails c
```

```ruby
# Create a new user
user = User.create!(
  email_address: "user@example.com",
  password: "password123",
  password_confirmation: "password123"
)

# Update password
user.update!(password: "newpassword123", password_confirmation: "newpassword123")

# Delete a user
user.destroy

# Delete all sessions for a user (force logout)
user.sessions.destroy_all
```

## Local credentials

admin@example.com
`adminadmin`

## Timer via ActionCable

In the top-right corner of the /chats page

```
rails timer:broadcast
```

## Deployment

### Edit Rails Credentials

```bash
EDITOR=vim rails credentials:edit
```

### AWS Setup

#### 1. Create ECR Repository

```bash
aws ecr create-repository --repository-name cable_car --region us-east-1
```

Note your AWS Account ID from the output (or run `aws sts get-caller-identity --query Account --output text`).

#### 2. Launch EC2 Instance

- **AMI**: Ubuntu 22.04 LTS (or Amazon Linux 2023)
- **Instance type**: t3.small or larger
- **Security Group** - allow inbound:
  - Port 22 (SSH) from your IP
  - Port 80 (HTTP) from anywhere
  - Port 443 (HTTPS) from anywhere
- **Key pair**: Create or use existing for SSH access

After launch, note the **Public IPv4 address**.

#### 3. Configure DNS

Point your domain to the EC2 instance:

| Record Type | Name | Value |
|-------------|------|-------|
| A | @ | YOUR_EC2_PUBLIC_IP |

Wait for DNS propagation before deploying (check with `dig cablecar.click`).

#### 4. Install Docker on EC2

SSH into your instance and run:

```bash
sudo apt update && sudo apt install -y docker.io
sudo usermod -aG docker ubuntu
# Log out and back in, or run: newgrp docker
```

#### 5. S3 Bucket & CDN

Ensure bucket `rails-8` exists in `us-east-1` (or update `AWS_BUCKET` in deploy.yml).
Bucket policy should allow your IAM user to read/write.

Create a CloudFront distribution
Origin: Your EC2 domain or YOUR_DOMAIN.com
Origin path: /assets
Copy the CloudFront domain (e.g., d1234abcd.cloudfront.net)

### Configure Kamal

Update `config/deploy.yml`:

| Placeholder | Replace With |
|-------------|--------------|
| `YOUR_EC2_PUBLIC_IP` | Your EC2 public IP (e.g., `54.123.45.67`) |
| `AWS_ACCOUNT_ID` | Your 12-digit AWS account ID |

### Environment Variables

Export before deploying:

```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
```

### Deploy

```bash
# First-time setup
bin/kamal setup

# Subsequent deploys
bin/kamal deploy
```

Access your app at `https://cablecar.click`
