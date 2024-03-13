require 'erb'
template = ERB.new <<-EOF
require_relative '../urls'

module DaVinciPDEXTestKit
  class PDEX<%= value1 %>ClientSubmitMustRequirementTest < Inferno::Test
    include URLs

    id :placeholder_verify_<%= value1.downcase %>_test
    title 'Looks through requests made for an attempt to gather <%= value1 %> resources'
    description %(
      descriptiondescriptiondescription
    )
    input :access_token

    run do
      requests = load_tagged_requests(SUBMIT_TAG)
      desired_requests = requests.select { |req| req.url.include?("<%= value1 %>")}
      assert desired_requests.present?, "No requests made for <%= value1 %> resources"
      assert desired_requests.any? { |req| req.query_parameters["<%= value2 %>"] == "999" }, "No requests filtered by patient"
    end
  end
end
EOF
pairs = [
  ['Patient', '_id'],
  ['AllergyIntolerance', 'patient'],
  ['Condition', 'patient'],
  ['Device', 'patient'],
  ['DiagnosticReport', 'patient'],
  ['DocumentReference', 'patient'],
  ['Encounter', 'patient'],
  ['Goal', 'patient'],
  ['Immunization', 'patient'],
  ['Procedure', 'patient']
]
tests = []
# For each pair of values, generate a file
pairs.each do |(value1, value2)|
  # Use the ERB template to generate the file content
  content = template.result(binding)
  # Write the content to a new file
  File.open("lib/davinci_pdex_test_kit/generated/#{value1}_#{value2}.rb", 'w') do |file|
    file.write(content)
  end
  tests.append("placeholder_verify_#{value1.downcase}_test")
end

# File.open("lib/davinci_pdex_test_kit/generated/tests_list.txt", 'w') do |file|
#   tests.each {|test_id| file.write("#{test_id}\n")}
# end