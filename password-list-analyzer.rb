class PasswordListAnalyzer
  attr_reader :policy

  def initialize(policy)
    @policy = policy
  end

  def find
    tagged_passwords = password_list.map { |list_item|  TaggedPassword.new(list_item) }

    corruption_detector = create_corruption_detector
    tagged_passwords.map do |tp|
      {
        password: tp.password,
        valid: corruption_detector.analyze(tp)
      }
    end
  end

  private

  def create_corruption_detector
    if (policy == :sled)
      create_sled_hire_corruption_detector
    elsif (policy == :toboggan)
      create_toboggan_hire_corruption_detector
    else
      raise "Invalid Policy!"
    end
  end

  def create_sled_hire_corruption_detector
    SledHireCorruptionDetector.new
  end

  def create_toboggan_hire_corruption_detector
    TobogganHireCorruptionDetector.new
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

sled_hire_analyzer = PasswordListAnalyzer.new(:sled)
valid_sled_passwords = sled_hire_analyzer.find.filter { |p| p[:valid] }

print "Valid sled hire passwords: " + valid_sled_passwords.count.to_s + "\n"

toboggan_hire_analyzer = PasswordListAnalyzer.new(:toboggan)
valid_toboggan_passwords = toboggan_hire_analyzer.find.filter { |p| p[:valid] }

print "Valid sled hire passwords: " + valid_toboggan_passwords.count.to_s + "\n"