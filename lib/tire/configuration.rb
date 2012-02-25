require 'logger'

module Tire

  class Configuration

    def self.url(value=nil)
      @url = (value ? value.to_s.gsub(%r|/*$|, '') : nil) || @url || ENV['ELASTICSEARCH_URL'] || "http://localhost:9200"
    end

    def self.client(klass=nil)
      @client = klass || @client || HTTP::Client::RestClient
    end

    def self.wrapper(klass=nil)
      @wrapper = klass || @wrapper || Tire::Results::Item
    end

    def self.logger(logger=nil)
      return @logger = logger if logger
      @logger || nil
    end

    def self.reset(*properties)
      reset_variables = properties.empty? ? instance_variables : instance_variables.map { |p| p.to_s} & \
                                                                 properties.map         { |p| "@#{p}" }
      reset_variables.each { |v| instance_variable_set(v.to_sym, nil) }
    end

    def self.error(msg)
      if Configuration.logger
        Configuration.logger.error(msg)
      else
        STDERR.puts msg
      end
    end

    def self.log_request(endpoint, params=nil, curl='')
      return unless @logger
      # 2001-02-12 18:20:42:32 [_search] (articles,users)
      #
      # curl -X POST ....
      #
      content  = "# #{time}"
      content += " [#{endpoint}]"
      content += " (#{params.inspect})" if params
      content += "\n#\n"
      content += curl
      content += "\n\n"
      @logger.info content
    end

    def self.log_response(status, took=nil, json='')
      return unless @logger
      # 2001-02-12 18:20:42:32 [200] (4 msec)
      #
      # {
      #   "took" : 4,
      #   "hits" : [...]
      #   ...
      # }
      #
      content  = "# #{time}"
      content += " [#{status}]"
      content += " (#{took} msec)" if took
      content += "\n#\n" unless json.to_s !~ /\S/
      json.to_s.each_line { |line| content += "# #{line}" } unless json.to_s !~ /\S/
      content += "\n\n"
      @logger.info content
    end

    def self.time
      Time.now.strftime('%Y-%m-%d %H:%M:%S:%L')
    end
  end

end
