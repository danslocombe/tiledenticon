# Example usage
# Requires faker gem

require 'tiledenticon'
require 'faker'

td = Tiledenticon.new('out')

for i in 1..20 do
  email = Faker::Internet.email
  td.create(email)
end
