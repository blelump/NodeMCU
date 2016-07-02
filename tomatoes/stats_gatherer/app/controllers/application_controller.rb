class ApplicationController < ActionController::Base

  DHT_MEASUREMENTS = %w(temperature humidity).freeze
  YL_MEASUREMENTS = %w(humidity).freeze

  def data
    if h= params[:data][:dht]
      sensor = Sensor.find_by("const_name like 'dht%'")

      DHT_MEASUREMENTS.each { |name| create_measurement!(sensor, name, h[name]) }
    elsif h = params[:data][:yl]
      sensor = Sensor.find_by("const_name like 'yl%'")

      YL_MEASUREMENTS.each { |name| create_measurement!(sensor, name, h[name]) }
    end

    render text: "ok"
  end


  private

  def create_measurement!(sensor, name, value)
    Measurement.create!(measurement_time: Time.now, sensor_id: sensor.id,
                        measurement_name: name, value: value)
  end
end
