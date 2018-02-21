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

	end # class IPNet

end # module
