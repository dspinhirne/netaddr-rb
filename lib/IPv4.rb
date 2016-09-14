module NetAddr
	
	#IPv4 represents a single IPv4 address. 
	class IPv4
		attr_reader :addr
		
		#arguments:
		#	* ip - Integer representing an ip address. Must be between 0 and 2**32-1.
		#
		#Throws ValidationError on error.
		def initialize(i)
			if (!i.kind_of?(Integer))
				raise ValidationError, "Expected an Integer for 'i' but got a #{i.class}."
			elsif ( (i < 0) || (i > 2**32-1) )
				raise ValidationError, "#{i} is out of bounds for IPv4."
			end
			@addr = i
		end
		
		# parse will create an IPv4 from its string representation.
		# arguments:
		#	* ip - String representing an ip address (ie. "192.168.1.1").
		#
		#	Throws ValidationError on error.
		def IPv4.parse(ip)
			i = NetAddr.parseIPv4(ip)
			return IPv4.new(i)
		end
		
		# to_s returns the IPv4 as a String
		def to_s()
			NetAddr.intToIPv4(@addr)
		end
		
	end # end class IPv4
	
end # end module
