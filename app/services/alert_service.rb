class AlertService < Alert
  include AASM

  aasm column: :state, enum: true do
    state :opened, initial: true
    state :closed

    event :open do
      transitions from: :closed, to: :opened
    end

    event :close do
      transitions from: :opened, to: :closed
    end
  end
end
