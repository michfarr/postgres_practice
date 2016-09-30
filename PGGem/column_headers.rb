#!/usr/bin/env ruby

require 'pg'

begin

  con = PG.connect dbname: 'test2db', user: 'mike'

  rs = con.exec 'SELECT * FROM Cars WHERE Id=0'
  puts 'There are %d columns ' % rs.nfields
  puts 'The column names are:'
  puts rs.fields

rescue PG::Error => e

  e.message

ensure

  rs.clear if rs
  con.close if con

end
