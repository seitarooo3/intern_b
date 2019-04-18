User.create!(
  id: 1,
  name: "seinosuke",
  email: "seinosuke.aoki@gmail.com",
  card_id: "takosei3",
  employee_id: 12345,
  password: "takosei3",
  basic_time: "2019/02/20 07:30",
  work_time: "2019/02/20 07:30",
  admin: true,
  sup: true,
  dep: "consulting"
)

User.create!(
  id: 2,
  name: "takanosuke",
  email: "takanosuke.aoki@gmail.com",
  card_id: "takosei3",
  employee_id: 12345,
  password: "takosei3",
  basic_time: "2019/02/20 07:30",
  work_time: "2019/02/20 07:30",
  admin: false,
  sup: false,
  dep: "sales"
)

Branch.create!(
  id: 1,
  branch_id: 1,
  branch_name: "Tokyo",
  branch_status: false
)

# 59.times do |n|
#   name  = Faker::Name.name
#   email = "email#{n+1}@sample.com"
#   password = "password"
#   User.create!(name:  name,
#               email: email,
#               password:              password,
#               password_confirmation: password)
# end