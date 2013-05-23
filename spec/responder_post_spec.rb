require 'spec_helper'

describe Libertree::Server::Responder::Post do
  let(:subject_class) { Class.new }
  let(:subject) { subject_class.new }

  before :each do
    subject_class.class_eval {
      include Libertree::Server::Responder::Helper
      include Libertree::Server::Responder::Post
    }
  end

  describe 'rsp_post' do
    include_context 'requester in a forest'

    context 'and the member is known' do
      before :each do
        @member = Libertree::Model::Member.create(
          FactoryGirl.attributes_for(:member, :server_id => @requester.id)
        )
        subject.instance_variable_set(:@remote_tree, @requester)
      end

      it 'raises MissingParameter with a missing id' do
        h = {
          'username'   => @member.username,
          'visibility' => 'forest',
          'text'       => 'A test post.',
        }
        expect { subject.rsp_post(h) }.
          to raise_error( Libertree::Server::MissingParameter )
      end

      it 'raises MissingParameter with a blank id' do
        h = {
          'username'   => @member.username,
          'id'         => '',
          'visibility' => 'forest',
          'text'       => 'A test post.',
        }
        expect { subject.rsp_post(h) }.
          to raise_error( Libertree::Server::MissingParameter )
      end

      it "raises NotFound with a member username that isn't found" do
        h = {
          'username'   => 'nosuchusername',
          'id'         => 4,
          'visibility' => 'forest',
          'text'       => 'A test post.',
        }
        expect { subject.rsp_post(h) }.
          to raise_error( Libertree::Server::NotFound )
      end

      context 'with valid post data, and a member that does not belong to the requester' do
        before :each do
          other_server = Libertree::Model::Server.create( FactoryGirl.attributes_for(:server) )
          @member = Libertree::Model::Member.create(
            FactoryGirl.attributes_for(:member, :server_id => other_server.id)
          )
        end

        it 'raises NotFound' do
          h = {
            'username'   => @member.username,
            'id'         => 5,
            'visibility' => 'forest',
            'text'       => 'A test post.',
          }
          expect { subject.rsp_post(h) }.
            to raise_error( Libertree::Server::NotFound )
        end
      end

      it 'raises no errors with valid data' do
        h = {
          'username'   => @member.username,
          'id'         => 6,
          'visibility' => 'forest',
          'text'       => 'A test post.',
        }
        expect { subject.rsp_post(h) }.
          not_to raise_error
      end

      context 'when a remote post exists already' do
        before :each do
          @post = Libertree::Model::Post.create(
            FactoryGirl.attributes_for(:post, member_id: @member.id)
          )
          @initial_text = @post.text
        end

        it 'updates the post text and stores a post revision' do
          original_text = @post.text
          original_text.should_not == 'edited text'
          Libertree::Model::PostRevision.where( 'post_id' => @post.id ).count.should == 0

          h = {
            'username'   => @member.username,
            'id'         => @post.remote_id,
            'visibility' => 'forest',
            'text'       => 'edited text',
          }
          expect { subject.rsp_post(h) }.
            not_to raise_error

          Libertree::Model::Post[@post.id].text.should == 'edited text'
          revisions = Libertree::Model::PostRevision.where( 'post_id' => @post.id )
          revisions.count.should == 1
          revisions[0].text.should == original_text
        end
      end
    end
  end
end
