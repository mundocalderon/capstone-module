module Protectable
  extend ActiveSupport::Concern

  included do
    def user_roles
      @user_roles ||= []
    end
  end
end


# To get a better understanding of how this is used go to rails console
=begin
>greg=User.where(:uid=>"greg@bbunch.org").first
#<User id: 4, provider: "email", uid: "greg@bbunch.org", allow_password_change: false, name: "Greg Brady", nickname: nil, image: nil, email: "greg@bbunch.org", created_at: "2020-04-15 05:22:03", updated_at: "2020-04-15 05:22:03">
> Role.where(:user_id=>greg.id, :mname=>"Image")
 [#<Role:0x00007fa597747ea0 id: 31, user_id: 4, role_name: "organizer", mname: "Image", mid: 8, created_at: Wed, 15 Apr 2020 05:22:04 UTC +00:00, updated_at: Wed, 15 Apr 2020 05:22:04 UTC +00:00>,
 #<Role:0x00007fa597747d38 id: 32, user_id: 4, role_name: "organizer", mname: "Image", mid: 9, created_at: Wed, 15 Apr 2020 05:22:04 UTC +00:00, updated_at: Wed, 15 Apr 2020 05:22:04 UTC +00:00>,
 #<Role:0x00007fa597747bd0 id: 73, user_id: 4, role_name: "organizer", mname: "Image", mid: 31, created_at: Wed, 15 Apr 2020 05:22:04 UTC +00:00, updated_at: Wed, 15 Apr 2020 05:22:04 UTC +00:00>]
>Image.joins("join Roles r on r.mname='Image' and r.mid=Images.id and r.user_id=4")
[#<Image:0x00007fa5991cb6c8 id: 8, caption: "Overview", creator_id: 4, created_at: Wed, 15 Apr 2020 05:22:04 UTC +00:00, updated_at: Wed, 15 Apr 2020 05:22:04 UTC +00:00>,
 #<Image:0x00007fa5991cb588 id: 9, caption: "Roger Taney Statue", creator_id: 4, created_at: Wed, 15 Apr 2020 05:22:04 UTC +00:00, updated_at: Wed, 15 Apr 2020 05:22:04 UTC +00:00>,
 #<Image:0x00007fa5991cb420 id: 31, caption: "World Trade Center", creator_id: 4, created_at: Wed, 15 Apr 2020 05:22:04 UTC +00:00, updated_at: Wed, 15 Apr 2020 05:22:04 UTC +00:00>]
>Image.joins("join Roles r on r.mname='Image' and r.mid=Images.id and r.user_id=4").select("r.role_name").first.attributes
  Image Load (0.6ms)  SELECT  r.role_name FROM "images" join Roles r on r.mname='Image' and r.mid=Images.id and r.user_id=4  ORDER BY "images"."id" ASC LIMIT 1
 {"id"=>nil, "role_name"=>"organizer"}
> Image.joins("join Roles r on r.mname='Image' and r.mid=Images.id and r.user_id=4").select("Images.*, r.role_name").map do |image| image.attributes end
  Image Load (0.5ms)  SELECT Images.*, r.role_name FROM "images" join Roles r on r.mname='Image' and r.mid=Images.id and r.user_id=4
 [{"id"=>8, "caption"=>"Overview", "creator_id"=>4, "created_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "updated_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "role_name"=>"organizer"},
 {"id"=>9, "caption"=>"Roger Taney Statue", "creator_id"=>4, "created_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "updated_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "role_name"=>"organizer"},
 {"id"=>31, "caption"=>"World Trade Center", "creator_id"=>4, "created_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "updated_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "role_name"=>"organizer"}]
> Image.joins("left join Roles r on r.mname='Image' and r.mid=Images.id and r.user_id=4").select("Images.*, r.role_name").map do |image| image.attributes end
  Image Load (0.7ms)  SELECT Images.*, r.role_name FROM "images" left join Roles r on r.mname='Image' and r.mid=Images.id and r.user_id=4
 [{"id"=>1, "caption"=>"Front of Museum Restored: 1884 B&O Railroad Museum Roundhouse", "creator_id"=>3, "created_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "updated_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "role_name"=>nil},
 {"id"=>2, "caption"=>"Roundhouse Inside: One-of-a-Kind Railroad Collection inside the B&O Roundhouse", "creator_id"=>3, "created_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "updated_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "role_name"=>nil},
 {"id"=>3, "caption"=>"40 acres of railroad history at the B&O Railroad Museum", "creator_id"=>3, "created_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "updated_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "role_name"=>nil},
 {"id"=>4, "caption"=>"Boat at Fort McHenry", "creator_id"=>2, "created_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "updated_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "role_name"=>nil},
 {"id"=>5, "caption"=>"Boat heading in to Fell's Point", "creator_id"=>2, "created_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "updated_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "role_name"=>nil},
 {"id"=>6, "caption"=>"Boat at Harborplace", "creator_id"=>2, "created_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "updated_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "role_name"=>nil},
 {"id"=>7, "caption"=>"Boat passing Pier 5", "creator_id"=>2, "created_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "updated_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "role_name"=>nil},
 {"id"=>8, "caption"=>"Overview", "creator_id"=>4, "created_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "updated_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "role_name"=>"organizer"},
 {"id"=>9, "caption"=>"Roger Taney Statue", "creator_id"=>4, "created_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "updated_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "role_name"=>"organizer"},
 {"id"=>10, "caption"=>"Hotel Front Entrance", "creator_id"=>3, "created_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "updated_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "role_name"=>nil},
 {"id"=>11, "caption"=>"National Aquarium buildings", "creator_id"=>2, "created_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "updated_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "role_name"=>nil},
 {"id"=>12, "caption"=>"Blue Blubber Jellies", "creator_id"=>2, "created_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "updated_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "role_name"=>nil},
 {"id"=>13, "caption"=>"Linne's two-toed sloths", "creator_id"=>2, "created_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "updated_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "role_name"=>nil},
 {"id"=>14, "caption"=>"Hosting millions of students and teachers", "creator_id"=>2, "created_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "updated_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "role_name"=>nil},
 {"id"=>15, "caption"=>"Hotel Front Entrance", "creator_id"=>5, "created_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "updated_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "role_name"=>nil},
 {"id"=>16, "caption"=>"Terrace", "creator_id"=>5, "created_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "updated_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "role_name"=>nil},
 {"id"=>17, "caption"=>"Cozy Corner", "creator_id"=>5, "created_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "updated_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "role_name"=>nil},
 {"id"=>18, "caption"=>"Fitness Center", "creator_id"=>5, "created_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "updated_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "role_name"=>nil},
 {"id"=>19, "caption"=>"Gallery Area", "creator_id"=>5, "created_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "updated_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "role_name"=>nil},
 {"id"=>20, "caption"=>"Harbor Room", "creator_id"=>5, "created_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "updated_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "role_name"=>nil},=>"organizer"}]
 {"id"=>21, "caption"=>"Indoor Pool", "creator_id"=>5, "created_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "updated_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "role_name"=>nil},
 {"id"=>22, "caption"=>"Lobby", "creator_id"=>5, "created_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "updated_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "role_name"=>nil},
 {"id"=>23, "caption"=>"Specialty King", "creator_id"=>5, "created_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "updated_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "role_name"=>nil},
 {"id"=>24, "caption"=>"Aquarium", "creator_id"=>6, "created_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "updated_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "role_name"=>nil},
 {"id"=>25, "caption"=>"Bromo Tower", "creator_id"=>7, "created_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "updated_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "role_name"=>nil},
 {"id"=>26, "caption"=>"Federal Hill", "creator_id"=>8, "created_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "updated_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "role_name"=>nil},
 {"id"=>27, "caption"=>"Row Homes", "creator_id"=>3, "created_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "updated_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "role_name"=>nil},
 {"id"=>28, "caption"=>"Skyline Water Level", "creator_id"=>3, "created_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "updated_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "role_name"=>nil},
 {"id"=>29, "caption"=>"Skyline", "creator_id"=>8, "created_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "updated_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "role_name"=>nil},
 {"id"=>30, "caption"=>"Visitor Center", "creator_id"=>5, "created_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "updated_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "role_name"=>nil},
 {"id"=>31, "caption"=>"World Trade Center", "creator_id"=>4, "created_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "updated_at"=>Wed, 15 Apr 2020 05:22:04 UTC +00:00, "role_name"=>"organizer"}]
=end