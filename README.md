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
