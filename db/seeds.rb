# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
    user = User.create(:email => 'admin@admin.com',:password => 12345678, :password_confirmation => 12345678)
    user.save
    user.roles << Role.create!(:name => "admin")