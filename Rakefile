# frozen_string_literal: true

require 'rake/testtask'

task default: %i[test]

Rake::TestTask.new(:test) do |t|
  t.test_files = FileList['test/**/*_test.rb']
end
