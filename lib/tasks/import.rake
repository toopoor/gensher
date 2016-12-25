class OUser < ActiveRecord::Base
  self.table_name  = "ip_login"

  belongs_to :old_comp, foreign_key: :comp_id
  has_many :old_lists, foreign_key: :userid

  # attrs

  # host: string,      -> 'gensherman.com' only
  # comp_id: integer,  belongs_to ???
  # ip: string,
  # ip2: string,
  # os: string,
  # browser: string,
  # login: string,     -> '' 9347 items if status true ???
  # pass: string,      -> string ))
  # status: boolean,   -> ???
  # date: timestamp,   -> created_at
  # key: string,       -> '' 9347
  # soc_share: boolean -> ???
end

class OldComp < ActiveRecord::Base
  self.table_name  = "comps"

  has_many :old_users, foreign_key: :comp_id
  # attrs

  # key: string,
  # ip: string,
  # ip2: string,
  # os: string,
  # browser: string,
  # date: timestamp

end

class OldList < ActiveRecord::Base
  self.table_name  = "list"

  belongs_to :old_user, foreign_key: :userid
  has_many :old_list_events, foreign_key: :listid
  # attrs

  # userid: integer,
  # fio: string,
  # sms_tel: string,
  # email: string,
  # skype: string,
  # info: string,
  # contact: string,
  # key: string,
  # date: timestamp
end

class OldListEvent < ActiveRecord::Base
  self.table_name  = "list_events"

  belongs_to :old_user, foreign_key: :userid
  belongs_to :old_list, foreign_key: :listid

  # userid: integer,
  # listid: integer,
  # event_type: string,
  # event: string,
  # day: date,
  # time: time,
  # target: datetime,
  # date: timestamp
end

# OldEmail(id: integer, comp_id: integer, iduser: integer, oldemail: string, newemail: string, fio: string, date: timestamp)
# empty emails table

# OldBan(id: integer, user_id: integer, comp_id: integer, ip: string, ip2: string, date: timestamp)
# empty ban table

class OldCollage < ActiveRecord::Base
  self.table_name  = "collage"

  #no id
end

class OldEvent < ActiveRecord::Base
  self.table_name  = "events"

  belongs_to :old_user, foreign_key: :userid

  # userid: integer,
  # event: string,
  # status: boolean,
  # date: timestamp
end

class OldFriend < ActiveRecord::Base
  self.table_name  = "friend"

  belongs_to :old_user, foreign_key: :userid
  belongs_to :old_friend, foreign_key: :friend, class_name: 'OUser'

  # userid: integer,
  # friend: integer,
  # date: timestamp
end




namespace :import do
  namespace :seed do
    desc "Old tables setup"
    task setup: :environment do
      ActiveRecord::Base.connection.execute("alter table list_events CHANGE type event_type varchar(8)")
      ActiveRecord::Base.connection.execute("alter table collage CHANGE type collage_type tinyint(1)")
    end

    desc "Import users"
    task users: :environment do
      puts "users count #{OUser.count}"
      puts "list count #{OldList.count}"
      puts "list count with email #{OldList.where('email <> "" ').count}" #Real users
    end
  end
end