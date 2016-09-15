require_relative "IPv4.rb"
require_relative "IPv4Net.rb"
require_relative "Mask32.rb"

module NetAddr

	# ValidationError is thrown when a method fails a validation test.
  class ValidationError < StandardError
  end
	
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
	
	# summ_IPv4Netr summarizes a list of IPv4Net objects as much as possible.
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
	
	protected
	
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