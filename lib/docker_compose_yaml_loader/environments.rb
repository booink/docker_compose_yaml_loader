class DockerComposeYamlLoader
  class Environments
    def self.setup(file_path, key: , &block)
      self.new(file_path, key).setup(&block)
    end

    def initialize(file_path, key)
      @file_path = file_path
      @key = key
      @environments = {}
    end

    def setup(&block)
      settings = DockerComposeYamlLoader.load(@file_path)
      @key.split('/').each do |k|
        settings = settings[k]
      end
      @environments = settings['environment']
      block.call(self) if block_given?
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
