require 'petra'
require_relative './user'

Petra.configure do
  log_level :warn
end

user = User.petra.new('Foo', 'Bar')

Petra.transaction(identifier: 'tr1') do
  user.first_name = 'Moo'
end

user.first_name = 'Hoot'

Petra.transaction(identifier: 'tr1') do
  puts user.name
  user.last_name = 'Bam'
  puts user.name
end