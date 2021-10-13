# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Producer.destroy_all
Producer.create(name: "Asus", description: "Computer producer")
Producer.create(name: "Lenovo", description: "Laptop producer")
Producer.create(name: "Microsoft", description: "Computer and mobile phones producer")
