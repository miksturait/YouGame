class ActiveRecord::Base
  MISSING_RELATION_REGEX = /relation \"(.*)\" does not exist/
  class << self
    def reload_views!
      reload_functions!(:before)
      @views_to_load = Dir.glob("db/views/**/*.sql").inject({}) do |acc, path|
        acc[File.basename(path, '.sql')] = Rails.root.join(path); acc
      end
      #@views_to_load.keys.each do |view_name|
      #  connection.execute("DROP VIEW IF EXISTS #{view_name} CASCADE;")
      #end
      while @views_to_load.present?
        view_name = @views_to_load.keys.first
        load_view(view_name)
      end
      reload_functions!(:after)
    end

    def load_view(view_name)
      begin
        path = @views_to_load[view_name]

        Rails.logger.info "\nLOADING VIEW: #{view_name} (#{path}) \n#{'-' * 100}"
        sql = File.read(path)
        Rails.logger.info("\n\n #{sql}")

        connection.execute("CREATE OR REPLACE VIEW #{view_name} AS #{sql};")
        Rails.logger.info "\nVIEW LOADED SUCCESSFULLY"

        @views_to_load.delete(view_name)
      rescue ActiveRecord::StatementInvalid => exc
        related_view_name = exc.message.scan(MISSING_RELATION_REGEX).flatten.first
        if @views_to_load[related_view_name].present?
          load_view(related_view_name)
          retry
        else
          raise exc
        end
      end
    end

    private
    def reload_functions!(callback)
      @functions_to_load = Dir.glob("db/functions/#{callback}_views/**/*.sql").inject({}) do |acc, path|
        acc[File.basename(path, '.sql')] = Rails.root.join(path); acc
      end
      @functions_to_load.each do |function_to_load, file|
        Rails.logger.info "\nLOADING FUNCTIONS: #{function_to_load} (#{file}) \n#{'-' * 100}"
        sql = File.read(file)
        Rails.logger.info("\n\n #{sql}")
        connection.execute(sql)
        Rails.logger.info "\nFUNCTIONS LOADED SUCCESSFULLY"
      end
      nil
    end
  end
end
