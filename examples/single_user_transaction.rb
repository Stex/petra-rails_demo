require 'petra'
require './user'

Petra.configure do
  log_level :warn
end

@user = User.petra.new('Foo', 'Bar')