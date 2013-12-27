
module Puppet::Parser::Functions
  newfunction(:validate_ext, :type  => :rvalue, :doc => <<-EOS
Raises an error if file ext does not equal provided value
  EOS
  ) do |args|
    unless args.length == 2
      raise(Puppet::ParseError, "validate_ext: Wrong number of arguments " +
        "given (#{args.size} for 2")
    end

    path = args[0]
    ext = args[1]

    if File.extname(path) != ext
      raise Puppet::Error ,("#{arg.inspect} does not end in correct value.")
    end
  end
end