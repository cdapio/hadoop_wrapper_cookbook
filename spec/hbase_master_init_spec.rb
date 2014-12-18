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
        # JDK 7
        stub_command("echo '7a8d790e7bd9c2f82a83baddfae765797a4a56ea603c9150c87b7cdb7800194d  /var/chef/cache/jce7.zip' | sha256sum -c - >/dev/null").and_return(false)
        stub_command("echo '7a8d790e7bd9c2f82a83baddfae765797a4a56ea603c9150c87b7cdb7800194d  /home/travis/.chef/cache/jce7.zip' | sha256sum -c - >/dev/null").and_return(false)
        stub_command('test -e /tmp/jce7/jce/US_export_policy.jar').and_return(false)
        stub_command('diff -q /tmp/jce7/jce/US_export_policy.jar /usr/lib/jvm/java/jre/lib/security/US_export_policy.jar').and_return(false)
      end.converge(described_recipe)
    end

    %w(initaction-create-hbase-hdfs-rootdir initaction-create-hbase-bulkload-stagingdir).each do |name|
      it "run #{name} ruby_block" do
        expect(chef_run).to run_ruby_block(name)
      end
    end
  end
end
