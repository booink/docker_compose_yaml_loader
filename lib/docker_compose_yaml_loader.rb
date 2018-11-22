require "docker_compose_yaml_loader/version"
require "docker_compose_yaml_loader/environments"
require 'yaml'
require 'awesome_print'

class DockerComposeYamlLoader
  attr_reader :settings

  def self.load(file_path)
    self.new(file_path).load
  end

  def initialize(file_path)
    @file_path = file_path
  end

  def load
    hash = YAML.load_file(@file_path)
    @settings = build(hash)
    @settings
  end

  def build(hash, settings = {})
    return hash if hash.nil?
    extends_hash = {}
    hash.each do |key, value|
      if key == 'extends'
        extends_hash = value
      else
        settings[key.to_s] = if value.is_a? Hash
                                 build(value)
                               else
                                 value
                               end
      end
    end
    settings = merge(settings, extends(extends_hash)) unless extends_hash.empty?
    settings
  end

  def extends(hash)
    file_path = File.join(File.dirname(@file_path), hash['file'])
    service = hash['service']
    other_hash = YAML.load_file(file_path)
    target = other_hash[service] || other_hash['services'][service]
    build(target)
  end

  def merge(destination, source)
    destination, source = merge_image_or_build(destination, source)
    destination, source = merge_join_array_value(destination, source)
    destination, source = merge_priority_to_destination_value(destination, source)
    destination.merge!(source)
    destination
  end

  private

  def merge_image_or_build(destination, source)
    if destination.key?('image') || destination.key?('build')
      source.delete('image')
      source.delete('build')
    else
      destination['image'] = source.delete('image') if source.key?('image')
      destination['build'] = source.delete('build') if source.key?('build')
    end
    return destination, source
  end

  def merge_join_array_value(destination, source)
    %w[ports expose external_links dns dns_search tmpfs].each do |key|
      if destination.key?(key) && source.key?(key)
        destination[key] += source.delete(key)
        destination[key].uniq!
      end
    end
    return destination, source
  end

  def merge_priority_to_destination_value(destination, source)
    %w[environment labels volumes devices].each do |key|
      destination_hash = hashify(destination[key])
      source_hash = hashify(source[key])
      value = source_hash.merge(destination_hash)
      destination[key] = value unless value.empty?
      source.delete(key)
    end
    return destination, source
  end

  def hashify(values)
    return values if values.is_a? Hash
    hash = {}
    if values.is_a? Array
      values.each do |value|
        k, v = value.split(/=:/, 2)
        hash[k] = v
      end
    end
    hash
  end
end
