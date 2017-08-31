require 'rspec'
require 'serverspec'

RSpec.shared_examples "policyd" do

  describe package('apache2') do
    it { should be_installed }
  end

  describe package('gettext-base') do
    it { should be_installed }
  end

  describe package('postfix-cluebringer') do
    it { should be_installed }
  end

  describe package('postfix-cluebringer-mysql') do
    it { should be_installed }
  end


  describe package('postfix-cluebringer-webui') do
    it { should be_installed }
  end

  describe process('apache2') do
    it { should be_running }
  end

  describe process('cbpolicyd') do
    it { should be_running }
  end

  describe file('/etc/apache2/ports.conf') do
    it { should contain('Listen 8080') }
  end

  describe file('/etc/cluebringer') do
    it { should exist }
    it { should be_directory }
  end

  describe file('/tmp/policyd-db.mysql') do
    it { should exist }
    it { should be_file }
  end

  describe file('/var/lock/apache2') do
    it { should exist }
    it { should be_directory }
    it { should be_writable.by('others') }
  end

  describe file('/var/run/apache2') do
    it { should exist }
    it { should be_directory }
    it { should be_writable.by('others') }
  end

  describe file('/etc/apache2/mods-enabled/rewrite.load') do
    it { should exist }
    it { should be_file }
  end

  describe file('/etc/apache2/sites-available/000-default.conf') do
    it { should exist }
    it { should contain('VirtualHost *:8080') }
    it { should contain('AllowOverride All') }
  end

  describe command("curl -sS http://localhost:#{LISTEN_PORT}") do
    its(:stdout) { should contain "Unauthorized" }
    its(:stderr) { should eq "" }
  end

end
