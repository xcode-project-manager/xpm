# frozen_string_literal: true

Then("I should be able to access the documentation of target {string}") do |target|
  cmd = "swift run tuist doc --path #{@dir}/#{target}/ #{target}"
  pid = IO.popen(cmd, :err=>[:child, :out]) # merge standard output and standard error

  sleep 1

  uri = URI.parse("http://localhost:4040/index.html")
  request = Net::HTTP::Get.new(uri)

  response = Net::HTTP.start(uri.hostname, uri.port) do |http|
    http.request(request)
  end

  Process.kill("INT", pid) unless response.code != 200
end

