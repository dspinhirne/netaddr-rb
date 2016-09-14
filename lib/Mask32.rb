module NetAddr
	
	#Mask32 represents an 32-bit netmask. 
	class Mask32
		attr_reader :mask
		attr_reader :prefix
		
		#arguments:
		# * prefixLen - an integer representing a prefix length for a 32-bit netmask. valid values are 0-32.
		#
		#Throws ValidationError on error.
		def initialize(prefixLen)
			if (!prefixLen.kind_of?(Integer))
				raise ValidationError, "Expected an Integer for 'prefixLen' but got a #{prefixLen.class}."
			elsif ( (prefixLen < 0) || (prefixLen > 32) )
				raise ValidationError, "#{prefixLen} must be in the range of 0-32."
			end
			@prefix = prefixLen
			@mask = 0xffffffff ^ (0xffffffff >> @prefix)
		end
		
		# extended returns the Mask32 in extended format (eg. x.x.x.x)
		def extended()
			NetAddr.intToIPv4(@mask)
		end
		
		# to_s returns the Mask32 as a String
		def to_s()
			return "/#{@prefix}"
		end
		
	end # end class Mask32
	
end # end module
