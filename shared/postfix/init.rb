require 'rspec'
require 'serverspec'

RSpec.shared_examples "postfix" do

  describe file('/etc/lsb-release') do
    it { should contain 'DISTRIB_RELEASE=16.04' }
  end

  describe package('supervisor') do
    it { should be_installed }
  end

  describe package('vim') do
    it { should be_installed }
  end

  describe package('curl') do
    it { should be_installed }
  end

 describe package('bzip2') do
   it { should be_installed }
 end

 describe process('supervisord') do
   it { should be_running }
 end

 describe file('/hooks') do
   it { should be_directory }
   it { should be_mode 755 }
 end

 describe file('/init') do
   it { should be_directory }
   it { should be_mode 755 }
 end

 describe file('/var/log/supervisor') do
   it { should be_directory }
   it { should be_writable.by('others') }
 end

 describe file('/init/entrypoint') do
   it { should exist }
 end

 describe file ('/etc/supervisor/supervisord.conf') do
   it { should exist }
   it { should contain('command=/etc/supervisor/exit_on_fatal.py') }
 end

 describe file ('/var/run') do
   it { should exist }
   it { should be_writable.by('others') }
 end

 describe file ('/tmp/sockets') do
   it { should exist }
   it { should be_writable.by('others') }
 end

 describe command('ls -l /var/lib/apt/lists') do
   its(:stdout) { should match /^total 0$/ }
 end

 describe command('echo $SUPERVISORD_EXIT_ON_FATAL') do
  its(:stdout) { should match /^1$/ }
 end

 describe package('postfix') do
   it { should be_installed }
 end

 describe package('libsasl2-modules') do
   it { should be_installed }
 end

 describe package('sasl2-bin') do
   it { should be_installed }
 end

 describe package('rsyslog') do
   it { should be_installed }
 end

  describe file('/etc/postfix/main.cf') do
    it { should contain 'smtp_tls_security_level = may' }
    it { should contain 'smtpd_sasl_auth_enable = yes' }
    it { should contain 'smtpd_sasl_local_domain =' }
    it { should contain 'smtpd_sasl_auth_enable = yes' }
    it { should contain 'smtpd_sasl_security_options = noanonymous' }
    it { should contain 'smtpd_sasl_authenticated_header = yes' }
    it { should contain 'broken_sasl_auth_clients = yes' }
    it { should contain 'smtpd_recipient_restrictions = permit_sasl_authenticated,permit_mynetworks,reject_unauth_destination' }
    it { should contain 'inet_interfaces = all' }
    it { should contain 'smtpd_sender_restrictions = check_policy_service inet:172.30.10.20:10031' }
  end

  describe file('/etc/postfix/sasl/smtpd.conf') do
    it { should contain 'pwcheck_method: saslauthd' }
  end

  describe file('/var/spool/postfix/var/run/saslauthd') do
    it { should be_directory  }
  end

  describe file('/etc/postfix/sasl/smtpd.conf') do
    it { should contain 'mech_list: PLAIN LOGIN' }
  end

  describe file('/var/run/saslauthd') do
    it { should be_owned_by 'postfix' }
  end

end
