require 'spec_helper'

describe 'hadoop_wrapper::jce' do
  context 'on Centos 6.4 x86_64' do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'centos', version: 6.4) do |node|
        node.automatic['domain'] = 'example.com'
        node.automatic['memory']['total'] = '4099400kB'
        stub_command("echo 'd0c2258c3364120b4dbf7dd1655c967eee7057ac6ae6334b5ea8ceb8bafb9262  /var/chef/cache/jce6.zip' | sha256sum -c - >/dev/null").and_return(true)
        stub_command('test -e /tmp/jce6/jce/US_export_policy.jar').and_return(false)
        stub_command('diff -q /tmp/jce6/jce/US_export_policy.jar /usr/lib/jvm/java/jre/lib/security/US_export_policy.jar').and_return(false)
      end.converge(described_recipe)
    end

    %w(curl unzip).each do |pkg|
      it "installs #{pkg} package" do
        expect(chef_run).to install_package(pkg)
      end
    end
  end
end
