# == Schema Information
#
# Table name: comments
#
#  id               :bigint(8)        not null, primary key
#  commentable_id   :bigint(8)        not null
#  commentable_type :string           not null
#  title            :string
#  body             :text
#  subject          :string
#  user_id          :integer          not null
#  parent_id        :integer
#  lft              :integer
#  rgt              :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Comment < ActiveRecord::Base
  # extends ...................................................................
  # class methods .............................................................
  # includes ..................................................................

  # relationships .............................................................
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  # validations ...............................................................
  validates :body, presence: true
  validates :user, presence: true

  # callbacks .................................................................

  # scopes ....................................................................

  # Helper class method to lookup all comments assigned
  # to all commentable types for a given user.
  scope :find_comments_by_user, ->(user) { where(user_id: user.id).order("created_at DESC") }

  # Helper class method to look up all comments for
  # commentable class name and commentable id.
  scope :find_comments_for_commentable, ->(commentable_str, commentable_id) do
    where(commentable_type: commentable_str.to_s, commentable_id: commentable_id).order("created_at DESC")
  end

  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  acts_as_nested_set scope: [:commentable_id, :commentable_type]

  # class methods .............................................................
  class << self
    alias by_user find_comments_by_user
    alias for_commentable find_comments_for_commentable

    # Helper class method that allows you to build a comment
    # by passing a commentable object, a user_id, and comment text
    # example in readme
    def build_from(obj, user_id, comment)
      new \
        commentable: obj,
        body: comment,
        user_id: user_id
    end

    # Helper class method to look up a commentable object
    # given the commentable class name and id
    def find_commentable(commentable_str, commentable_id)
      commentable_str.constantize.find(commentable_id)
    end
  end

  # public instance methods ...................................................

  # helper method to check if a comment has children
  def has_children?
    children.any?
  end

  # protected instance methods ................................................
  # private instance methods ..................................................
end
