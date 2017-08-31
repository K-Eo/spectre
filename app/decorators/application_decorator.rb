class ApplicationDecorator < Draper::Decorator
  # Define methods for all decorated objects.
  # Helpers are accessed through `helpers` (aka `h`). For example:
  #
  #   def percent_amount
  #     h.number_to_percentage object.amount, precision: 2
  #   end

  def handle_present(value, fallback = 'no given')
    if value.present?
      return yield if block_given?
      value
    else
      fallback
    end
  end
end
