module NetAddr
	
	#IPv4Net represents an IPv4 network. 
	class IPv4Net
		
		#arguments:
		#	* ip - an IPv4 object
		#	* m32 - a Mask32 object
		#
		#Throws ValidationError on error.
		def initialize(ip,m32)
			if (!ip.kind_of?(IPv4))
				raise ValidationError, "Expected an IPv4 object for 'ip' but got a #{ip.class}."
			elsif (!m32.kind_of?(Mask32))
				raise ValidationError, "Expected a Mask32 object for 'm32' but got a #{m32.class}."
			end
			@m32 = Mask32.new(m32.prefix)
			@base = IPv4.new(ip.addr & m32.mask)
		end

		# extended returns the IPv4Net in extended format (eg. x.x.x.x y.y.y.y)
		def extended()
			return @base.to_s + " " + NetAddr.intToIPv4(@m32.mask)
		end
		
		# to_s returns the IPv4Net as a String
		def to_s()
			return @base.to_s + @m32.to_s
		end
		
	end # end class IPv4Net
	
end # end module
