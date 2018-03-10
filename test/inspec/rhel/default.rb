control 'adjoin_fx - 01' do
  title 'The required packages should be installed'
  packages = %w(
    sssd
    adcli
    realmd
    samba-common-tools
    krb5-libs
    krb5-workstation
  )
  packages.each do |package_name|
    describe package(package_name) do
      it { should be_installed }
    end
  end
end

control 'adjoin_fx - 02' do
  title 'The computer should be joined to a domain'
  describe command('realm list') do
    its('stdout') { should match(/domain-name:/) }
    its('stdout') { should match(/realm-name:/) }
  end
end
