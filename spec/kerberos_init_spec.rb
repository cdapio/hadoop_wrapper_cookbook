require 'spec_helper'

describe 'hadoop_wrapper::kerberos_init' do
  context 'on Centos 6.4 x86_64' do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'centos', version: 6.4) do |node|
        node.automatic['domain'] = 'example.com'
        node.automatic['memory']['total'] = '4099400kB'
        node.default['hadoop']['core_site']['hadoop.security.authorization'] = true
        node.default['hadoop']['core_site']['hadoop.security.authentication'] = 'kerberos'
        node.default['krb5']['krb5_conf']['realms']['default_realm'] = 'example.com'
        stub_command("kadmin -w password -q 'list_principals' | grep -v Auth | grep '^HTTP/fauxhai.local@EXAMPLE.COM'").and_return(true)
        stub_command("kadmin -w password -q 'list_principals' | grep -v Auth | grep '^hdfs/fauxhai.local@EXAMPLE.COM'").and_return(true)
        stub_command("kadmin -w password -q 'list_principals' | grep -v Auth | grep '^hbase/fauxhai.local@EXAMPLE.COM'").and_return(true)
        stub_command("kadmin -w password -q 'list_principals' | grep -v Auth | grep '^hive/fauxhai.local@EXAMPLE.COM'").and_return(true)
        stub_command("kadmin -w password -q 'list_principals' | grep -v Auth | grep '^mapred/fauxhai.local@EXAMPLE.COM'").and_return(true)
        stub_command("kadmin -w password -q 'list_principals' | grep -v Auth | grep '^yarn/fauxhai.local@EXAMPLE.COM'").and_return(true)
        stub_command("kadmin -w password -q 'list_principals' | grep -v Auth | grep '^zookeeper/fauxhai.local@EXAMPLE.COM'").and_return(true)
        stub_command("kadmin -w password -q 'list_principals' | grep -v Auth | grep '^yarn@EXAMPLE.COM'").and_return(true)
        stub_command('test -e /etc/security/keytabs/HTTP.service.keytab').and_return(true)
        stub_command('test -e /etc/security/keytabs/hdfs.service.keytab').and_return(true)
        stub_command('test -e /etc/security/keytabs/hbase.service.keytab').and_return(true)
        stub_command('test -e /etc/security/keytabs/hive.service.keytab').and_return(true)
        stub_command('test -e /etc/security/keytabs/mapred.service.keytab').and_return(true)
        stub_command('test -e /etc/security/keytabs/yarn.service.keytab').and_return(true)
        stub_command('test -e /etc/security/keytabs/zookeeper.service.keytab').and_return(true)
        stub_command('test -e /etc/security/keytabs/yarn.keytab').and_return(true)
        stub_command('test -e /etc/default/hadoop-hdfs-datanode').and_return(true)
        # Copied from _jce_spec.rb
        stub_command("echo 'd0c2258c3364120b4dbf7dd1655c967eee7057ac6ae6334b5ea8ceb8bafb9262  /var/chef/cache/jce6.zip' | sha256sum -c - >/dev/null").and_return(true)
        stub_command('test -e /tmp/jce6/jce/US_export_policy.jar').and_return(false)
        stub_command('diff -q /tmp/jce6/jce/US_export_policy.jar /usr/lib/jvm/java/jre/lib/security/US_export_policy.jar').and_return(false)
      end.converge(described_recipe)
    end

    %w(hbase zookeeper).each do |user|
      it "creates #{user} user" do
        expect(chef_run).to create_user(user)
      end
    end

    %w(modify-etc-default-files kinit-as-hdfs-user).each do |exec|
      it "executes #{exec} resource" do
        expect(chef_run).to run_execute(exec)
      end
    end
  end
end
