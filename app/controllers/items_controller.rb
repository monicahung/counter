class ItemsController < ApplicationController
  include CableReady::Broadcaster

  # GET /items or /items.json
  def index
    @items = Item.all.order(created_at: :desc)
    @item = Item.new
  end

  # POST /items or /items.json
  def create
    item = Item.create(item_params)
    cable_ready['timeline'].insert_adjacent_html(
      selector: '#timeline',
      position: 'afterbegin',
      html: render_to_string(partial: 'item', locals: { item: item })
    )
    cable_ready.broadcast
    redirect_to items_path

  end

  private
    # Only allow a list of trusted parameters through.
    def item_params
      params.require(:item).permit(:name, :count)
    end
end
