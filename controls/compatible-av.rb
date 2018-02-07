# encoding: utf-8

title 'Anti-Virus compatibility'

control 'av-compatibility-1.0' do
  impact 1.0
  title 'Check Anti-Virus is compatible'
  desc 'Compatible Anti-Virus will set a reg key.
Without this Windows updates with Spectre and 
Meltdown fixes will not install
'
  describe registry_key('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\QualityCompat') do
    it { should exist }
    it { should have_property_value('cadca5fe-87d3-4b96-b7fb-a231484277cc', :type_dword, 0) }
  end
end
