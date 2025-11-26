# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create a default test user
user_email = "john_doe@example.com"
user_password = "password"
if User.find_by(email: user_email).nil?
  User.create!(email: user_email, password: user_password)
else
  puts "User `#{user_email}` already exists"
end

# Create a team
john_doe = User.find_by(email: user_email)
if john_doe.accounts.find_by(name: "john_doe_team_one").nil?
  john_doe.create_team_account(name: "john_doe_team_one", description: "john_doe's first team account")
else
  puts "Team account `john_doe_team_one` already exists"
end
