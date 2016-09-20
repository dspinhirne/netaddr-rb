module NetAddr
	
	#IPv6Net represents an IPv6 network. 
	class IPv6Net
		
		#arguments:
		#* ip - an IPv6 object
		#* m128 - a Mask128 object. will default to a /64 if nil
		def initialize(ip,m128)
			if (!ip.kind_of?(IPv6))
				raise ArgumentError, "Expected an IPv6 object for 'ip' but got a #{ip.class}."
			elsif (m128 != nil && !m128.kind_of?(Mask128))
				raise ArgumentError, "Expected a Mask128 object for 'm128' but got a #{m128.class}."
			end
			
			if (m128 == nil)
				if (ip.addr != 0)
					m128 = Mask128.new(64) # use /64 mask per rfc 4291
				else
					m128 = Mask128.new(128) # use /128 mask per rfc 4291
				end
			end
			@m128 = m128
			@base = IPv6.new(ip.addr & m128.mask)
		end

	end # end class IPv6Net
	
end # end module
