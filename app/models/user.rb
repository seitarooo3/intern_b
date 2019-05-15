class User < ApplicationRecord
  has_many :works, dependent: :destroy
  has_many :month_approvals, dependent: :destroy
  has_many :over_approvals, dependent: :destroy
  has_many :work_logs, dependent: :destroy
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      # IDが見つかれば、レコードを呼び出し、見つかれなければ、新しく作成
      user = find_by(id: row["id"]) || new
      
      # CSVからデータを取得し、設定する
      user.attributes = row.to_hash.slice(*updatable_attributes)
      
      # 保存する
      user.save!
  
    end
  end

  # csv更新を許可するカラムを定義
  def self.updatable_attributes
    ["id", "email","name", "dep", "employee_id", "card_id", "basic_time", "designed_time_in", "designed_time_out", "sup", "admin", "password"]
  end
  
end
