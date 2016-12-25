# == Schema Information
#
# Table name: tarif
#
#  id       :integer          not null, primary key
#  tarif    :boolean          not null
#  userid   :integer          not null
#  selfuser :integer          not null
#  selfnum  :integer          not null
#  sponsor  :integer          not null
#  status   :boolean          not null
#  key      :string(32)       not null
#  date     :timestamp        not null
#

class Old::Tariff < OldBase
  self.table_name = 'tarif'

  belongs_to :user,    class_name: 'Old::User', foreign_key: :userid
  belongs_to :sponsor, class_name: 'Old::User', foreign_key: :sponsor

  scope :active, -> { where(tarif: true, status: true) }
end
