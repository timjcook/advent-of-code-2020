class PasswordListAnalyzer
  attr_reader :corruption_detector

  def initialize(corruption_detector:)
    @corruption_detector = corruption_detector
  end

  def valid_passwords
    classify_passwords.filter { |p| p[:valid] }
  end

  private

  attr_reader :passwords

  def classify_passwords
    tagged_passwords.map do |tp|
      {
        password: tp.password,
        valid: corruption_detector.analyze(tp)
      }
    end
  end

  def tagged_passwords
    @tagged_passwords ||= password_list.map { |list_item|  TaggedPassword.new(list_item) }
  end

  def password_list
    @password_list ||= File.read('input-data/corrupt-passwords.txt').split("\n")
  end
end

class SledHireCorruptionDetector
  def analyze(tagged_password)
    required_letter = tagged_password.letter
    password = tagged_password.password

    required_letter_count = password.split('').count { |letter| letter == required_letter }

    required_letter_count >= tagged_password.lower_number && required_letter_count <= tagged_password.upper_number
  end
end

class TobogganHireCorruptionDetector
  def analyze(tagged_password)
    required_letter = tagged_password.letter
    password = tagged_password.password

    position_a = password[tagged_password.lower_number - 1] == required_letter
    position_b = password[tagged_password.upper_number - 1] == required_letter

    position_a ^ position_b
  end
end

class TaggedPassword
  attr_reader :lower_number, :upper_number, :letter, :password

  def initialize(password_list_item)
    tagged_list_item = split_entry(password_list_item)

    @lower_number = tagged_list_item[:lower_number].to_i
    @upper_number = tagged_list_item[:upper_number].to_i
    @letter = tagged_list_item[:letter]
    @password = tagged_list_item[:password]
  end

  private

  def split_entry(list_item)
    split_list_item = list_item.split(" ")

    split_range = split_list_item[0].split("-")

    {
      lower_number: split_range[0],
      upper_number: split_range[1],
      letter: split_list_item[1].delete_suffix(":"),
      password: split_list_item[2]
    }
  end
end

sled_hire_analyzer = PasswordListAnalyzer.new(
  corruption_detector: SledHireCorruptionDetector.new
)
toboggan_hire_analyzer = PasswordListAnalyzer.new(
  corruption_detector: TobogganHireCorruptionDetector.new
)

print "Valid sled hire passwords: " + sled_hire_analyzer.valid_passwords.count.to_s + "\n"
print "Valid toboggan hire passwords: " + toboggan_hire_analyzer.valid_passwords.count.to_s + "\n"