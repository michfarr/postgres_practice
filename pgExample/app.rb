#!/usr/bin/env ruby

require 'pg'

# TOP LEVEL COMMENT
class PostgresDirect
  # Create the connection instance
  def connect
    @conn = PG.connect(
      dbname: 'Test',
      user: 'mike'
    )
  end

  # Create our test table
  # (Assumes it doesn't already exist)
  def create_user_table
    @conn.exec("CREATE TABLE users (id serial NOT NULL, name character varying(255), CONSTRAINT users_pkey PRIMARY KEY (id)) WITH (OIDS=FALSE);");
  end

  # When we're done, we're goint to drop our test table.
  def drop_user_table
    @conn.exec("DROP TABLE users")
  end

  # Prepared statements prevent SQL injection attacks.  However, 
  # for the connection, the prepared statements live and apparent 
  # cannot be removed, at least not very easily.  There is
  # apparently a significant performance improvement using prepared statements.
  def prepare_insert_user_statement
    @conn.prepare("insert_user", "INSERT INTO users (id, name) values ($1, $2)")
  end

  # Add a user with the prepared statement
  def add_user(id, username)
    @conn.exec_prepared("insert_user", [id, username])
  end

  # Get our data back
  def query_user_table
    @conn.exec("SELECT * FROM users") do |result|
      result.each do |row|
        yield row if block_given?
      end
    end
  end

  # Disconnect the back-end connection
  def disconnect
    @conn.close
  end
end

def main
  p = PostgresDirect.new
  p.connect
  begin
    p.create_user_table
    p.prepare_insert_user_statement
    p.add_user(1, 'Marc')
    p.add_user(2, 'Sharon')
    p.query_user_table { |row| printf("#d #s\n", row['id'], row['name']) }
  rescue Exception => e
    puts e.message
    puts e.backtrace.inspect
  ensure
    p.drop_user_table
    p.disconnect
  end
end

main
