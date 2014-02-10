# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

b1 = Brewery.create name:"Koff", year:1897
b2 = Brewery.create name:"Malmgard", year:2001
b3 = Brewery.create name:"Weihenstephaner", year:1042

s1 = Style.create name: "Lager"
s2 = Style.create name: "Pale Ale"
s3 = Style.create name: "Porter"
s4 = Style.create name: "IPA"
s5 = Style.create name: "Weizen"

b1.beers.create name:"Iso 3", style: s1
b1.beers.create name:"Karhu", style: s1
b1.beers.create name:"Tuplahumala", style: s1
b2.beers.create name:"Huvila Pale Ale", style: s2
b2.beers.create name:"X Porter", style: s3
b3.beers.create name:"Hefezeizen", style: s5
b3.beers.create name:"Helles", style: s1