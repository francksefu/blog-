class PostsController < ApplicationController
  before_action :set_post, only: %i[show update destroy]
  before_action :authenticate_devise_api_token!, only: [:create]
  # GET /posts
  def index
    @posts = Post.all.order(created_at: :desc)

    render json: @posts.to_json(include: %i[user paragraphs comments])
  end

  # GET /posts/1
  def show
    render json: @post.to_json(include: %i[user paragraphs comments])
  end

  # POST /posts
  def create
    devise_api_token = current_devise_api_token
    @user = User.find(devise_api_token.resource_owner.id.to_i)
    @post = @user.posts.new(post_params)

    if @post.save
      render json: @post, status: :created, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    if @post.update(post_params)
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy!
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:title, paragraphs: [])
  end
end
