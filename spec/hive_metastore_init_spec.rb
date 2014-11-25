require 'spec_helper'

describe 'hadoop_wrapper::hive_metastore_init' do
  context 'on Centos 6.4 x86_64' do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'centos', version: 6.4) do |node|
        node.automatic['domain'] = 'example.com'
        node.automatic['memory']['total'] = '4099400kB'
        stub_command('hdfs dfs -test -d hdfs://fauxhai.local//user/hive/warehouse').and_return(false)
        stub_command('update-alternatives --display hadoop-conf | grep best | awk \'{print $5}\' | grep /etc/hadoop/conf.chef').and_return(false)
        stub_command('update-alternatives --display hive-conf | grep best | awk \'{print $5}\' | grep /etc/hive/conf.chef').and_return(false)
        stub_command('test -L /var/log/hive').and_return(false)
        # JDK 7
        stub_command("echo '7a8d790e7bd9c2f82a83baddfae765797a4a56ea603c9150c87b7cdb7800194d  /var/chef/cache/jce7.zip' | sha256sum -c - >/dev/null").and_return(true)
        stub_command("echo '7a8d790e7bd9c2f82a83baddfae765797a4a56ea603c9150c87b7cdb7800194d  /home/travis/.chef/cache/jce7.zip' | sha256sum -c - >/dev/null").and_return(true)
        stub_command('test -e /tmp/jce7/jce/US_export_policy.jar').and_return(false)
        stub_command('diff -q /tmp/jce7/jce/US_export_policy.jar /usr/lib/jvm/java/jre/lib/security/US_export_policy.jar').and_return(false)
      end.converge(described_recipe)
    end

    it 'runs initaction-create-hive-hdfs-warehousedir ruby_block' do
      expect(chef_run).to run_ruby_block('initaction-create-hive-hdfs-warehousedir')
    end
  end
end
