# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Company.create(name: "Test Company")

User.create(fullname: "Superadmin User", email: "superadmin@localhost", password_hash: "680bd0033d5fbd52e8b5ead7bbf6147e4fb26e17e29e5b8a535c592a6313b011dfee9f67d5bf2fba7c775a48993ec80428df20a058767e262b443924c6ca10ad", password_seed: "1xu7lv78gxgl8z13jggqi7n15cgbafnrzcjzgfcqjgc5xgv4d", access: 4, company_id: 1)
