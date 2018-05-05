class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  Petra.configure do
    configure_class 'ApplicationRecord' do
      proxy_instances true
      id_method :id
      lookup_method :find
    end
  end
end
