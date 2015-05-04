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

        case options[:method]
          when :post
            #ssl.verify_mode = OpenSSL::SSL::VERIFY_NONE unless configuration.verify_ssl
            uri = URI.parse(url.to_s)
            first_arg = uri.scheme + "://" + configuration.api_key + "@" + uri.host + uri.path
            second_arg = CGI.parse(URI.parse(uri).query)["xml"][0]
            puts "POST*******************"
            puts first_arg
            puts second_arg
            response = RestClient.post first_arg, second_arg
          else
            response = RestClient::Request.execute  :method   => options[:method],
                                                    :url       => url.to_s,
                                                    :user       => configuration.api_key,
                                                    :headers  => configuration.headers,
                                                    :verify_ssl => configuration.verify_ssl
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