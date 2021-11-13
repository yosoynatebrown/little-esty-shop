class BulkDiscountsController < ApplicationController
  before_action :set_bulk_discount, only: %i[ show edit update destroy ]

  # GET /bulk_discounts or /bulk_discounts.json
  def index
    @bulk_discounts = BulkDiscount.all
  end

  # GET /bulk_discounts/1 or /bulk_discounts/1.json
  def show
  end

  # GET /bulk_discounts/new
  def new
    @bulk_discount = BulkDiscount.new
  end

  # GET /bulk_discounts/1/edit
  def edit
  end

  # POST /bulk_discounts or /bulk_discounts.json
  def create
    @bulk_discount = BulkDiscount.new(bulk_discount_params)

    respond_to do |format|
      if @bulk_discount.save
        format.html { redirect_to @bulk_discount, notice: "Bulk discount was successfully created." }
        format.json { render :show, status: :created, location: @bulk_discount }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bulk_discount.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bulk_discounts/1 or /bulk_discounts/1.json
  def update
    respond_to do |format|
      if @bulk_discount.update(bulk_discount_params)
        format.html { redirect_to @bulk_discount, notice: "Bulk discount was successfully updated." }
        format.json { render :show, status: :ok, location: @bulk_discount }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bulk_discount.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bulk_discounts/1 or /bulk_discounts/1.json
  def destroy
    @bulk_discount.destroy
    respond_to do |format|
      format.html { redirect_to bulk_discounts_url, notice: "Bulk discount was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bulk_discount
      @bulk_discount = BulkDiscount.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bulk_discount_params
      params.require(:bulk_discount).permit(:percent_discount, :quantity_threshold, :merchant_id)
    end
end
