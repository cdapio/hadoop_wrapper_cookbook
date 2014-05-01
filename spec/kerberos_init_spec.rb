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
        stub_command('test -e /etc/security/keytabs/HTTP.service.keytab').and_return(true)
      end.converge(described_recipe)
    end

    %w(hbase zookeeper).each do |user|
      it "creates #{user} user" do
        expect(chef_run).to create_user(user)
      end
    end
  end
end
