class SmallActivationJob < Struct.new(:record_id)
  def perform
    begin
      User.connection.transaction do
        record = User.find(record_id)
        record.send(:small_activation_pay!)
      end
    rescue
    end 
  end
end
