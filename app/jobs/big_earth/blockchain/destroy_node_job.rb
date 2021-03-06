module BigEarth 
  module Blockchain 
    class DestroyNodeJob < ActiveJob::Base
      include BigEarth::Blockchain::Utility

      # Set queue
      queue_as :destroy_node_job

      # param: config:hash (mandatory)
      #  * type (mandatory)
      #  * title (mandatory)
      #  * email (mandatory)
      def perform config
        # Wrap in begin/rescue block
        begin
          if (config[:type].nil? || config[:type] == '') && (config[:title].nil? || config[:title] == '') && (config[:email].nil? || config[:email] == '')
            # Missing all 3
            raise BigEarth::Blockchain::Exceptions::DestroyNodeException.new "Missing `type` and `title` and `email` (sheesh you didn't try very hard did you?)"
          elsif (config[:title].nil? || config[:title] == '') && (config[:email].nil? || config[:email] == '')
            # Missing title and email
            raise BigEarth::Blockchain::Exceptions::DestroyNodeException.new "Missing `title` and `email`"
          elsif (config[:type].nil? || config[:type] == '') && (config[:email].nil? || config[:email] == '')
            # Missing type and email
            raise BigEarth::Blockchain::Exceptions::DestroyNodeException.new "Missing `type` and `email`"
          elsif (config[:type].nil? || config[:type] == '') && (config[:title].nil? || config[:title] == '')
            # Missing type and title
            raise BigEarth::Blockchain::Exceptions::DestroyNodeException.new "Missing `type` and `title`"
          elsif config[:type].nil? || config[:type] == ''
            # Missing just type
            raise BigEarth::Blockchain::Exceptions::DestroyNodeException.new "Missing `type`"
          elsif config[:title].nil? || config[:title] == ''
            # Missing just title
            raise BigEarth::Blockchain::Exceptions::DestroyNodeException.new "Missing `title`"
          elsif config[:email].nil? || config[:email] == ''
            # Missing just title
            raise BigEarth::Blockchain::Exceptions::DestroyNodeException.new "Missing `email`"
          end
          # Get the Digital Ocean Client
          digital_ocean_client = DropletKit::Client.new access_token: Figaro.env.digital_ocean_api_token
          
          # Namespace the title by the user's email so that no global titles conflict
          formatted_title = format_title config[:title], config[:email]
              
          # Select just the appropriate node
          node = fetch_node digital_ocean_client, formatted_title 
          
          unless node.empty?
            # If the node exists then delete it
            digital_ocean_client.droplets.delete id: node.first['id']
          end
          
        rescue => error
          puts "[ERROR] #{Time.now}: #{error.class}: #{error.message}"
        end
      end
    end
  end
end
