require 'spec_helper'

describe 'hadoop_wrapper::_jce' do
  context 'on Centos 6.4 x86_64' do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'centos', version: 6.4) do |node|
        node.automatic['domain'] = 'example.com'
        node.automatic['memory']['total'] = '4099400kB'
        # JDK 6
        stub_command("echo 'd0c2258c3364120b4dbf7dd1655c967eee7057ac6ae6334b5ea8ceb8bafb9262  /var/chef/cache/jce6.zip' | sha256sum -c - >/dev/null").and_return(true)
        stub_command("echo 'd0c2258c3364120b4dbf7dd1655c967eee7057ac6ae6334b5ea8ceb8bafb9262  /home/travis/.chef/cache/jce6.zip' | sha256sum -c - >/dev/null").and_return(true)
        stub_command('test -e /tmp/jce6/jce/US_export_policy.jar').and_return(false)
        stub_command('diff -q /tmp/jce6/jce/US_export_policy.jar /usr/lib/jvm/java/jre/lib/security/US_export_policy.jar').and_return(false)
        # JDK 7
        stub_command("echo '7a8d790e7bd9c2f82a83baddfae765797a4a56ea603c9150c87b7cdb7800194d  /var/chef/cache/jce7.zip' | sha256sum -c - >/dev/null").and_return(true)
        stub_command("echo '7a8d790e7bd9c2f82a83baddfae765797a4a56ea603c9150c87b7cdb7800194d  /home/travis/.chef/cache/jce7.zip' | sha256sum -c - >/dev/null").and_return(true)
        stub_command('test -e /tmp/jce7/jce/US_export_policy.jar').and_return(false)
        stub_command('diff -q /tmp/jce7/jce/US_export_policy.jar /usr/lib/jvm/java/jre/lib/security/US_export_policy.jar').and_return(false)

        stub_command("echo '7a8d790e7bd9c2f82a83baddfae765797a4a56ea603c9150c87b7cdb7800194d  /home/travis/.chef/cache/jce7.zip' | sha256sum -c - >/dev/null").and_return(true)
      end.converge(described_recipe)
    end

    %w(curl unzip).each do |pkg|
      it "installs #{pkg} package" do
        expect(chef_run).to install_package(pkg)
      end
    end
  end
end
