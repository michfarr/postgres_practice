#!/usr/bin/env ruby

require 'pg'

begin

  con = PG.connect dbname: 'test2db', user: 'mike'

  rs = con.exec "SELECT table_name FROM information_schema.tables
      WHERE table_schema = 'public'"

  rs.each do |row|
    puts row['table_name']
  end

rescue PG::ERROR => e

  puts e.message

ensure

  rs.clear if rs
  con.close if con

end
