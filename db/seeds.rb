# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
PriceTier.create!(min_students: 0, max_students: 50, price: 50)
PriceTier.create!(min_students: 51, max_students: 200, price: 100)
PriceTier.create!(min_students: 201, max_students: 500, price: 200)
PriceTier.create!(min_students: 600, max_students: 800, price: 500)
PriceTier.create!(min_students: 801, max_students: 1000, price: 1200)
