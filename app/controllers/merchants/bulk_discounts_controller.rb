class Merchants::BulkDiscountsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:id])
    @holidays = HolidayService.next_3_holidays
  end

  def show
    set_bulk_discount
  end

  def new
    @merchant = Merchant.find(params[:id])
    if params[:holiday_name]
      @bulk_discount = @merchant.bulk_discounts.new(
        name: params[:holiday_name],
        percent_discount: params[:percent_discount],
        quantity_threshold: params[:quantity_threshold]
                                                   )
    else
      @bulk_discount = @merchant.bulk_discounts.new
    end
  end

  def edit
    set_bulk_discount
  end

  def create
    @bulk_discount = BulkDiscount.new(bulk_discount_params)
    @merchant = Merchant.find(@bulk_discount.merchant.id)

    respond_to do |format|
      if @bulk_discount.save
        format.html { redirect_to bulk_discounts_path(@merchant), notice: "Bulk discount was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
        flash[:alert] = "Error: #{error_message(@bulk_discount.errors)}"
      end
    end
  end

  def update
    set_bulk_discount

    respond_to do |format|
      if @bulk_discount.update(bulk_discount_params)
        format.html { redirect_to "/merchants/#{@bulk_discount.merchant_id}/bulk_discounts/#{@bulk_discount.id}", notice: "Bulk discount was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
        flash[:alert] = "Error: #{error_message(@bulk_discount.errors)}"
      end
    end
  end

  def destroy
    set_bulk_discount
    @bulk_discount.destroy
    respond_to do |format|
      format.html { redirect_to "/merchants/#{@bulk_discount.merchant.id}/bulk_discounts", notice: "Bulk discount was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_bulk_discount
      @bulk_discount = BulkDiscount.find(params[:id])
    end

    def bulk_discount_params
      params.require(:bulk_discount).permit(:percent_discount, :quantity_threshold, :merchant_id, :name)
    end
end
