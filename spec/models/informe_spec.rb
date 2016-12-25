# == Schema Information
#
# Table name: informes
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  token      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Informe do
  it 'sohuld be valid record' do
    Informe.new(email: 'test@gg.com').should be_valid
  end

  it 'should have enabled token' do
    record = Informe.create(email: 'test@gg.com')
    record.token.should_not be_blank
  end
end
