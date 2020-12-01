class ExpenseReportParser
  def initialize(report_path)
    @report_path = report_path
  end

  attr_reader :report_path

  def find_anomoly
    compare_report_lines
  end

  private

  def expense_report
    @expense_report ||= File.read(report_path).split.map(&:to_i)
  end

  def is_anomoly?(value1, value2)
    value1 + value2 == 2020
  end

  def compare_report_lines
    expense_report.each_with_index do |v1, index1|
      expense_report.each_with_index do |v2, index2|
        unless index1 == index2
          if is_anomoly?(v1, v2)
            return { value1: v1, value2: v2 }
          end
        end
      end
    end
  end
end


parser = ExpenseReportParser.new('input-data/expense-report.txt')
results = parser.find_anomoly

print (results[:value1] * results[:value2]).to_s + "\n"
