require 'petra'

class User
  attr_accessor :first_name
  attr_accessor :last_name

  def initialize(first_name, last_name)
    self.first_name, self.last_name = first_name, last_name
  end

  def name
    "#{first_name} #{last_name}"
  end

  # Petra Configuration

  Petra.configure do
    configure_class 'User' do
      proxy_instances true
  
      attribute_reader? do |method_name|
        %w[first_name last_name].include?(method_name.to_s)
      end
  
      attribute_writer? do |method_name|
        %w[first_name= last_name=].include?(method_name.to_s)
      end
  
      dynamic_attribute_reader? do |method_name|
        %w[name].include?(method_name.to_s)
      end
  
      persistence_method? do |method_name|
        %w[first_name= last_name=].include?(method_name.to_s)
      end
    end
  end
end