class ProductsController < ApplicationController
#  before_action :authorize_user!, only: [:create, :update]
  before_action :authorize_products_user, only: [:update,:edit]


  expose(:category)
  expose(:products)
  expose(:product)
  expose(:review) { Review.new }
  expose_decorated(:reviews, ancestor: :product)

  def index
    self.products = Product.paginate(:page => params[:page], :per_page => 10)
  end

  def show
  end

  def new
  end

  def edit

  end

  def create
    self.product = current_user.products.build(product_params)

    if product.save
      category.products << product
      redirect_to category_product_url(category, product), notice: 'Product was successfully created.'
    else
      render action: 'new'
    end
  end

  def update

    if self.product.update(product_params)
      redirect_to category_product_url(category, product), notice: 'Product was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /products/1
  def destroy
    product.destroy
    redirect_to category_url(product.category), notice: 'Product was successfully destroyed.'
  end

  private
    def product_params
      params.require(:product).permit(:title, :description, :price, :category_id, :user_id)
    end

    def authorize_products_user
      if product.user != current_user && product.user.nil?
        redirect_to category_product_url(category, product), flash: { error: "You are not allowed to edit this product." }
      end
    end
end
