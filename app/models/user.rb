class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :confirmable
  has_and_belongs_to_many :roles
  has_many :providers, dependent: :destroy
  validates_presence_of :email
  after_create :default_role
  def role?(role)
    return !!self.roles.find_by_name(role.to_s)
  end
  
  def self.from_omniauth(auth, signed_in_resource=nil)
    provider = Provider.where(:provider_name => auth.provider, :uuid => auth.uid.to_s).first
    if provider
      return provider.user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        Provider.create(:uuid => auth.uid, :provider_name => auth.provider, :user_id => registered_user.id)
        return registered_user
      else
        user = User.create(email:auth.info.email,password:Devise.friendly_token[0,20],)
        Provider.create(:uuid => auth.uid, :provider_name => auth.provider, :user_id => user.id)
        return user
      end
    end
  end 
  
  private
  def default_role
    self.roles << Role.create!(:name => "user")
  end
end
