class PasswordListAnalyzer
  def find
    tagged_passwords = password_list.map { |list_item|  TaggedPassword.new(list_item) }

    tagged_passwords.map do |tp|
      cd = CorruptionDetector.new(tp)
      {
        password: tp.password,
        valid: cd.analyze
      }
    end
  end

  private

  def password_list
    @password_list ||= File.read('input-data/corrupt-passwords.txt').split("\n")
  end
end

class CorruptionDetector
  attr_reader :tagged_password

  def initialize(tagged_password)
    @tagged_password = tagged_password
  end

  def analyze
    required_letter = tagged_password.letter
    password = tagged_password.password

    required_letter_count = password.split('').count { |letter| letter == required_letter }

    required_letter_count >= tagged_password.min_range && required_letter_count <= tagged_password.max_range
  end
end

class TaggedPassword
  attr_reader :min_range, :max_range, :letter, :password

  def initialize(password_list_item)
    tagged_list_item = split_entry(password_list_item)

    @min_range = tagged_list_item[:min_range].to_i
    @max_range = tagged_list_item[:max_range].to_i
    @letter = tagged_list_item[:letter]
    @password = tagged_list_item[:password]
  end

  private

  def split_entry(list_item)
    split_list_item = list_item.split(" ")

    split_range = split_list_item[0].split("-")

    {
      min_range: split_range[0],
      max_range: split_range[1],
      letter: split_list_item[1].delete_suffix(":"),
      password: split_list_item[2]
    }
  end
end

password_list_analyzer = PasswordListAnalyzer.new
valid_passwords = password_list_analyzer.find.filter { |p| p[:valid] }

print valid_passwords.count.to_s + "\n"
