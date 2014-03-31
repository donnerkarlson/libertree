module Libertree
  module Model
    class Profile < Sequel::Model(:profiles)
      def after_update
        super
        if self.member.local?
          Libertree::Model::Job.create_for_forests(
            {
              task: 'request:MEMBER',
              params: { 'username' => self.member.account.username, }
            }
          )
        end
      end

      def member
        @member ||= Member[ self.member_id ]
      end

      def self.search(query)
        s  "SELECT * FROM profiles WHERE name_display ILIKE '%' || ? || '%' OR description ILIKE '%' || ? || '%'", query, query
      end
    end
  end
end