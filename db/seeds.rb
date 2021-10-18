# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Computer.destroy_all
Producer.destroy_all
p1 = Producer.create(name: 'Asus', description: 'Computer producer')
p2 = Producer.create(name: 'Lenovo', description: 'Laptop producer')
Producer.create(name: 'Microsoft', description: 'Computer and mobile phones producer')

Computer.create(name: 'Computer 1', producer_id: p1.id, price: 123.11)
Computer.create(name: 'Computer 2', producer_id: p2.id, price: 500)
