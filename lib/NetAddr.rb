require_relative "IPv4.rb"
require_relative "IPv4Net.rb"
require_relative "IPv6.rb"
require_relative "IPv6Net.rb"
require_relative "Mask32.rb"
require_relative "Mask128.rb"

module NetAddr
	# Constants
	
	# 32 bits worth of '1'
	F32 = 2**32-1
	
	# 128 bits worth of '1'
	F128 = 2**128-1
	

	# ValidationError is thrown when a method fails a validation test.
  class ValidationError < StandardError
  end
	
	# ipv4_prefix_len returns the prefix length needed to hold the number of IP addresses specified by "size".
	def ipv4_prefix_len(size)
		prefix_len = 32
		32.downto(0) do |i|
			hostbits = 32 - prefix_len
			max = 1 << hostbits
			if (size <= max)
				break
			end
			prefix_len -= 1
		end
		return prefix_len
	end
	module_function :ipv4_prefix_len
	
	# sort_IPv4 sorts a list of IPv4 objects in ascending order.
	# It will return a new list with any non IPv4 objects removed.
	def sort_IPv4(list)
		if ( !list.kind_of?(Array) )
			raise ArgumentError, "Expected an Array for 'list' but got a #{list.class}."
		end
		filtered = filter_IPv4(list)
		return quick_sort(filtered)
	end
	module_function :sort_IPv4
	
	# sort_IPv6 sorts a list of IPv6 objects in ascending order.
	# It will return a new list with any non IPv6 objects removed.
	def sort_IPv6(list)
		if ( !list.kind_of?(Array) )
			raise ArgumentError, "Expected an Array for 'list' but got a #{list.class}."
		end
		filtered = filter_IPv6(list)
		return quick_sort(filtered)
	end
	module_function :sort_IPv6
	
	# sort_IPv4Net sorts a list of IPv4Net objects in ascending order.
	# It will return a new list with any non IPv4Net objects removed.
	def sort_IPv4Net(list)
		if ( !list.kind_of?(Array) )
			raise ArgumentError, "Expected an Array for 'list' but got a #{list.class}."
		end
		filtered = filter_IPv4Net(list)
		return quick_sort(filtered)
	end
	module_function :sort_IPv4Net
	
	# sort_IPv6Net sorts a list of IPv6Net objects in ascending order.
	# It will return a new list with any non IPv6Net objects removed.
	def sort_IPv6Net(list)
		if ( !list.kind_of?(Array) )
			raise ArgumentError, "Expected an Array for 'list' but got a #{list.class}."
		end
		filtered = filter_IPv6Net(list)
		return quick_sort(filtered)
	end
	module_function :sort_IPv6Net
	
	# summ_IPv4Net summarizes a list of IPv4Net objects as much as possible.
	# It will return a new list with any non IPv4Net objects removed.
	def summ_IPv4Net(list)
		list = filter_IPv4Net(list)
		if (list.length>1)
			list = discard_subnets(list)
			return summ_peers(list)
		end
		return [].concat(list)
	end
	module_function :summ_IPv4Net
	
	# summ_IPv6Net summarizes a list of IPv6Net objects as much as possible.
	# It will return a new list with any non IPv6Net objects removed.
	def summ_IPv6Net(list)
		list = filter_IPv6Net(list)
		if (list.length>1)
			list = discard_subnets(list)
			return summ_peers(list)
		end
		return [].concat(list)
	end
	module_function :summ_IPv6Net
	
	protected
	
	# backfill generates subnets between given IPv4Net/IPv6Net and the limit address.
	# limit should be < ipnet. will create subnets up to and including limit.
	def backfill(ipnet,limit)
		nets = []
		cur = ipnet
		while true do
			net = cur.prev
			if (net == nil || net.network.addr < limit)
				break
			end
			nets.unshift(net)
			cur = net
		end
		return nets
	end
	module_function :backfill
	
	# discard_subnets returns a copy of the IPv4NetList with any entries which are subnets of other entries removed.
	def discard_subnets(list)
		unrelated = []
		supernets = []
		last = list[list.length-1]
		list.each do |net|
			rel = last.rel(net)
			if (!rel)
				unrelated.push(net)
			elsif (rel == -1) # last is subnet of net
				supernets.push(net)
			end
		end
		
		cleaned = []
		if (supernets.length > 0)
			cleaned = discard_subnets(supernets)
		else
			cleaned.push(last)
		end
		
		if (unrelated.length > 0)
			cleaned.concat( discard_subnets(unrelated) )
		end
		return cleaned
	end
	module_function :discard_subnets
	
	# fill returns a copy of the given Array, stripped of any networks which are not subnets of ipnet
	# and with any missing gaps filled in.
	def fill(ipnet,list)
		# sort & git rid of non subnets
		subs = []
		discard_subnets(list).each do |sub|
			r = ipnet.rel(sub)
			if (r == 1)
				subs.push(sub)
			end
		end
		subs = quick_sort(subs)
		
		filled = []
		if (subs.length > 0)
			# bottom fill if base missing
			base = ipnet.network.addr
			if (subs[0].network.addr != base)
				filled = backfill(subs[0],base)
			end
			
			# fill gaps
			sib = ipnet.next_sib()
			ceil = NetAddr::F32
			if (sib != nil)
				ceil = sib.network.addr
			end
			
			0.upto(subs.length-1) do |i|
				sub = subs[i]
				filled.push(sub)
				limit = ceil
				if (i+1 < subs.length)
					limit = subs[i+1].network.addr
				end
				filled.concat( fwdfill(sub,limit) )
			end
		end
		return filled
	end
	module_function :fill
	
	# filter_IPv4 returns a copy of list with only IPv4 objects
	def filter_IPv4(list)
		filtered = []
		list.each do |ip|
			if (ip.kind_of?(IPv4))
				filtered.push(ip)
			end
		end
		return filtered
	end
	module_function :filter_IPv4
	
	# filter_IPv4Net returns a copy of list with only IPv4Net objects
	def filter_IPv4Net(list)
		filtered = []
		list.each do |ip|
			if (ip.kind_of?(IPv4Net))
				filtered.push(ip)
			end
		end
		return filtered
	end
	module_function :filter_IPv4Net
	
	# filter_IPv6 returns a copy of list with only IPv6 objects
	def filter_IPv6(list)
		filtered = []
		list.each do |ip|
			if (ip.kind_of?(IPv6))
				filtered.push(ip)
			end
		end
		return filtered
	end
	module_function :filter_IPv6
	
	# filter_IPv6Net returns a copy of list with only IPv4Net objects
	def filter_IPv6Net(list)
		filtered = []
		list.each do |ip|
			if (ip.kind_of?(IPv6Net))
				filtered.push(ip)
			end
		end
		return filtered
	end
	module_function :filter_IPv6Net
	
	# fwdfill returns subnets between given IPv4Net/IPv6Nett and the limit address.
	# limit should be > ipnet. will create subnets up to limit.
	def fwdfill(ipnet,limit)
		nets = []
		cur = ipnet
		while true do
			net = cur.next
			if (net == nil || net.network.addr >= limit)
				break
			end
			nets.push(net)
			cur = net
		end
		return nets
	end
	module_function :fwdfill
	
	# int_to_IPv4 converts an Integer into an IPv4 address String
	def int_to_IPv4(i)
		octets = []
		3.downto(0) do |x|
			octet = (i >> 8*x) & 0xFF 
			octets.push(octet.to_s)
		end
		return octets.join('.')
	end
	module_function :int_to_IPv4
	
	# parse_IPv4 parses an IPv4 address String into an Integer
	def parse_IPv4(ip)
	# check that only valid characters are present
		if (ip =~ /[^0-9\.]/)
			raise ValidationError, "#{ip} contains invalid characters."
		end
		
		ip.strip!
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
	module_function :parse_IPv4
	
	# parse_IPv6 parses an IPv6 address String into an Integer
	def parse_IPv6(ip)
	# check that only valid characters are present
		if (ip =~ /[^0-9a-fA-F\:]/)
			raise ValidationError, "#{ip} contains invalid characters."
		end
		
		ip.strip!
		if (ip == "::")
			return 0 # zero address
		end
		words = []
		if (ip.include?("::")) # short format
			if (ip =~ /:{3,}/) # make sure only i dont have ":::"
				raise ValidationError, "#{ip} contains invalid field separator."
			end
			if (ip.scan(/::/).length != 1)
				raise ValidationError, "#{ip} contains multiple '::' sequences."
			end
			
			halves = ip.split("::")
			if (halves[0] == nil) # cases such as ::1
				halves[0] = "0"
			end
			if (halves[1] == nil) # cases such as 1::
				halves[1] = "0"
			end
			upHalf = halves[0].split(":")
			loHalf = halves[1].split(":")
			numWords = upHalf.length + loHalf.length
			if (numWords > 6)
				raise ValidationError, "#{ip} is too long."
			end
			words = upHalf
			(8-numWords).downto(1) do |i|
				words.push("0")
			end
			words.concat(loHalf)
		else
			words = ip.split(":")
			if (words.length > 8)
			   raise ValidationError, "#{ip} is too long."
			elsif (words.length < 8)
				raise ValidationError, "#{ip} is too short."
			end
		end
		
		ipInt = 0
		i = 8
		words.each do |word|
			i -= 1
			word = word.to_i(16) << (16*i)
			ipInt = ipInt | word
		end
		
		return ipInt
	end
	module_function :parse_IPv6
		
	# quick_sort will return a sorted copy of the provided Array.
	# The array must contain only objects which implement a cmp method and which are comparable to each other.
	def quick_sort(list)
		if (list.length <= 1)
			return [].concat(list)
		end
		
		final_list = []
		lt_list = []
		gt_list = []
		eq_list = []
		pivot = list[list.length-1]
		list.each do |ip|
			cmp = pivot.cmp(ip)
			if (cmp == 1)
				lt_list.push(ip)
			elsif (cmp == -1)
				gt_list.push(ip)
			else
				eq_list.push(ip)
			end
		end
		final_list.concat( quick_sort(lt_list) )
		final_list.concat(eq_list)
		final_list.concat( quick_sort(gt_list) )
		return final_list
	end
	module_function :quick_sort
	
	# summ_peers returns a copy of the list with any merge-able subnets summ'd together.
	def summ_peers(list)
		summd = quick_sort(list)
		while true do
			list_len = summd.length
			last = list_len - 1
			tmp_list = []
			i = 0
			while (i < list_len) do
				net = summd[i]
				next_net = i+1
				if (i != last)
					# if this net and next_net summarize then discard them & keep summary
					new_net = net.summ(summd[next_net])
					if (new_net) # can summ. keep summary
						tmp_list.push(new_net)
						i += 1 # skip next_net
					else # cant summ. keep existing
						tmp_list.push(net)
					end
				else
					tmp_list.push(net) # keep last
				end
				i += 1
			end
			
			# stop when list stops getting shorter
			if (tmp_list.length == list_len)
				break
			end
			summd = tmp_list
		end
		return summd
	end
	module_function :summ_peers

end # end module