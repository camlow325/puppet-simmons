Facter.add('custom_fact_hostname') do
  setcode do
    Facter::Core::Execution.exec('/bin/hostname')
  end
end
