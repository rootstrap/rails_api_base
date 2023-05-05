class ApplicationRecord < ActiveRecord::Base
  include ActiveStorageSupport::SupportForBase64

  self.abstract_class = true
end

class Location < ActiveRecord::Base
  acts_as_mappable :default_units => :miles,
                   :default_formula => :sphere,
                   :distance_field_name => :distance,
                   :lat_column_name => :lat,
                   :lng_column_name => :lng
end
