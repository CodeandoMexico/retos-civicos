module UserHelpers
  def new_member
    FactoryBot.create(:user, userable: Member.new).userable
  end

  def new_organization
    FactoryBot.create(:user, userable: build(:organization)).userable
  end

  def new_user
    FactoryBot.create(:user)
  end
end
