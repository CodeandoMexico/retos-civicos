module UserHelpers
  def new_member
    FactoryGirl.create(:user, userable: Member.new).userable
  end
  def new_organization
    FactoryGirl.create(:user, userable: Organization.new).userable
  end
end
