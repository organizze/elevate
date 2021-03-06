module Elevate
module HTTP
  class HTTPClient
    def initialize(base_url)
      @base_url = NSURL.URLWithString(base_url)
      @credentials = nil
    end

    def get(path, query={}, &block)
      issue(:get, path, nil, query: query, &block)
    end

    def post(path, body, &block)
      issue(:post, path, body, &block)
    end

    def put(path, body, &block)
      issue(:put, path, body, &block)
    end

    def delete(path, &block)
      issue(:delete, path, nil, &block)
    end

    def set_credentials(username, password)
      @credentials = { username: username, password: password }
    end

    private

    def issue(method, path, body, options={}, &block)
      url = url_for(path)

      options[:headers] ||= {}
      options[:headers]["Accept"] = "application/json"

      if @credentials
        options[:credentials] = @credentials
      end

      if body
        options[:body] = NSJSONSerialization.dataWithJSONObject(body, options:0, error:nil)
        options[:headers]["Content-Type"] = "application/json"
      end

      Elevate::HTTP.send(method, url, options)
    end

    def url_for(path)
      path = CFURLCreateStringByAddingPercentEscapes(nil, path.to_s, "[]", ";=&,", KCFStringEncodingUTF8)

      NSURL.URLWithString(path, relativeToURL:@base_url).absoluteString
    end
  end
end
end
