class TerminalsDecorator < Draper::CollectionDecorator
  delegate :current_page, :total_pages, :limit_value, :total_count,
     :entry_name, :offset_value, :last_page?

  def new_link
    h.link_to 'New Terminal',
              h.new_terminal_path,
              class: 'btn btn-success float-right'
  end

  def pagination
    h.paginate self
  end
end
