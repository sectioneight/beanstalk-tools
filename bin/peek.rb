#!/usr/bin/env ruby

require 'rubygems'
require 'beanstalk-client'

BS=Beanstalk::Pool.new $*

def abbrev(code, to=70)
  if code && code.length > to
    code.slice(0, to-3) + "..."
  else
    code
  end
end

interrupted = false
trap('SIGINT') { interrupted = true }

loop do
  job = BS.reserve
  code = case job.ybody
  when Hash
    job.ybody[:code]
  else
    job.ybody.inspect
  end
  puts code
  job.release(job.pri, 60)

  break if interrupted
end
