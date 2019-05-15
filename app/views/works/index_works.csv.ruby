require 'csv'

CSV.generate do |csv|
  column_names = %w(work_date time_in time_out)
  csv << column_names
  @works.each do |work|
    column_values = [
      work.work_date,
      work.time_in,
      work.time_out
    ]
    csv << column_values
  end
end