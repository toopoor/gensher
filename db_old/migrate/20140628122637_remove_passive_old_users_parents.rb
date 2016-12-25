class RemovePassiveOldUsersParents < ActiveRecord::Migration
  def up
    while Old::User.active.roots.count.zero?
      Old::User.roots.map{|root| root.children.update_all(referid: nil) unless root.active?}
    end
    olimp = Old::User.find_by(login: 'olimp')
    olimp.update_column(:referid, nil)
    Old::User.rebuild!
    if (support = Old::User.find_by(login: 'Support')).present?
      support.destroy
    end
  end

  def down
  end
end
