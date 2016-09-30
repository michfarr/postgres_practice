#!/usr/bin/env ruby

require 'pg'

begin

  con = PG.connect dbname: 'test2db', user: 'mike'

  rs = con.exec 'SELECT VERSION()'
  puts rs.getvalue 0,0

rescue PG::Error => e
  
  puts e.message

ensure

  con.close if con

end
