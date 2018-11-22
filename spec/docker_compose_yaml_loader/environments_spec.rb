RSpec.describe DockerComposeYamlLoader::Environments do
  describe "#setup" do
    before do
      ENV.delete('API_KEY')
      ENV.delete('OTHER_API_KEY')
    end

    it 'without block' do
      environments = DockerComposeYamlLoader::Environments.new('./spec/fixtures/docker-compose-with-extends.yml', 'webapp').setup
      expect(ENV['API_KEY']).to eq('xxxyyy')
    end

    it "with block" do
      environments = DockerComposeYamlLoader::Environments.new('./spec/fixtures/docker-compose-with-extends.yml', 'webapp').setup do |env|
        env.set('API_KEY', 'zzz')
        env.set('OTHER_API_KEY', 'aaabbb')
      end
      expect(ENV['API_KEY']).to eq('zzz')
      expect(ENV['OTHER_API_KEY']).to eq('aaabbb')
   end

    it "can not update" do
      ENV['API_KEY'] = '111222'
      environments = DockerComposeYamlLoader::Environments.new('./spec/fixtures/docker-compose-with-extends.yml', 'webapp').setup do |env|
        env.set('API_KEY', 'zzz')
        env.set('OTHER_API_KEY', 'aaabbb')
      end
      expect(ENV['API_KEY']).to eq('111222')
      expect(ENV['OTHER_API_KEY']).to eq('aaabbb')
   end
  end
end
