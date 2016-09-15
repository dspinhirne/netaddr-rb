#!/usr/bin/ruby

require_relative "../lib/NetAddr.rb"
require 'test/unit'

class TestNetAddr < Test::Unit::TestCase
	
	def test_sort_IPv4
		ips = []
		["10.0.0.0","1.1.1.1","0.0.0.0","10.1.10.1"].each do |net|
			ips.push(NetAddr::IPv4.parse(net))
		end
		sorted = NetAddr.sort_IPv4(ips)
		expect = [ips[2],ips[1],ips[0],ips[3]]
		assert_equal(expect, sorted)
	end
	
	def test_sort_IPv4Net
		nets = []
		["10.0.0.0/24", "1.0.0.0/24", "10.0.0.0/8", "192.168.1.0/26", "8.8.8.8/32"].each do |net|
			nets.push(NetAddr::IPv4Net.parse(net))
		end
		sorted = NetAddr.sort_IPv4Net(nets)
		expect = [nets[1],nets[4],nets[0],nets[2],nets[3]]
		assert_equal(expect, sorted)
	end
	
	def test_summ_IPv4Net
		nets = []
		["10.0.0.0/29", "10.0.0.8/30", "10.0.0.12/30", "10.0.0.16/28", "10.0.0.32/27", "10.0.0.64/26", "10.0.0.128/25"].each do |net|
			nets.push(NetAddr::IPv4Net.parse(net))
		end
		expect = ["10.0.0.0/24"]
		i = 0
		NetAddr.summ_IPv4Net(nets).each do |net|
			assert_equal(expect[i],net.to_s)
			i += 1
		end
		
		nets = []
		["10.0.0.0/24", "1.0.0.0/8", "3.4.5.6/32", "3.4.5.8/31", "0.0.0.0/0"].each do |net|
			nets.push(NetAddr::IPv4Net.parse(net))
		end
		expect = ["0.0.0.0/0"]
		i = 0
		NetAddr.summ_IPv4Net(nets).each do |net|
			assert_equal(expect[i],net.to_s)
			i += 1
		end
		
		nets = []
		["10.0.1.0/25", "10.0.1.0/26", "10.0.0.16/28", "10.0.0.32/27", "10.0.0.128/26", "10.0.0.192/26", "10.0.0.32/27"].each do |net|
			nets.push(NetAddr::IPv4Net.parse(net))
		end
		expect = ["10.0.0.16/28", "10.0.0.32/27", "10.0.0.128/25", "10.0.1.0/25"]
		i = 0
		NetAddr.summ_IPv4Net(nets).each do |net|
			assert_equal(expect[i],net.to_s)
			i += 1
		end
	end

end