# -*- encoding: utf-8 -*-
#
# Author:: Jacob McCann (<jmccann.git@gmail.com>)
#
# Copyright (C) 2014, Jacob McCann
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# require 'kitchen/configurable'

require 'socket'

require 'kitchen/binding/core_ext'
require 'kitchen/lazy_hash'

module Kitchen
  module Binding
    # Base class for a binding.
    #
    # @author Jacob McCann <jmccann.git@gmail.com>
    class Base
      # include Configurable # Available in edge test-kitchen
      include Logging

      attr_accessor :state

      attr_accessor :instance # Not required in edge

      # Create a new Binding object using the provided configuration data
      # which will be merged with any default configuration.
      #
      # @param config [Hash] provided binding configuration
      def initialize(config = {})
        # init_config(config) # Available in edge

        # Following not required in edge test-kitchen
        @config = LazyHash.new(config, self)
        self.class.defaults.each do |attr, value|
          @config[attr] = value unless @config.has_key?(attr)
        end
      end

      # Not required in edge
      def instance=(instance)
        @instance = instance
        expand_paths!
        load_needed_dependencies!
      end

      # Returns the name of this transport, suitable for display in a CLI.
      #
      # @return [String] name of this transport
      def name
        self.class.name.split('::').last.downcase
      end

      # Returns the command that will install the remote interactive ruby shell.
      #
      # @return [String] the command to install the remote ruby shell
      # @raise [ActionFailed] if the action could not be completed
      def install_command
      end

      # Returns the command that will log into a remote interactive ruby shell.
      #
      # @raise [ActionFailed] if the action could not be completed
      def connect_command
      end

      # Conditionally prefixes a command with a sudo command.
      #
      # @param command [String] command to be prefixed
      # @return [String] the command, conditionaly prefixed with sudo
      # @api private
      def sudo(script)
        config[:sudo] ? "sudo -E #{script}" : script
      end

      # Test a remote port's connectivity.
      #
      # @return [true,false] a truthy value if the connection is ready
      # and false otherwise
      def test_connection
        debug("Testing binding connection <#{hostname}:#{port}>")
        socket = TCPSocket.new(hostname, port)
        IO.select([socket], nil, nil, 5)
        true
      rescue *SOCKET_EXCEPTIONS, Errno::EPERM, Errno::ETIMEDOUT
        debug("No binding server detected")
        sleep config[:binding_timeout] || 2
        false
      ensure
        socket && socket.close
      end

      protected

      attr_reader :config # Not required in edge

      # TCP socket exceptions
      SOCKET_EXCEPTIONS = [
        SocketError, Errno::ECONNREFUSED, Errno::EHOSTUNREACH,
        Errno::ENETUNREACH, IOError
      ]

      # @return [Hash] Transport options
      attr_reader :options

      # @return [Logger] the logger to use
      # @api private
      attr_reader :logger

      # @return [Integer] Binding port
      # @api private
      def port
        config[:port]
      end

      # @return [String] Binding hostname
      # @api private
      def hostname
        return '33.33.33.200' if state[:hostname] == '127.0.0.1'
        state[:hostname]
      end

      # String representation of object, reporting its connection details and
      # configuration.
      #
      # @api private
      def to_s
        "#{hostname}:#{port}<#{config.inspect}>"
      end

      # Returns a suitable logger to use for output.
      #
      # @return [Kitchen::Logger] a logger
      def logger
        instance ? instance.logger : Kitchen.logger
      end

      # Intercepts any bare #puts calls in subclasses and issues an INFO log
      # event instead.
      #
      # @param msg [String] message string
      def puts(msg) # rubocop:disable Lint/UnusedMethodArgument
        info(msg)
      end

      # Intercepts any bare #print calls in subclasses and issues an INFO log
      # event instead.
      #
      # @param msg [String] message string
      def print(msg) # rubocop:disable Lint/UnusedMethodArgument
        info(msg)
      end

      # Adds http and https proxy environment variables to a command, if set
      # in configuration data.
      #
      # @param command [String] command string
      # @return [String] command string
      # @api private
      def env_command(command) # rubocop:disable Lint/UnusedMethodArgument
      end

      # Not required in edge
      def self.defaults
        @defaults ||= Hash.new.merge(super_defaults)
      end

      # Not required in edge
      def self.super_defaults
        klass = self.superclass

        if klass.respond_to?(:defaults)
          klass.defaults
        else
          Hash.new
        end
      end

      # Not required in edge
      def self.default_config(attr, value = nil, &block)
        defaults[attr] = block_given? ? block : value
      end

      # Can be moved to top later ... moved to bottom for current test-kitchen
      default_config :port, 5000
    end
  end
end
