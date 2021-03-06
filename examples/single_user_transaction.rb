require 'petra'
require_relative './user'

Petra.configure do
  log_level :warn
end

user = User.petra.new('Foo', 'Bar')

Petra.transaction(identifier: 'tr1') do
  user.first_name = 'Moo'
  puts user.name
end

puts user.name

Petra.transaction(identifier: 'tr1') do
  user.last_name = 'Mar'
  puts user.name
end

puts user.name

Petra.transaction(identifier: 'tr1') do
  Petra.commit!
end

puts user.name