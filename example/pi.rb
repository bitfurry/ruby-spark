#!/bin/ruby

lib = File.expand_path(File.dirname(__FILE__) + '/../lib')
$LOAD_PATH.unshift(lib) if File.directory?(lib) && !$LOAD_PATH.include?(lib)

require "ruby-spark"

Spark.disable_log
Spark.start

slices = 3
n = 100000 * slices

def map(_)
  x = rand * 2 - 1
  y = rand * 2 - 1

  if x**2 + y**2 < 1
    return 1
  else
    return 0
  end
end

rdd = Spark.context.parallelize(1..n, slices, serializer: "oj")
rdd = rdd.map(:map)

puts "Pi is roughly %f" % (4.0 * rdd.sum / n)