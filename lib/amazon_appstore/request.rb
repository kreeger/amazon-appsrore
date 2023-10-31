# frozen_string_literal: true

require 'net/http'
require 'net/http/post/multipart'
require 'json'

module AmazonAppstore
  # Encapsulates logic for formulating network requests. Agnostic towards
  # reading files and handling etags; just raw verbs, uris, bodies, and headers.
  class Request
    class << self
      def default_headers
        {
          'User-Agent' => 'fastlane-amazon',
          'Accept' => 'application/json',
          'Content-Type' => 'application/json'
        }
      end
    end

    # @return [URI]
    attr_accessor :uri
    # @return [Symbol]
    attr_accessor :verb
    # @return [Object]
    attr_accessor :body
    # @return [Hash<String, String>]
    attr_accessor :headers

    # @param [URI] uri <description>
    # @param [Symbol] verb <description>
    # @param [Object, nil] body <description>
    # @param [Hash<String, String>] headers <description>
    def initialize(uri, verb: :get, body: nil, headers: {})
      @uri = uri
      @verb = verb
      @body = body
      @headers = Request.default_headers.merge(headers)
    end

    # rubocop:disable Layout/LineLength
    # @return [Net::HTTP::Get, Net::HTTP::Delete, Net::HTTP::Post, Net::HTTP::Post::Multipart, Net::HTTP::Put, Net::HTTP::Put::Multipart]
    # rubocop:enable Layout/LineLength
    def as_net_http_request
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.instance_of?(URI::HTTPS)

      request = case verb
                when :get
                  as_get
                when :delete
                  as_delete
                when :post
                  as_post
                when :put
                  as_put
                else
                  raise "Unknown HTTP verb #{verb}; supports :get, :post, :put, :delete"
                end
      [http, request]
    end

    private

    # @return [Net::HTTP::Get]
    def as_get
      the_uri = body ? uri + URI.encode_www_form(body) : uri
      Net::HTTP::Get.new(the_uri.request_uri, headers.merge({
                                                              'Content-Type' => 'application/x-www-form-urlencoded'
                                                            }))
    end

    # @return [Net::HTTP::Delete]
    def as_delete
      the_uri = body ? uri + URI.encode_www_form(body) : uri
      Net::HTTP::Delete.new(the_uri.request_uri, headers.merge({
                                                                 'Content-Type' => 'application/x-www-form-urlencoded'
                                                               }))
    end

    # @return [Net::HTTP::Post, Net::HTTP::Post::Multipart]
    def as_post
      if multipart?
        Net::HTTP::Post::Multipart.new(uri.request_uri, body, headers)
      else
        request = Net::HTTP::Post.new(uri.request_uri, headers)
        if upload?
          request.body_stream = body
        else
          request.body = encoded_body
        end
        request
      end
    end

    # @return [Net::HTTP::Put, Net::HTTP::Put::Multipart]
    def as_put
      if multipart?
        Net::HTTP::Put::Multipart.new(uri.request_uri, body, headers)
      else
        request = Net::HTTP::Put.new(uri.request_uri, headers)
        if upload?
          request.body_stream = body
        else
          request.body = encoded_body
        end
        request
      end
    end

    # @return [String, nil]
    def encoded_body
      return nil if body.nil?

      case headers['Content-Type']
      when 'application/x-www-form-urlencoded'
        URI.encode_www_form(body)
      when 'application/json'
        body.to_json
      end
    end

    # @return [Boolean]
    def multipart?
      upload? && (body.is_a?(Hash) || body.is_a?(Array))
    end

    # @return [Boolean]
    def upload?
      # We don't care about XML, so if we have a body and it's neither JSON nor
      #   URL-encoded, assume we're uploading files
      headers['Content-Type'] != 'application/json' &&
        headers['Content-Type'] != 'application/x-www-form-urlencoded' &&
        !body.nil?
    end
  end
end
