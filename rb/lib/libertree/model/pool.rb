module Libertree
  module Model
    class Pool < M4DBI::Model(:pools)
      def account
        @account ||= Account[self.account_id]
      end

      def posts
        @posts ||= Post.s(
          %{
            SELECT
              p.*
            FROM
                posts p
              , pools_posts pp
            WHERE
              p.id = pp.post_id
              AND pp.pool_id = ?
            ORDER BY
              p.id DESC
          },
          self.id
        )
      end

      def delete_cascade
        DB.dbh.delete "DELETE FROM pools_posts WHERE pool_id = ?", self.id
        self.delete
      end

      def <<(post)
        DB.dbh.i(
          %{
            INSERT INTO pools_posts (
              pool_id, post_id
            )  SELECT
              ?, ?
            WHERE NOT EXISTS(
              SELECT 1
              FROM pools_posts
              WHERE
                pool_id = ?
                AND post_id = ?
            )
          },
          self.id,
          post.id,
          self.id,
          post.id
        )
      end

      def delete(post)
        DB.dbh.d  "DELETE FROM pools_posts WHERE pool_id = ? AND post_id = ?", self.id, post_id
      end
    end
  end
end
