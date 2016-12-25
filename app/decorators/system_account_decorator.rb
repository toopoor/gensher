class SystemAccountDecorator < Draper::Decorator
  delegate_all

  def full_name
    object.name
  end
end
