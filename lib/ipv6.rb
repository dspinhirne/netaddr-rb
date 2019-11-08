module NetAddr
	
	#IPv6 represents a single IPv6 address. 
	class IPv6
		# addr is the Integer representation of this IP address
		attr_reader :addr
		
		#Create an IPv6 from an Integer. Must be between 0 and 2**128-1.
		#Throws ValidationError on error.
		def initialize(i)
			if (!i.kind_of?(Integer))
				raise ValidationError, "Expected an Integer for 'i' but got a #{i.class}."
			elsif ( (i < 0) || (i > NetAddr::F128) )
				raise ValidationError, "#{i} is out of bounds for IPv6."
			end
			@addr = i
		end
		
		# parse will create an IPv6 from its string representation (ie. "1::").
		# Throws ValidationError on error.
		def IPv6.parse(ip)
			ip = ip.strip
			i = Util.parse_IPv6(ip)
			return IPv6.new(i)
		end
		
		# cmp compares equality with another IPv6. Return:
		# * 1 if this IPv6 is numerically greater
		# * 0 if the two are equal
		# * -1 if this IPv6 is numerically less
		def cmp(other)
			if (!other.kind_of?(IPv6))
				raise ArgumentError, "Expected an IPv6 object for 'other' but got a #{other.class}."
			end
			if (self.addr > other.addr)
				return 1
			elsif (self.addr < other.addr)
				return -1
			end
			return 0
		end
		
		# ipv4 generates an IPv4 address from an IPv6 address. The IPv4 address is generated based on
		# the mechanism described by RFC 6052 for /96 IPv4-embedded IPv6 addresses.
		def ipv4()
			i = @addr & NetAddr::F32
			return IPv4.new(i)
		end
		
		# long returns the IPv6 as a string in long (uncompressed) format
		def long()
			words = []
			7.downto(0) do |x|
				word = (@addr >> 16*x) & 0xffff 
				words.push( word.to_s(16).rjust(4, "0") )
			end
			return words.join(':')
		end
		
		# next returns the next consecutive IPv6 or nil if the address space is exceeded
		def next()
			if (self.addr == NetAddr::F128)
				return nil
			end
			return IPv6.new(self.addr + 1)
		end
		
		# prev returns the preceding IPv6 or nil if this is 0.0.0.0
		def prev()
			if (self.addr == 0)
				return nil
			end
			return IPv6.new(self.addr - 1)
		end
		
		# to_net returns the IPv6 as a IPv6Net
		def to_net()
			NetAddr::IPv6Net.new(self,nil)
		end
		
		# to_s returns the IPv6 as a String in zero-compressed format (per rfc5952).
		def to_s()
			hexStr = ["","","","","","","",""]
			zeroStart, consec0, finalStart, finalLen = -1,0,-1,0
			8.times do |i|
				# capture 2-byte word
				shift = 112 - 16*i
				wd = (self.addr >> shift) & 0xffff
				hexStr[i] = wd.to_s(16)
				
				# capture count of consecutive zeros
				if (wd == 0)
					if (zeroStart == -1)
						zeroStart = i
					end
					consec0 += 1
				end
				
				# test for longest consecutive zeros when non-zero encountered or we're at the end
				if (wd != 0 || i == 7)
					if (consec0 > finalStart+finalLen-1)
						finalStart = zeroStart
						finalLen = consec0
					end
					zeroStart = -1
					consec0 = 0
				end
			end
			
			# compress if we've found a series of 0 words in a row
			if (finalStart != -1)
				head = hexStr[0,finalStart].join(":")
				tailStart = finalStart + finalLen 
				tail = hexStr[tailStart..7].join(":")
				return head + "::" + tail
			end
			return hexStr.join(":")
		end
		
		# version returns "6" for IPv6
		def version()
			return 6
		end
		
	end # end class IPv6
	
end # end module
