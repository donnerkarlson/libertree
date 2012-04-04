require 'rcrypt'
require 'libertree/connection'

module Libertree
  class Client
    # @param [Hash] params Paramaters Hash
    # @option params [String] :public_key A public RSA key, the partner of the private key
    # @option params [String] :private_key A private RSA key, the partner of the public key
    # @option params [String] :avatar_url_base The base to prefix before member avatar_path when sending requests with an avatar_url parameter
    def initialize( params = {} )
      @public_key = params[:public_key] or raise ":public_key required by Libertree::Client"
      @private_key = params[:private_key] or raise ":private_key required by Libertree::Client"
      @avatar_url_base = params[:avatar_url_base]
    end

    def connect(remote_host)
      @conn = Libertree::Connection.new(remote_host)

      response = @conn.request('INTRODUCE', 'public_key' => @public_key)

      challenge_encrypted = response['challenge']
      if challenge_encrypted && response['code'] == 'OK'
        challenge_decrypted = RCrypt.decrypt(challenge_encrypted, @private_key)
        response = @conn.request('AUTHENTICATE', 'response' => challenge_decrypted)

        if response['code'] != 'OK'
          raise "Failed to connect: #{response.inspect}"
        end
      end

      if block_given?
        yield @conn
        @conn.close
      end
    end

    def close
      @conn.close
    end

    # ---------

    def req_comment(comment)
      post = comment.post
      server = post.member.server
      public_key = server ? server.public_key : @pulic_key
      @conn.request(
        'COMMENT',
        'post_id'    => post.public_id,
        'public_key' => public_key,
        'username'   => comment.member.username,
        'text'       => comment.text
      )
    end

    def req_member(member)
      @conn.request(
        'MEMBER',
        'username'   => member.username,
        'avatar_url' => "#{@avatar_url_base}#{member.avatar_path}"
      )
    end

    def req_post(post)
      @conn.request(
        'POST',
        'username' => post.member.username,
        'id'       => post.id,
        'public'   => true,
        'text'     => post.text
      )
    end
  end
end
