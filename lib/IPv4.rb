module NetAddr
	
	#IPv4 represents a single IPv4 address. 
	class IPv4
		# addr is the Integer representation of this IP address
		attr_reader :addr
		
		#Create an IPv4 from an Integer. Must be between 0 and 2**32-1.
		#Throws ValidationError on error.
		def initialize(i)
			if (!i.kind_of?(Integer))
				raise ValidationError, "Expected an Integer for 'i' but got a #{i.class}."
			elsif ( (i < 0) || (i > 2**32-1) )
				raise ValidationError, "#{i} is out of bounds for IPv4."
			end
			@addr = i
		end
		
		# parse will create an IPv4 from its string representation (ie. "192.168.1.1").
		# Throws ValidationError on error.
		def IPv4.parse(ip)
			ip.strip!
			i = NetAddr.parse_IPv4(ip)
			return IPv4.new(i)
		end
		
		#cmp compares equality with another IPv4. Return:
		#* 1 if this IPv4 is numerically greater
		#* 0 if the two are equal
		#* -1 if this IPv4 is numerically less
		def cmp(other)
			if (!other.kind_of?(IPv4))
				raise ArgumentError, "Expected an IPv4 object for 'other' but got a #{other.class}."
			end
			if (self.addr > other.addr)
				return 1
			elsif (self.addr < other.addr)
				return -1
			end
			return 0
		end
		
		# next returns the next consecutive IPv4 or nil if the address space is exceeded
		def next()
			if (self.addr == 0xffffffff)
				return nil
			end
			return IPv4.new(self.addr + 1)
		end
		
		# prev returns the preceding IPv4 or nil if this is 0.0.0.0
		def prev()
			if (self.addr == 0)
				return nil
			end
			return IPv4.new(self.addr - 1)
		end
		
		# to_s returns the IPv4 as a String
		def to_s()
			NetAddr.int_to_IPv4(@addr)
		end
		
	end # end class IPv4
	
end # end module
