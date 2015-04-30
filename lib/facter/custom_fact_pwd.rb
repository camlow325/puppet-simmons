Facter.add('custom_fact_pwd') do
  setcode do
    Facter::Core::Execution.exec('/bin/pwd')
  end
end
