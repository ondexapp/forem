module Api
  module TagsController
    extend ActiveSupport::Concern

    ATTRIBUTES_FOR_SERIALIZATION = %i[id name bg_color_hex text_color_hex].freeze
    private_constant :ATTRIBUTES_FOR_SERIALIZATION

    def index
      page = params[:page]
      per_page = (params[:per_page] || 10).to_i
      num = [per_page, 1000].min

      @tags = Tag.select(ATTRIBUTES_FOR_SERIALIZATION)
        .order(taggings_count: :desc)
        .page(page).per(num)

      set_surrogate_key_header Tag.table_key, @tags.map(&:record_key)
    end
  end
end
