# build install with:  gem build netaddr.gemspec
# install with: netaddr*.gem
Gem::Specification.new do |s|
    s.name      =   "netaddr"
    s.version   =   "2.0"
    s.date      =   "2016-09-13"
    s.author    =   "Dustin Spinhirne"
    s.summary   =   "A Ruby library for performing calculations on IPv4 and IPv6 subnets"
    s.files = Dir['lib/*.rb'] + Dir['test/*']
    s.require_paths = ['lib']
    s.extra_rdoc_files  =   ["README.md", "LICENSE"]
    s.license  =   'Apache-2.0'
end 

