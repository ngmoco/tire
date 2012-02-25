require 'rest_client'
require 'multi_json'
require 'hashr'

require 'tire/rubyext/hash'
require 'tire/rubyext/symbol'
require 'tire/configuration'
require 'tire/http/response'
require 'tire/http/client'
require 'tire/search'
require 'tire/search/query'
require 'tire/search/sort'
require 'tire/search/facet'
require 'tire/search/filter'
require 'tire/search/highlight'
require 'tire/results/pagination'
require 'tire/results/collection'
require 'tire/results/item'
require 'tire/index'
require 'tire/dsl'
require 'tire/tasks'

module Tire
  extend DSL

  def warn(message)
    line = caller.detect { |line| line !~ %r|lib\/tire\/| }.sub(/:in .*/, '')
    Configuration.error "[DEPRECATION WARNING] #{message}", "(Called from #{line})"
  end
  module_function :warn
end
