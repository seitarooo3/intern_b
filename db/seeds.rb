User.create!(
  id: 1,
  name: "seinosuke",
  email: "seinosuke.aoki@gmail.com",
  uid: "takosei3",
  employee_number: 12345,
  password: "foobar",
  basic_work_time: "2019/02/20 07:30",
  work_time: "2019/02/20 07:30",
  admin: false,
  superior: false,
  affiliation: "consulting"
)

User.create!(
  id: 2,
  name: "konosuke",
  email: "konosuke.aoki@gmail.com",
  uid: "foobar",
  employee_number: 12345,
  password: "foobar",
  basic_work_time: "2019/02/20 07:30",
  work_time: "2019/02/20 07:30",
  admin: false,
  superior: true,
  affiliation: "boxer"
)

User.create!(
  id: 3,
  name: "takanosuke",
  email: "takanosuke.aoki@gmail.com",
  uid: "foobar",
  employee_number: 12345,
  password: "foobar",
  basic_work_time: "2019/02/20 07:30",
  work_time: "2019/02/20 07:30",
  admin: true,
  superior: false,
  affiliation: "sales"
)

User.create!(
  id: 4,
  name: "konosuke2",
  email: "konosuke2.aoki@gmail.com",
  uid: "foobar",
  employee_number: 12345,
  password: "foobar",
  basic_work_time: "2019/02/20 07:30",
  work_time: "2019/02/20 07:30",
  admin: false,
  superior: true,
  affiliation: "boxer"
)

Branch.create!(
  id: 1,
  branch_id: 1,
  branch_name: "Tokyo",
  work_type: "出勤"
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