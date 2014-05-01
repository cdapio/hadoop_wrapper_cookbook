require 'spec_helper'

describe 'hadoop_wrapper::hbase_master_init' do
  context 'on Centos 6.4 x86_64' do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'centos', version: 6.4) do |node|
        node.automatic['domain'] = 'example.com'
        node.automatic['memory']['total'] = '4099400kB'
        node.default['hbase']['hbase_site']['hbase.rootdir'] = 'hdfs://fauxhai.local/hbase'
        node.default['hbase']['hbase_site']['hbase.zookeeper.quorum'] = 'fauxhai.local'
        stub_command('hdfs dfs -test -d hdfs://fauxhai.local/hbase').and_return(false)
        stub_command('hdfs dfs -test -d /tmp/hbase-staging').and_return(false)
        stub_command('update-alternatives --display hadoop-conf | grep best | awk \'{print $5}\' | grep /etc/hadoop/conf.chef').and_return(false)
        stub_command('update-alternatives --display hbase-conf | grep best | awk \'{print $5}\' | grep /etc/hbase/conf.chef').and_return(false)
      end.converge(described_recipe)
    end

    %w(initaction-create-hbase-hdfs-rootdir initaction-create-hbase-bulkload-stagingdir).each do |name|
      it "run #{name} ruby_block" do
        expect(chef_run).to run_ruby_block(name)
      end
    end
  end
end
