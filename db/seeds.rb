# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# john
john = Identity.create!(email: "john@example.com", password: "password")
Account.create_with_owner!(account: { name: "john_team_one" }, owner: { name: "John Doe", identity: john })
Account.create_with_owner!(account: { name: "john_team_two" }, owner: { name: "John Doe", identity: john })
