# encoding: utf-8

updates = %w[KB4056890 KB4056891 KB4056892 KB4056894 KB4056895 KB4056897 KB4056898]

title 'Updates are installed and protections enabled'

control 'updates-installed-1.0' do
  impact 1.0
  title 'Check updates for Spectre and Meltdown'
  desc 'Check that Spectre and Meltdown security updates
        are installed. List of KBs from 
        https://support.microsoft.com/en-us/help/4073757/protect-your-windows-devices-against-spectre-meltdown'
  describe.one do
    updates.each do |update|
      describe windows_hotfix(update) do
        it { should be_installed }
      end
    end
  end
end

control 'protections-enabled-1.0' do
  impact 1.0
  title 'Check Spectre and Meltdown protections are enabled'
  desc 'Check that Spectre and Meltdown protections are
        actually enabled. See "Enabling protections on the server"
        in https://support.microsoft.com/en-us/help/4072698/windows-server-guidance-to-protect-against-the-speculative-execution'

  describe registry_key('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management') do
    it { should exist }
    it { should have_property_value('FeatureSettingsOverride', :type_dword, 0) }
  end

  describe registry_key('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management') do
    it { should exist }
    it { should have_property_value('FeatureSettingsOverrideMask', :type_dword, 3) }
  end

  describe registry_key('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Virtualization') do
    it { should exist }
    it { should have_property_value('MinVmVersionForCpuBasedMitigations', :type_string, "1.0") }
  end

end

control 'pending-restart-1.0' do
  impact 1.0
  title 'Check that there is not a pending restart'
  desc 'Check that there is not a pending reboot, which
        may be required to ensure updates are functional'

  describe.one do
    describe registry_key('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Updates') do
      it { should_not have_property('UpdateExeVolatile') }
    end
    describe registry_key('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Updates') do
      it { should_not have_property_value('UpdateExeVolatile', :type_dword, 0) }
    end
  end

  describe.one do
    describe registry_key('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager') do
      it { should_not have_property('PendingFileRenameOperations') }
    end
    describe registry_key('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager') do
      it { should_not have_property_value('PendingFileRenameOperations', :type_dword, 0) }
    end
  end

end
