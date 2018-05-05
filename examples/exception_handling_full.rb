require 'petra'
require_relative './user'

Petra.configure do
  log_level :warn
end

user = User.petra.new('Foo', 'Bar')

Petra.transaction(identifier: 'tr1') do
  user.first_name = 'Hoot'
end

user.first_name = 'Moo'

Petra.transaction(identifier: 'tr1') do
  puts user.name
  user.last_name = 'Bam'
  puts user.name
rescue Petra::WriteClashError => e
  if e.their_value.length < e.our_value.length
    e.use_ours!
    e.continue!
  end
end

Petra.transaction(identifier: 'tr1') do
  Petra.commit!
end

puts user.name