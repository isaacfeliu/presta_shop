module PrestaShop
    class Configuration
        attr_accessor :api_url, :api_key
        attr_accessor :shop_id
        attr_accessor :debug, :log
        attr_accessor :headers
        attr_accessor :proxy
        attr_accessor :verify_ssl
        
        alias_method :debug?, :debug
        
        def initialize(options = {})
            @api_url = options[:api_url]
            @api_key = options[:api_key]
            @shop_id = options[:shop_id]
            @debug   = options[:debug] || false
            @log     = options[:logger] ||'stdout'
            @headers = options[:headers] || {}
            @proxy = options[:proxy]
            @verify_ssl = options[:verify_ssl]

            self.api_url = @api_url
            self.headers = @headers
            self.proxy = @proxy
            self.verify_ssl = @verify_ssl
            self
        end

        def api_url=(url)
            return if url.nil?
            return unless url.valid_url?

            @api_url = url
            unless @api_url.end_with? "/"
                @api_url << "/"
            end

            unless @api_url.end_with? "api/"
                @api_url << "api/"
            end
        end

        def api_key=(user_api_key)
            return if user_api_key.nil? or user_api_key.empty?
            @api_key = user_api_key
        end

        def proxy=(user_proxy)
          return if user_proxy.nil? or user_proxy.empty?
          @proxy = user_proxy
          RestClient.proxy = user_proxy
        end

        def verify_ssl=(user_verify_ssl)
          return if user_verify_ssl.nil? or user_verify_ssl.empty?
          @verify_ssl = user_verify_ssl
        end

        def headers=(user_headers)
            @headers = user_headers
            unless @headers.has_key? "User-Agent"
                @headers["User-Agent"] = "PrestaShop Ruby Library v#{PrestaShop::VERSION}"
            end
        end

        def log=(user_log)
            if user_log == :stderr or user_log == :stdout
                user_log = user_log.to_s
            end

            if user_log.kind_of?(::String)
                @log = user_log
                RestClient.log = @log
            end
        end

        def default_shop?
            @shop_id.nil?
        end

        def validate!
            raise UninitializedError unless @api_url and @api_key
        end
    end
end