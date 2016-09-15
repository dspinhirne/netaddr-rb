#!/usr/bin/ruby

require_relative "../lib/NetAddr.rb"
require 'test/unit'

class TestIPv4Net < Test::Unit::TestCase
	def test_new
		ip = NetAddr::IPv4.parse("128.0.0.1")
		m32 = NetAddr::Mask32.new(24)
		net = NetAddr::IPv4Net.new(ip,m32)
		assert_equal("128.0.0.0/24", net.to_s)

		net = NetAddr::IPv4Net.new(ip,nil)
		assert_equal("128.0.0.1/32", net.to_s)
	end
	
	def test_parse
		assert_equal("128.0.0.0/24", NetAddr::IPv4Net.parse("128.0.0.1/24").to_s)
		assert_equal("128.0.0.0/24", NetAddr::IPv4Net.parse("128.0.0.1 255.255.255.0").to_s)
		assert_equal("128.0.0.1/32", NetAddr::IPv4Net.parse("128.0.0.1").to_s) # default /32
	end
	
	def test_cmp
		net1 = NetAddr::IPv4Net.parse("1.1.1.0/24")
		net2 = NetAddr::IPv4Net.parse("1.1.0.0/24")
		net3 =NetAddr::IPv4Net.parse("1.1.2.0/24")
		net4 = NetAddr::IPv4Net.parse("1.1.1.0/25")
		net5 = NetAddr::IPv4Net.parse("1.1.1.0/24")
		
		assert_equal(1, net1.cmp(net2)) # ip less
		assert_equal(-1, net1.cmp(net3))# ip greater
		assert_equal(-1, net4.cmp(net1)) # ip eq, mask less
		assert_equal(1, net1.cmp(net4)) # ip eq, mask greater
		assert_equal(0, net1.cmp(net5)) # eq
	end
	
	def test_extended
		net = NetAddr::IPv4Net.parse("128.0.0.1/24")
		assert_equal("128.0.0.0 255.255.255.0", net.extended)
	end
	
	def test_len
		net1 = NetAddr::IPv4Net.parse("1.1.1.0/24")
		assert_equal(256, net1.len())
	end
	
	def test_next
		assert_equal("1.0.0.2/31", NetAddr::IPv4Net.parse("1.0.0.0/31").next.to_s)
		assert_equal("1.0.0.8/29", NetAddr::IPv4Net.parse("1.0.0.4/30").next.to_s)
		assert_equal("1.0.0.16/28", NetAddr::IPv4Net.parse("1.0.0.8/29").next.to_s)
	end
	
	def test_next_sib
		assert_equal("255.255.255.64/26", NetAddr::IPv4Net.parse("255.255.255.0/26").next_sib.to_s)
		assert_equal("255.255.255.128/26", NetAddr::IPv4Net.parse("255.255.255.64/26").next_sib.to_s)
		assert_equal("255.255.255.192/26", NetAddr::IPv4Net.parse("255.255.255.128/26").next_sib.to_s)
		assert_nil(NetAddr::IPv4Net.parse("255.255.255.192/26").next_sib)
	end
	
	def test_nth
		assert_equal("1.1.1.1", NetAddr::IPv4Net.parse("1.1.1.0/26").nth(1).to_s)
		assert_nil(NetAddr::IPv4Net.parse("1.1.1.0/26").nth(64))
	end
	
	def test_nth_subnet
		assert_equal("1.1.1.0/26", NetAddr::IPv4Net.parse("1.1.1.0/24").nth_subnet(26,0).to_s)
		assert_equal("1.1.1.64/26", NetAddr::IPv4Net.parse("1.1.1.0/24").nth_subnet(26,1).to_s)
		assert_nil(NetAddr::IPv4Net.parse("1.1.1.0/24").nth_subnet(26,4))
		assert_nil(NetAddr::IPv4Net.parse("1.1.1.0/24").nth_subnet(26,-1))
		assert_nil(NetAddr::IPv4Net.parse("1.1.1.0/24").nth_subnet(24,0))
	end
	
	def test_prev
		assert_equal("1.0.0.0/29", NetAddr::IPv4Net.parse("1.0.0.8/30").prev.to_s)
		assert_equal("1.0.0.128/26", NetAddr::IPv4Net.parse("1.0.0.192/26").prev.to_s)
		assert_equal("1.0.0.0/25", NetAddr::IPv4Net.parse("1.0.0.128/26").prev.to_s)
	end
	
	def test_prev_sib
		assert_equal("0.0.0.64/26", NetAddr::IPv4Net.parse("0.0.0.128/26").prev_sib.to_s)
		assert_equal("0.0.0.0/26", NetAddr::IPv4Net.parse("0.0.0.64/26").prev_sib.to_s)
		assert_nil(NetAddr::IPv4Net.parse("0.0.0.0/26").prev_sib)
	end
	
	def test_rel
		net1 = NetAddr::IPv4Net.parse("1.1.1.0/24")
		net2 = NetAddr::IPv4Net.parse("1.1.1.0/25")
		net3 = NetAddr::IPv4Net.parse("1.1.1.128/25")
		net4 = NetAddr::IPv4Net.parse("1.1.1.0/25")
		assert_equal(1, net1.rel(net2)) # net eq, supernet
		assert_equal(-1, net2.rel(net1)) # net eq, subnet
		assert_equal(0, net2.rel(net2)) # eq
		assert_equal(1, net1.rel(net3)) # net ne, supernet
		assert_equal(-1, net3.rel(net1)) # net ne, subnet
		assert_nil(net3.rel(net4)) # unrelated
	end
	
	def test_resize
		assert_equal("1.1.1.0/24", NetAddr::IPv4Net.parse("1.1.1.0/26").resize(24).to_s)
	end
	
	def test_subnet_count
		assert_equal(2, NetAddr::IPv4Net.parse("1.1.1.0/24").subnet_count(25))
		assert_equal(0, NetAddr::IPv4Net.parse("1.1.1.0/24").subnet_count(24))
		assert_equal(0, NetAddr::IPv4Net.parse("1.1.1.0/24").subnet_count(33))
		assert_equal(0, NetAddr::IPv4Net.parse("0.0.0.0/0").subnet_count(32))
	end
	
end