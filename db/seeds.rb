# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(email: 'test@test.com', password: '12345', password_confirmation: '12345')

y1 = Yair.create(field: 'representative', last_name: 'jingles')
y1.social_media_accounts.create(name: 'jinglesbook', site: 'socialmediamania')
y2 = Yair.create(field: 'figure', last_name: 'figureson')
y2.social_media_accounts.create(name: 'figuremedia', site: 'book of faces')
y3 = Yair.create(field: 'media', last_name: 'journalson')
y3.social_media_accounts.create(name: 'columnist001', site: '123')
