require 'spec_helper'

describe 'windows_certs::pfx' do

  describe 'validate good config' do
    let(:title) {"mydomain.com"}
    let(:facts){{:operatingsystem => "windows",:kernelmajversion => "6.2"}}
    let(:params){
      {
        :cert_stage_location => "C:\\temp\\mydomain.com.pfx",
        :source_location => "puppet://extra_files/mydomain.com.pfx",
        :cert_secure_pass => "h123lkjojlaskdfjou12308fkljasdf084"
      }
    }

    it{
      should contain_file('C:\\temp\\mydomain.com.pfx').with_source("puppet://extra_files/mydomain.com.pfx")
      should contain_exec('Insert-PFX-Cert-mydomain.com').with(
                 {
                  "provider" => "powershell",
                  "command" => "Import-Module WebAdministration; Import-PfxCertificate -FilePath C:\\temp\\mydomain.com.pfx -CertStoreLocation Cert:\\LocalMachine\\WebHosting -Password (\"h123lkjojlaskdfjou12308fkljasdf084\" | ConvertTo-SecureString -Key @(1..32))",
                  "onlyif" => "Import-Module WebAdministration; if (gci cert:\\LocalMachine${cert_store} -R | where FriendlyName -eq \"mydomain.com\") { exit 1 } else { exit 0 }"
                }
             )
    }
  end

  describe 'missing cert_stage_location' do
    let(:title) {"mydomain.com"}
    let(:facts){{:operatingsystem => "windows"}}
    let(:params){
      {
          :source_location => "puppet://extra_files/mydomain.com.pfx",
          :cert_secure_pass => "h123lkjojlaskdfjou12308fkljasdf084"
      }
    }
    it do
     expect{
       should contain_exec("Insert-PFX-Cert-mydomain.com")
     }.to raise_error(Puppet::Error,/Must pass cert_stage_location to Windows_certs::Pfx\[mydomain.com\]/)
    end
  end

  describe 'missing source_location' do
    let(:title) {"mydomain.com"}
    let(:facts){{:operatingsystem => "windows"}}
    let(:params){
      {
          :cert_stage_location => "C:\\temp\\mydomain.com.pfx",
          :cert_secure_pass => "h123lkjojlaskdfjou12308fkljasdf084"
      }
    }
    it do
      expect{
        should contain_exec("Insert-PFX-Cert-mydomain.com")
      }.to raise_error(Puppet::Error,/Must pass source_location to Windows_certs::Pfx\[mydomain.com\]/)
    end
  end
end