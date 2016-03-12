module UserHelpers
  def new_member
    FactoryGirl.create(:user, userable: Member.new).userable
  end

  def new_organization
    FactoryGirl.create(:user, userable: build(:organization)).userable
  end

  def new_user
    FactoryGirl.create(:user)
  end
end
