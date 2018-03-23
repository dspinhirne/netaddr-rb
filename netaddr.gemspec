# build install with:  gem build netaddr.gemspec
# install with: netaddr*.gem
Gem::Specification.new do |s|
	s.name      =   "netaddr"
	s.version   =   "2.0.3"
	s.date      =   "2018-03-23"
	s.author    =   "Dustin Spinhirne"
	s.summary   =   "A Ruby library for performing calculations on IPv4 and IPv6 subnets."
	s.homepage  =   "https://github.com/dspinhirne/netaddr-rb"
	s.files = Dir['lib/*.rb'] + Dir['test/*']
	s.require_paths = ['lib']
	s.extra_rdoc_files  =   ["README.md", "LICENSE"]
	s.license  =   'Apache-2.0'
end 

