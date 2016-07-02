class Sensor < ActiveRecord::Base

  has_many :measurements

end
