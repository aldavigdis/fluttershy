# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Faker::Config.locale = "is"

company_arr = Array.new

for i in 0..200
  company_arr.push({ name: Faker::Company.name, kt: "0000000000", email: Faker::Internet.email, tel: Faker::PhoneNumber.phone_number, mobile: Faker::PhoneNumber.cell_phone, contact_name: Faker::Name.name, address1: Faker::Address.street_name+' '+rand(1-110).to_s, address2: Faker::Address.secondary_address, postcode: rand(101-903).to_s, city: Faker::Address.city })
end

companies = Company.create(company_arr)

User.new(fullname: "Superadmin User", email: "superadmin@localhost", password_hash: "680bd0033d5fbd52e8b5ead7bbf6147e4fb26e17e29e5b8a535c592a6313b011dfee9f67d5bf2fba7c775a48993ec80428df20a058767e262b443924c6ca10ad", password_seed: "1xu7lv78gxgl8z13jggqi7n15cgbafnrzcjzgfcqjgc5xgv4d", access: 4, company_id: 1).save(validate: false)

User.new(fullname: "Super User", email: "superuser@localhost", password_hash: "680bd0033d5fbd52e8b5ead7bbf6147e4fb26e17e29e5b8a535c592a6313b011dfee9f67d5bf2fba7c775a48993ec80428df20a058767e262b443924c6ca10ad", password_seed: "1xu7lv78gxgl8z13jggqi7n15cgbafnrzcjzgfcqjgc5xgv4d", access: 4, company_id: 1).save(validate: false)

User.new(fullname: "Admin User", email: "admin@localhost", password_hash: "ff1add18a4ccf2292366837842c99c7d61bfe7e8fd60640bf1eefc5de953410dc1923f85fa6588e71a82a76d65e0906391b62924d8a70ae85d40ada39cca779f", password_seed: "n1i6mafummaj9i3nl5iu4mq8npb3ifg2g4pcij7lwv0alurdd", access: 4, company_id: 1).save(validate: false)

User.new(fullname: "Normal User", email: "user@localhost", password_hash: "8333df598d2d68df5a70920230c453ce93b12a61f9525c459b70704a82054dd0c128edf7215ec2349d4615377707b991d8b7f8b1b8c11a2e4359025089ac183d", password_seed: "1eyraz5plzynd3ruaiz04f0zzr0njhhwlg9x5ksbvc9e2tkpa6", access: 4, company_id: 1).save(validate: false)
