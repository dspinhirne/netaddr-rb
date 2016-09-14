module NetAddr
	
	#IPv4Net represents an IPv4 network. 
	class IPv4Net
		
		#arguments:
		#* ip - an IPv4 object
		#* m32 - a Mask32 object. will default to a /32 if nil
		def initialize(ip,m32)
			if (!ip.kind_of?(IPv4))
				raise ArgumentError, "Expected an IPv4 object for 'ip' but got a #{ip.class}."
			elsif (m32 != nil && !m32.kind_of?(Mask32))
				raise ArgumentError, "Expected a Mask32 object for 'm32' but got a #{m32.class}."
			end
			
			if (m32 == nil)
				m32 = Mask32.new(32)
			end
			@m32 = m32
			@base = IPv4.new(ip.addr & m32.mask)
		end
		
		# parse will create an IPv4Net from its string representation. Will default to a /32 netmask if not specified.
		# Throws ValidationError on error.
		def IPv4Net.parse(net)
			net.strip!
			if (net.include?("/")) # cidr format
				addr,mask = net.split("/")
			elsif (net.include?(" ") ) # extended format
				addr,mask = net.split(' ')
			else
				addr = net
				mask = "32"
			end
			ip = IPv4.parse(addr)
			m32 = Mask32.parse(mask)
			return IPv4Net.new(ip,m32)
		end

		# extended returns the IPv4Net in extended format (eg. x.x.x.x y.y.y.y)
		def extended()
			return @base.to_s + " " + NetAddr.intToIPv4(@m32.mask)
		end
		
		#cmp compares equality with another IPv4Net. Return:
		#* 1 if this IPv4Net is numerically greater
		#* 0 if the two are equal
		#* -1 if this IPv4Net is numerically less
		#
		#The comparasin is initially performed on using the cmp() method of the network address, however, in cases where the network #addresses are identical then the netmasks will be compared with the cmp() method of the netmask. 
		def cmp(other)
			if (!other.kind_of?(IPv4Net))
				raise ArgumentError, "Expected an IPv4Net object for 'other' but got a #{other.class}."
			end
			cmp = self.network.cmp(other.network)
			if (cmp != 0)
				return cmp
			end
			return self.netmask.cmp(other.netmask)
		end
		
		# netmask returns the Mask32 object representing the netmask for this network
		def netmask()
			@m32
		end
			
		# network returns the IPv4 object representing the network address
		def network()
			@base
		end
		
		# to_s returns the IPv4Net as a String
		def to_s()
			return @base.to_s + @m32.to_s
		end
		
	end # end class IPv4Net
	
end # end module
