require 'spec_helper'

describe 'hadoop_wrapper::_jce' do
  context 'on Centos 6.6 x86_64' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.6) do |node|
        node.automatic['domain'] = 'example.com'
        node.automatic['memory']['total'] = '4099400kB'
        stub_command(/jce(.+).zip' | sha256sum/).and_return(false)
        stub_command(%r{test -e /tmp/jce(.+)/}).and_return(false)
        stub_command(%r{diff -q /tmp/jce(.+)/}).and_return(false)
      end.converge(described_recipe)
    end

    %w(curl unzip).each do |pkg|
      it "installs #{pkg} package" do
        expect(chef_run).to install_package(pkg)
      end
    end

    %w(download-jce-zipfile unzip-jce-zipfile copy-jce-files).each do |bash|
      it "runs bash['#{bash}'] block" do
        expect(chef_run).to run_bash(bash)
      end
    end
  end
end
