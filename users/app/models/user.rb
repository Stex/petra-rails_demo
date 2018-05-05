class User < ApplicationRecord
  enum role: %w[member moderator admin]

  def name
    "#{first_name} #{last_name}"
  end

  Petra.configure do
    configure_class 'User' do
      dynamic_attribute_reader? do |method_name|
        %w[name].include?(method_name.to_s)
      end
    end
  end
end
