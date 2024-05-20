module UserMetrics
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def last_login
      where(is_system_user: 0).order(Sequel.desc(:user_mtime)).first[:user_mtime].to_s
    rescue
      "" # no users
    end
  end
end
