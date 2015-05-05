module PrestaShop
    def self.execute(options)
        # Check if url and query params are valid
        url = URLResolver.new configuration, options
        url.validate!
        # Make an request

        case options[:method]
          when :get
            response = RestClient::Request.execute  :method   => options[:method],
                                                    :url       => url.to_s,
                                                    :user       => configuration.api_key,
                                                    :headers  => configuration.headers,
                                                    :verify_ssl => configuration.verify_ssl ? true : false
          else
            #ssl.verify_mode = OpenSSL::SSL::VERIFY_NONE unless configuration.verify_ssl
            uri = URI.parse(url.to_s)
            first_arg = uri.scheme + "://" + configuration.api_key + "@" + uri.host + uri.path
            second_arg = CGI.parse(uri.query)["xml"][0]
            response = RestClient.post first_arg, second_arg
        end

        # response = RestClient::Request.execute  :method   => options[:method],
        #                                         :url       => url.to_s,
        #                                         :user       => configuration.api_key,
        #                                         :headers  => configuration.headers,
        #                                         :verify_ssl => configuration.verify_ssl

        puts response.inspect
        # Validate if PrestaShop version is supported
        Headers.new(response).validate!

        response
    end
end