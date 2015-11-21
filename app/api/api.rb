require 'grape'
require 'warden'
require 'utils/logger'
require 'utils/failure_app'
require 'version1/engine'

module API
  class UnauthoraizedError < StandardError; end

  # Main engine to mount in the routes
  class Engine < ::Grape::API
    rescue_from Grape::Exceptions::Validation do |e|
      Rack::Response.new({ 'errors' => e.message,
                           'param' => e.param
                         }.to_json,
                         422,
                         'Content-Type' => 'application/json'
                        )
    end

    rescue_from Grape::Exceptions::ValidationErrors do |e|
      Rack::Response.new({ 'errors' => e.message }.to_json,
                         422,
                         'Content-Type' => 'application/json'
                        )
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      Rack::Response.new({ 'errors' => e.message,
                           'message' => 'RecordNotFound'
                         }.to_json,
                         404,
                         'Content-Type' => 'application/json'
                        )
    end

    rescue_from UnauthoraizedError do |_e|
      Rack::Response.new({
        'errors' => 'Invalid API public token',
        'message' => 'Unauthoraized'
      }.to_json,
                         401, 'Content-Type' => 'application/json')
    end

    use API::Logger

    mount API::Version1::Engine
  end
end
