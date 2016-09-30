#!/usr/bin/env ruby

require 'pg'

begin

  con = PG.connect dbname: 'test2db', user: 'mike'

  stm = "SELECT $1::int AS a, $2::int AS b, $3::int AS c"
  rs = con.exec_params(stm, [1, 2, 3])

  puts rs.values

rescue PG::Error => e

  e.message

ensure

  rs.clear if rs
  con.close if con

end
