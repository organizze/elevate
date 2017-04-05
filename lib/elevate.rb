require 'elevate/version'

unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

Motion::Project::App.setup do |app|
  app.detect_dependencies = false
  Dir.glob(File.join(File.dirname(__FILE__), "elevate/**/*.rb")).each do |file|
    app.files.unshift(file)
  end
  app.files_dependencies File.join(File.dirname(__FILE__), "elevate/http.rb") => File.join(File.dirname(__FILE__), "elevate/http/request.rb")
end
