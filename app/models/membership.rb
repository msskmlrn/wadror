class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :beer_club

  validates :user, uniqueness: { scope: :beer_club,
                                 message: "can't join the same club twice" }

  scope :unconfirmed, -> { where confirmed:[nil,false] }
  scope :confirmed, -> { where confirmed: true}

end
