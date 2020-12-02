class ExpenseReportParser
  def initialize(report_path, num_values_to_compare)
    @report_path = report_path
    @num_values_to_compare = num_values_to_compare
  end

  attr_reader :report_path, :values_to_compare

  def find_anomaly
    compare_values(expense_report, @num_values_to_compare, [])
  end

  private

  def expense_report
    @expense_report ||= File.read(report_path).split.map(&:to_i)
  end

  def is_anomaly?(values)
    values.reduce(:+) == 2020
  end

  def compare_values(report_lines, num_values_to_compare, current_values)
    if (num_values_to_compare == 0)
      if (is_anomaly?(current_values))
        return current_values
      else
        return []
      end
    end

    report_lines.each_with_index do |value, index|
      remaining_report_lines = report_lines.reject.with_index { |n, i| i == index }

      results = compare_values(
        remaining_report_lines,
        num_values_to_compare - 1,
        [].push(current_values).push(value).flatten
      )

      return results if results.count > 0
    end

    return []
  end
end


parser = ExpenseReportParser.new('input-data/expense-report.txt', 3)
results = parser.find_anomaly

if (results.count == 0)
  print "No results found.\n"
else
  print results.to_s + "\n"
  print (results.reduce(:*)).to_s + "\n"
end
