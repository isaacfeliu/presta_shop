module PrestaShop
    def self.execute(options)
        # Check if url and query params are valid
        url = URLResolver.new configuration, options
        url.validate!
        puts url
        puts options[:method]
        puts url.to_s
        puts configuration.api_key
        puts configuration.headers
        puts configuration.verify_ssl
        # Make an request
        response = RestClient::Request.execute  :method   => options[:method], 
                                                :url       => url.to_s,
                                                :user       => configuration.api_key,
                                                :headers  => configuration.headers,
                                                :verify_ssl => configuration.verify_ssl
        puts response.inspect
        # Validate if PrestaShop version is supported
        Headers.new(response).validate!

        response
    end
end