module Puppet::Parser::Functions
  newfunction(:rand_text, :type => :rvalue) do |args|
    rand(100000).to_s + ' ' + Time.new.to_s
  end
end
