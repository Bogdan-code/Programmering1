require 'rest-client'
require 'json'

api_key = 'WBrtRxuEzLCINddQRkp7QQ2mjqvhQeT2'  # Replace with your Tomorrow.io API key
latitude = 57.7089
longitude = 11.9746
url = "https://api.tomorrow.io/v4/weather/forecast?location=#{latitude},#{longitude}&apikey=#{api_key}"

response = RestClient.get(url)

# Parse the JSON response
data = JSON.parse(response.body)

# Extract the current temperature (first entry in the hourly timeline)
current_temperature = data["timelines"]["hourly"].first["values"]["temperature"]

# Print the current temperature
puts "Current temperature: #{current_temperature}°C"
