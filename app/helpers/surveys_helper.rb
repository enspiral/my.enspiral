module SurveysHelper
  def get_user_name(user)
    if user.class == User
      user.person.name
    else
      user
    end
  end
end
