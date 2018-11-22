# DockerComposeYamlLoader

I wanted to give environment variables to Rails on the host PC while using docker-compose, but I created it for use when I do not want to duplicate definitions.
Please use when dotenv etc. can not be used

## Installation

Add this line to your application's Gemfile:

```ruby
group :development, :test do
  gem 'docker_compose_yaml_loader'
end
```

## Usage

config/development.rb or config/test.rb

```ruby
DockerComposeYamlLoader::Environments.setup(Rails.root.join('./docker-compose.yml'), key: 'webapp') do |env|
  # update Environments variables
  env.set('DATABASE_HOST', '127.0.0.1')
  env.set('DATABASE_PORT', '13306')
end

Rails.application.configure do
  ...
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/booink/docker_compose_yaml_loader. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the DockerComposeYamlLoader project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/booink/docker_compose_yaml_loader/blob/master/CODE_OF_CONDUCT.md).
