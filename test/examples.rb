#!/usr/bin/ruby

require_relative "../lib/NetAddr.rb"
require 'test/unit'

# Testable examples on how to use NetAddr
class NetAddrExamples < Test::Unit::TestCase
	
	# IPv4
	def test_IPv4_examples
		puts "\n*** Examples using IPv4 ***\n"
		
		puts "Creating IPv4Net: '10.0.0.0/24'"
		net = NetAddr::IPv4Net.parse("10.0.0.0/24")
		assert_not_nil(net)
		
		puts "\nRendering as a String: " + net.to_s
		assert_equal("10.0.0.0/24", net.to_s)
		
		puts "\nIterating its /26 subnets:"
		expect = ["10.0.0.0/26","10.0.0.64/26","10.0.0.128/26","10.0.0.192/26"]
		0.upto(net.subnet_count(26) - 1) do |i|
			subnet = net.nth_subnet(26,i)
			assert_equal(expect[i], subnet.to_s)
			puts "  " + subnet.to_s
		end
		
		puts "\nIts 3rd /30 subnet:"
		subnet30 = net.nth_subnet(30,2)
		assert_equal("10.0.0.8/30", subnet30.to_s)
		puts "  " + subnet30.to_s
		
		puts "\nIterating the IPs of the /30"
		expect = ["10.0.0.8","10.0.0.9","10.0.0.10","10.0.0.11"]
		0.upto(subnet30.len - 1) do |i|
			ip = subnet30.nth(i)
			assert_equal(expect[i], ip.to_s)
			puts "  " + ip.to_s
		end
		
		puts "\n Given the 3rd /30 of 10.0.0.0/24, fill in the holes:"
		expect = ["10.0.0.0/29","10.0.0.8/30","10.0.0.12/30","10.0.0.16/28","10.0.0.32/27","10.0.0.64/26","10.0.0.128/25"]
		i = 0
		net.fill([subnet30]).each do |subnet|
			puts "  " + subnet.to_s
			assert_equal(expect[i], subnet.to_s)
			i+=1
		end
		
		list = ["10.0.1.0/24", "10.0.0.0/25", "10.0.0.128/26","10.0.2.0/24", "10.0.0.192/26",]
		puts "\n Summarizing this list of networks: " + list.to_s
		nets = []
		list.each do |net|
			nets.push(NetAddr::IPv4Net.parse(net))
		end
		expect = ["10.0.0.0/23", "10.0.2.0/24",]
		i = 0
		NetAddr.summ_IPv4Net(nets).each do |net|
			puts "  " + net.to_s
			assert_equal(expect[i],net.to_s)
			i += 1
		end
		
	end
	
end