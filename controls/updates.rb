# encoding: utf-8

updates = %w[KB4056890 KB4056891 KB4056892 KB4056894 KB4056895 KB4056897 KB4056898]


title 'Updates are installed'

control 'updates-1.0' do
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
