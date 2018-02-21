module NetAddr

	# IPNet represents an IP network. It must be subclassed by IPv*Net
	class IPNet

		# Yield all IP of the network and return self.
		# Return an enumerator if no block are given.
		def each()
			return to_enum(:each) unless block_given?
			0.upto(self.len - 1) do |idx|
				yield nth(idx)
			end
			return self
		end

		# Yield all IP of the network that are host IP and return self.
		# Return an enumerator if no block are given.
		def each_host()
			return to_enum(:each_host) unless block_given?
			1.upto(self.len - 2) do |idx|
				yield nth(idx)
			end
			return self
		end

		# Yield of subnet of the given length and return self.
		# Return an enumerator if no block are given.
		# Never yield if prefix_len is invalid.
		#
		# arguments:
		# * prefix_len prefix of the new network.
		def each_subnet(prefix_len)
			return to_enum(:each_subnet, prefix_len) unless block_given?
			count = self.subnet_count(prefix_len)
			unless count == 0 then
				0.upto(count - 1) do |idx|
					yield nth_subnet(prefix_len, idx)
				end
			end
			return self
		end

	end # class IPNet

end # module
