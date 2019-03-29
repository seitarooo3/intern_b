User.create!(
  id: 1,
  name: "seinosuke",
  email: "seinosuke.aoki@gmail.com",
  password: "takosei3",
  basic_time: "2019/02/20 07:30",
  work_time: "2019/02/20 07:30",
  admin: true,
  dep: "consulting"
)

59.times do |n|
  name  = Faker::Name.name
  email = "email#{n+1}@sample.com"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end