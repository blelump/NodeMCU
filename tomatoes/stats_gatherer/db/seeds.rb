ActiveRecord::Base.transaction do

  Sensor.create!(name: "DHT 22", const_name: "dht22")
  Sensor.create!(name: "YL 38", const_name: "yl38")

end
