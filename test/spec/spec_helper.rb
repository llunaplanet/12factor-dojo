require 'httparty'
require 'json'
require 'redis'

# RSpec.configure do |config|
#     config.filter_run focus: true
#     config.run_all_when_everything_filtered = true
# end

def get_container_id(docker_host, container_names)
  container_list_response = HTTParty.get("#{docker_host}/v1.38/containers/json")
  container_list = JSON.parse(container_list_response.body)
  selected_container = container_list.select { |item| 
    container_names.any? {
      |container_name| item["Names"].include?("#{container_name}")
    }
  }.first
  
  selected_container["Id"]

end
