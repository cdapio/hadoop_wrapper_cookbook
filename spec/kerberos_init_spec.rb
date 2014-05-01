require 'spec_helper'

describe 'hadoop_wrapper::kerberos_init' do
  context 'on Centos 6.4 x86_64' do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'centos', version: 6.4) do |node|
        node.automatic['domain'] = 'example.com'
        node.automatic['memory']['total'] = '4099400kB'
      end.converge(described_recipe)
    end

    it 'does nothing yet' do
      expect(chef_run).to do_nothing
    end
  end
end
