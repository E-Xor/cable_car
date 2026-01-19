## Run

./bin/dev # launches rails s and tailwind, see Procfile.dev

## Create a User via Rails Console

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

## Edit Rails Credentials

```bash
EDITOR=vim rails credentials:edit
```

## Deployment

### Create ECR Repository

- rails_8/cable_car
- 029212082144.dkr.ecr.us-east-1.amazonaws.com/rails_8/cable_car
- Specify `image: rails_8/cable_car` in deploy.yml

### Launch EC2 Instance

- **AMI**: Ubuntu 24.04 LTS (HVM)
- 64-bit (x-86)
- **Instance type**: t3.small, 2 vCPU, 2GB RAM
- **Key pair**: cable_car_key.pem
- **Security Group** - allow inbound:
  - Port 22 (SSH) from your IP
  - Port 80 (HTTP) from anywhere
  - Port 443 (HTTPS) from anywhere
- **Storage** - 30GB, gp3

After launch, note the **Public IPv4 address**.

Point your domain to the EC2 instance:

| Record Type | Name | Value              |
|-------------|------|--------------------|
| A           | @    | YOUR_EC2_PUBLIC_IP |

Wait for DNS propagation before deploying (check with `dig cablecar.click`).

#### 4. Install Docker on EC2

SSH into your instance
```bash
chmod 400 ~/Documents/Personal\ Projects/rails_8/cable_car_key.pem
ssh -i ~/Documents/Personal\ Projects/rails_8/cable_car_key.pem ubuntu@44.192.49.202
```

Run:
```bash
sudo apt update && sudo apt install -y docker.io
sudo usermod -aG docker ubuntu
```

Log out and back in, or run:
```bash
newgrp docker
```

### S3 Bucket & CDN

Create `cable-car-assets` bucket (cable-car-assets.s3.us-east-1.amazonaws.com), update it in storage.yml and update `AWS_BUCKET` in deploy.yml.
Bucket policy should allow your IAM user to read/write.

Create a CloudFront distribution
Origin: Your EC2 domain or YOUR_DOMAIN.com
Origin path: /assets
Copy the CloudFront domain, dy3w5ttukbq3c.cloudfront.net, specify `CDN_HOST: dy3w5ttukbq3c.cloudfront.net` in deploy.yml.

AWS also created an SSL Cert for the distribution in ACM, arn:aws:acm:us-east-1:029212082144:certificate/124d0681-60b5-4028-908a-e8be1328cc73

### Variables

Update `config/deploy.yml`:

| Placeholder          | Replace With                 |
|----------------------|------------------------------|
| `YOUR_EC2_PUBLIC_IP` | Actual IP                    |
| `AWS_ACCOUNT_ID`     | Your 12-digit AWS account ID |


```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
```

Check that you access the right account
```
aws sts get-caller-identity --query Account --output text
# 029212082144
```

### Local Docker setup for Kamal

```bash
brew install --cask docker
brew install docker-buildx
mkdir -p ~/.docker/cli-plugins
ln -sfn $(brew --prefix)/opt/docker-buildx/bin/docker-buildx ~/.docker/cli-plugins/docker-buildx
docker buildx version # github.com/docker/buildx v0.30.1 Homebrew
open -a Docker
```

### Deploy

```bash
# First-time setup
bin/kamal setup  --skip-local-build=false

# Subsequent deploys
bin/kamal deploy
```

Access your app at `https://cablecar.click`
