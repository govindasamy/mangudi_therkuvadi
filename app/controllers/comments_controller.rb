class CommentsController < ApplicationController

  def create
    commentable = commentable_type.constantize.find(commentable_id)
    @comment = Comment.build_from(commentable, commentable.id, body)
    @comment.user_id = current_user.id
    respond_to do |format|
      if @comment.save
        make_child_comment
        format.html  { redirect_to("/articles/#{commentable.slug}", :notice => 'Comment was successfully added.') }
      else
        format.html  { render :action => "new" }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :commentable_id, :commentable_type, :comment_id)
  end

  def commentable_type
    comment_params[:commentable_type]
  end

  def commentable_id
    comment_params[:commentable_id]
  end

  def comment_id
    comment_params[:comment_id]
  end

  def body
    comment_params[:body]
  end

  def make_child_comment
    return "" if comment_id.blank?

    parent_comment = Comment.find comment_id
    @comment.move_to_child_of(parent_comment)
  end

end
