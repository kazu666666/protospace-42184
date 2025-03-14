class PrototypesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :redirect_unless_owner, only: [:edit, :update, :destroy]

  def index
      @prototypes = Prototype.all
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to root_path, notice:
    else
      render :new
    end
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment   = Comment.new 
    @comments = @prototype.comments.includes(:user)
  end  

  def edit
    @prototype = Prototype.find(params[:id])
    unless user_signed_in?
      redirect_to action: :index
    end
  end

  def update
    @prototype = Prototype.find(params[:id])
    if @prototype.update(prototype_params)
      redirect_to  prototype_path(@prototype)
    else
      render :edit
    end
  end

  def destroy
    @prototype = Prototype.find(params[:id])
    @prototype.destroy
    redirect_to prototypes_path, notice:
  end

 private

 def prototype_params
  params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
 end

 def redirect_unless_owner
   @prototype = Prototype.find(params[:id])
   redirect_to root_path unless @prototype.user == current_user
 end

end
