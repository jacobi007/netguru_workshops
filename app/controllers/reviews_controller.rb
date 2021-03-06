class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  expose(:review)
  expose(:product)
  expose(:reviews)
  def index
    self.reviews = Review.paginate(:page => params[:page], :per_page => 10)
  end

  def edit
  end

  def create
    self.review = current_user.reviews.build(review_params)

    if review.save
      product.reviews << review
      redirect_to category_product_url(product.category, product), notice: 'Review was successfully created.'
    else
      redirect_to category_product_url(product.category, product), alert: 'Review is not valid, please make sure both content and rating are filled in'
    end
  end

  def destroy
    review.destroy
    redirect_to category_product_url(product.category, product), notice: 'Review was successfully destroyed.'
  end

  private
    def review_params
      params.require(:review).permit(:content, :rating, :user_id)
    end
end
