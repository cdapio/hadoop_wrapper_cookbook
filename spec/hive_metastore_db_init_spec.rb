require 'spec_helper'

describe 'hadoop_wrapper::hive_metastore_db_init' do
  context 'on Centos 6.4 x86_64' do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'centos', version: 6.4) do |node|
        node.automatic['domain'] = 'example.com'
        node.automatic['memory']['total'] = '4099400kB'
        node.default['hive']['hive_site']['hive.metastore.uris'] = 'thrift://fauxhai.local:9083'
        node.default['hive']['hive_site']['javax.jdo.option.ConnectionURL'] = 'jdbc:mysql://localhost:3306/hive'
        stub_command('update-alternatives --display hadoop-conf | grep best | awk \'{print $5}\' | grep /etc/hadoop/conf.chef').and_return(false)
        stub_command('update-alternatives --display hive-conf | grep best | awk \'{print $5}\' | grep /etc/hive/conf.chef').and_return(false)
      end.converge(described_recipe)
    end
  end
end
