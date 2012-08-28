#!/usr/bin/env ruby
require 'benchmark'

N = 100

__DIR__ = File.dirname(File.expand_path(__FILE__))
Dir.chdir(__DIR__)

puts "For #{N} iterations:"

#puts `./direnv-export`

def run(cmd)
  `#{cmd} 2>/dev/null`
  if $?.exitstatus > 0
    raise "`#{cmd}` exited with #{$?.inspect}"
  end
end

def bench(cmd)
  N.times{ run(cmd) }
end

Benchmark.bm(30) do |x|
  x.report('empty iterations') do
    bench ''
  end

  puts

  x.report('bash   startup') do
    bench %[bash -c 'echo FOO']
  end

  x.report('bash   existing env') do
    bench "eval `./direnv-export`"
  end

  # Remove current env for the next benchmarks
  %w[DIRENV_BACKUP DIRENV_DIR DIRENV_MTIME GEM_HOM BUNDLE_BIN].each do |k|
    ENV[k] = nil
  end

  Dir.chdir('/') do
    x.report('bash   no env') do
      bench "eval `#{__DIR__}/direnv-export`"
    end
  end

  puts

  x.report('ruby   startup') do
    bench %[ruby -e 'puts "FOO"']
  end

  x.report('ruby   dump') do
    bench "./direnv-dump"
  end

  x.report('ruby   diff + dump') do
    bench "./direnv-diff `./direnv-dump`"
  end

  x.report('ruby   export') do
    bench "./direnv-export"
  end

  x.report('ruby   eval + export') do
    bench "eval `./direnv-export 2>/dev/null`"
  end

  puts

  x.report('python startup') do
    bench %[python -c 'print "FOO"']
  end

  x.report('python dump') do
    bench "./direnv-dump.py"
  end

  x.report('python diff + dump') do
    bench "./direnv-diff.py `./direnv-dump.py`"
  end

  puts

  x.report('perl   startup') do
    bench %[perl -e 'print "FOO\n"']
  end

  x.report('perl   dump (using Storable)') do
    bench "./direnv-dump.pl"
  end

  x.report('perl   dump (using Dumper)') do
    bench "./direnv-dump-dumper.pl"
  end

  puts

  arch=`uname`.strip + '-' + `uname -m`.strip
  if File.exist?("direnv-diff-#{arch}")
    cmd = "./direnv-dump-#{arch}"
    x.report('golang dump') do
      bench cmd
    end

    cmd = "./direnv-diff-#{arch} `./direnv-dump-#{arch}`"
    x.report('golang diff + dump') do
      bench cmd
    end
  else
    puts "You first need to compile the golang port"
  end
end
