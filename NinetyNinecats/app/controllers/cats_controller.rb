class CatsController < ApplicationController
  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(cat_params)
    @cat.user_id = current_user.id

    if @cat.save
      redirect_to cat_url(@cat)
    else
      render :new
    end
  end

  def edit
    @cat = Cat.find(params[:id])
    if owns_cat?
      render :edit
    else
      flash[:errors] = "You don't own #{@cat.name}!"
      redirect_to cats_url
    end
  end

  def update
    @cat = Cat.find(params[:id])

    if @cat.persisted?
      redirect_to cat_url(@cat)
    else
      render :edit
    end

  end

  def destroy
    @cat = Cat.find(params[:id])

    if @cat.persisted?
      @cat.destroy
      redirect_to cats_url
    else
      raise "No such cat exists"
    end
  end


  private
  def owns_cat?
    current_user.id == @cat.user_id
  end

  def cat_params
    params.require(:cat).permit(:name, :birth_date,
      :color, :sex, :description)
  end
end
