require 'active_support/inflector'
require 'rest-client'
require 'yaml'

['./exceptions/*_exception.rb', './servers/*.rb'].each do |pattern|
  Dir.glob(pattern).each {|f| require f}
end
