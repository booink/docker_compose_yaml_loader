# frozen_string_literal: true

RSpec.describe DockerComposeYamlLoader do
  it 'has a version number' do
    expect(DockerComposeYamlLoader::VERSION).not_to be nil
  end

  it 'load docker-compose.yml' do
    docker_compose_yaml = DockerComposeYamlLoader.new('./spec/fixtures/docker-compose.yml').load
    expect(docker_compose_yaml).to eq(
      'webapp' => {
        'command' => '/code/run_web_app',
        'ports' => ['8080:8080'],
        'links' => %w[queue db]
      },
      'queue_worker' => {
        'command' => '/code/run_worker',
        'links' => ['queue']
      }
    )
  end

  it 'load docker-compose-with-extends.yml' do
    docker_compose_yaml = DockerComposeYamlLoader.new('./spec/fixtures/docker-compose-with-extends.yml').load
    expect(docker_compose_yaml).to eq(
      'webapp' => {
        'command' => '/code/run_web_app',
        'ports' => ['8080:8080'],
        'links' => %w[queue db],
        'image' => 'foo',
        'environment' => {
          'CONFIG_FILE_PATH' => '/code/config',
          'API_KEY' => 'xxxyyy'
        },
        'cpu_shares' => 5
      },
      'queue_worker' => {
        'command' => '/code/run_worker',
        'links' => ['queue'],
        'build' => '.',
        'environment' => {
          'CONFIG_FILE_PATH' => '/code/config',
          'API_KEY' => 'xxxyyy'
        },
        'cpu_shares' => 5
      }
    )
  end
end
