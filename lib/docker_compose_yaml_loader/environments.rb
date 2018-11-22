# frozen_string_literal: true

class DockerComposeYamlLoader
  #
  # Usage:
  #   DockerComposeYamlLoader::Environments.setup('./path/to/docker-compose.yml', key: 'webapp')
  #
  class Environments
    def self.setup(file_path, key:, &block)
      new(file_path, key).setup(&block)
    end

    def initialize(file_path, key)
      @file_path = file_path
      @key = key
      @environments = {}
    end

    def setup
      settings = DockerComposeYamlLoader.load(@file_path)
      @key.split('/').each do |k|
        settings = settings[k]
      end
      @environments = settings['environment']
      yield(self) if block_given?
      fetch
    end

    def set(key, value)
      @environments[key.to_s] = value
    end

    def fetch
      @environments.each do |key, value|
        ENV[key] = value.to_s unless ENV.key?(key)
      end
    end
  end
end
