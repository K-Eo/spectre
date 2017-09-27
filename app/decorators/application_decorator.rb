class ApplicationDecorator < Draper::Decorator
  def handle_present(value, fallback = "no given")
    raise Exception.new("Value must exists") if value.nil?

    if value.present?
      return yield if block_given?
      value
    else
      fallback
    end
  end
end
