module ActiveRecord
  module ConnectionAdapters
    module DatabaseStatements
      def random_order_sql() end
    end

    class DB2Adapter
      def random_order_sql
        "RAND()"
      end
    end

    class FirebirdAdapter
      def random_order_sql
        "RAND()"
      end
    end

    class MysqlAdapter
      def random_order_sql
        "RAND()"
      end
    end

    class OpenBaseAdapter
      def random_order_sql
        raise "Not yet implemented"
      end
    end

    class OracleAdapter
      def random_order_sql
        raise "Not yet implemented"
      end
    end
    
    class PostgreSQLAdapter
      def random_order_sql
        "RANDOM()"
      end
    end

    class SQLiteAdapter
      def random_order_sql
        "RANDOM()"
      end
    end

    class SQLServerAdapter
      def random_order_sql
        "NEWID()"
      end
    end

    class SybaseAdapter
      def random_order_sql
        "RAND()"
      end
    end
  end
  
  class Base
    class << self
      private
        def find_every(options)
          options[:order] = Base.connection.random_order_sql if options[:order] && options[:order] == :random
          records = scoped?(:find, :include) || options[:include] ?
            find_with_associations(options) :
            find_by_sql(construct_finder_sql(options))

          records.each { |record| record.readonly! } if options[:readonly]
  
          records
  
        end
    end
  end
end
