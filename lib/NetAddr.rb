require_relative "IPv4.rb"
require_relative "IPv4Net.rb"
require_relative "Mask32.rb"

module NetAddr

	# ValidationError is thrown when a method fails a validation test.
  class ValidationError < StandardError
  end
	
	# intToIPv4 converts an Integer into an ipv4 address string
	def intToIPv4(i)
		octets = []
		3.downto(0) do |x|
			octet = (i >> 8*x) & 0xFF 
			octets.push(octet.to_s)
		end
		return octets.join('.')
	end
	module_function :intToIPv4
	
	# parseIPv4 parses an IPv4 address String into an Integer
	def parseIPv4(ip)
		# check that only valid characters are present
			if (ip =~ /[^0-9\.]/)
				raise ValidationError, "#{ip} contains invalid characters."
			end
			
			octets = ip.split('.')
			if (octets.length != 4)
				raise ValidationError, "IPv4 requires (4) octets."
			end

			ipInt = 0
			i = 4
			octets.each do |octet|
				octetI = octet.to_i()
				if ( (octetI < 0) || (octetI >= 256) )
					raise ValidationError, "#{ip} is out of bounds for IPv4."
				end
				i -= 1 
				ipInt = ipInt | (octetI << 8*i)
			end
			return ipInt
		end
		module_function :parseIPv4

end