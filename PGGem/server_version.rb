#!/usr/bin/env ruby

require 'pg'

begin

  con = PG.connect dbname: 'test2db', user: 'mike'
  puts con.server_version

rescue PG::Error => e

  puts e.message

ensure

  con.close if con

end
