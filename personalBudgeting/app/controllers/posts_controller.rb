class PostsController < ApplicationController

  def index

    redirect_to :controller => 'budget', :action => 'show', :user => 1
  end

  def show
      cluster = Cassandra.cluster(hosts: ['cassandra0'])
      keyspace = 'infs3208'
      session  = cluster.connect(keyspace)

      @tableNames = session.execute('SELECT table_name from system_schema.tables')
      puts(@tableNames)
      #Stores all users.
      @genY = session.execute('SELECT * FROM mat_gen_y')
      @genX = session.execute('SELECT * FROM mat_gen_x')
      @mills = session.execute('SELECT * FROM mat_gen_mills')

  end

  def create_view
#
#      cluster = Cassandra.cluster(hosts: ['cassandra0'])
#      keyspace = 'infs3208'
#      session  = cluster.connect(keyspace)
#
#      statement = session.prepare('CREATE MATERIALIZED VIEW infs3208.? AS
#          SELECT ?, ?, ?, ? FROM infs3208.? WHERE ? and ? and ?
#          PRIMARY KEY (?, ?, ?) WITH
#          caching = { "keys" : "ALL", "rows_per_partition" : "100"}
#          AND comment = "Created view"');
#
#      session.execute(statement, :arguments => [params['view_name'], params['select1'], params['select2'],
#          params['select3'], params['select4'], params['from1'], params['where1'], params['where2'], params['where3'],
#              params['select1'], params['select2'], params['select3']])
#
#      redirect_to :action => "show", :user => selected
        end

end
