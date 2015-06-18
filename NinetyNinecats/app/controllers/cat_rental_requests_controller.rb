class CatRentalRequestsController < ApplicationController

  def new
    @cat_rental_request = CatRentalRequest.new

    render :new
  end

  def show
    @cat_rental_request = CatRentalRequest.find(params[:id])
    render :show
  end

  def create

    @cat_rental_request = CatRentalRequest.new(cat_rental_request_params)
    @cat_rental_request.user_id = current_user.id

    if @cat_rental_request.save
      redirect_to cat_url(@cat_rental_request.cat_id)
    else
      render :new
    end
  end

  def update
    @cat_rental_request = CatRentalRequest.find(params[:request_id])
    @cat_rental_request.status = params[:request][:status]

    
    if Cat.find(params[:cat_id]).owner.id != params[:requester_id].to_i
        flash[:errors] = "You don't own #{Cat.find(params[:cat_id]).name}!"
        redirect_to cat_url(@cat_rental_request.cat_id)
    else
      if @cat_rental_request.save
        redirect_to cat_url(@cat_rental_request.cat_id)
      else
        flash[:errors] = "Update did not work!"
        redirect_to cat_url(@cat_rental_request.cat_id)
      end
    end

  end

  def approve
    current_cat_rental_request.approve!
    redirect_to cat_url(current_cat)
  end

  def deny
    current_cat_rental_request.deny!
    redirect_to cat_url(current_cat)
  end

  private
  def current_cat_rental_request
    @rental_request ||=
      CatRentalRequest.includes(:cat).find(params[:id])
  end

  def current_cat
    current_cat_rental_request.cat
  end

  def cat_rental_request_params
    params.require(:cat_rental_request).permit(:start_date, :end_date, :cat_id)
  end

end
