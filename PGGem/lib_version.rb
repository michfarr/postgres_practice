#!/usr/bin/env ruby

require 'pg'

puts 'Version of libpg: ' + PG.library_version.to_s
