require 'spec_helper'

describe 'hadoop_wrapper::hive_metastore_init' do
  context 'on Centos 6.6 x86_64' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.6) do |node|
        node.automatic['domain'] = 'example.com'
        node.automatic['memory']['total'] = '4099400kB'
        stub_command(/hdfs dfs -/).and_return(false)
        stub_command(/test -L/).and_return(false)
        stub_command(/update-alternatives --display (.+) /).and_return(false)
        stub_command(/jce(.+).zip' | sha256sum/).and_return(false)
        stub_command(%r{test -e /tmp/jce(.+)/}).and_return(false)
        stub_command(%r{diff -q /tmp/jce(.+)/}).and_return(false)
        stub_command(%r{/sys/kernel/mm/(.*)transparent_hugepage/defrag}).and_return(false)
      end.converge(described_recipe)
    end

    it 'does not run initaction-create-hive-hdfs-scratchdir ruby_block' do
      expect(chef_run).not_to run_ruby_block('initaction-create-hive-hdfs-scratchdir')
    end

    it 'runs initaction-create-hive-hdfs-warehousedir ruby_block' do
      expect(chef_run).to run_ruby_block('initaction-create-hive-hdfs-warehousedir')
    end
  end

  context 'using custom hive.exec.scratchdir' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.6) do |node|
        node.override['hive']['hive_site']['hive.exec.scratchdir'] = '/some/path'
        stub_command(/hdfs dfs -/).and_return(false)
        stub_command(/test -L/).and_return(false)
        stub_command(/update-alternatives --display (.+) /).and_return(false)
        stub_command(/jce(.+).zip' | sha256sum/).and_return(false)
        stub_command(%r{test -e /tmp/jce(.+)/}).and_return(false)
        stub_command(%r{diff -q /tmp/jce(.+)/}).and_return(false)
        stub_command(%r{/sys/kernel/mm/(.*)transparent_hugepage/defrag}).and_return(false)
      end.converge(described_recipe)
    end

    it 'runs initaction-create-hive-hdfs-scratchdir ruby_block' do
      expect(chef_run).to run_ruby_block('initaction-create-hive-hdfs-scratchdir')
    end
  end
end
