# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# coding: utf-8

User.create!(name: "Sample User",
             email: "sample@email.com",
             department: "AAA",
             password: "password",
             password_confirmation: "password",
             owner: true)

 50.times do |n|
  name  = Faker::Name.name
  email = "sample-#{n+1}@email.com"
  department = "AAA"
  password = "password"
  User.create!(name: name,
               email: email,
               department: department,
               password: password,
               password_confirmation: password)
end
