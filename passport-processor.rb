class Passport
  attr_reader :byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid, :cid
  
  def initialize (byr:, iyr:, eyr:, hgt:, hcl:, ecl:, pid:, cid:)
    @byr = byr
    @iyr = iyr
    @eyr = eyr
    @hgt = hgt
    @hcl = hcl
    @ecl = ecl
    @pid = pid
    @cid = cid
  end
end

class PassportReport
  def initialize(passport:, valid:)
    @passport = passport
    @valid = valid
  end

  def valid?
    valid
  end

  private

  attr_reader :valid
end

class PassportValidityScanner
  def scan(passport:)
    PassportReport.new(
      passport: passport,
      valid: passport_valid?(passport: passport)
    )
  end

  private

  def passport_valid?(passport:)
    [
      passport.byr,
      passport.iyr,
      passport.eyr,
      passport.hgt,
      passport.hcl,
      passport.ecl,
      passport.pid,
      passport.cid
    ].reduce(true) { |acc, attr| acc && !!attr }
  end
end

class AlteredPassportValidityScanner
  def scan(passport:)
    PassportReport.new(
      passport: passport,
      valid: passport_valid?(passport: passport)
    )
  end

  private

  def passport_valid?(passport:)
    [
      passport.byr,
      passport.iyr,
      passport.eyr,
      passport.hgt,
      passport.hcl,
      passport.ecl,
      passport.pid
    ].reduce(true) { |acc, attr| acc && !!attr }
  end
end

class PassportBatchProcessor
  def initialize(validity_scanner:, raw_passport_data:)
    @validity_scanner = validity_scanner
    @passports = process_passport_data(raw_passport_data: raw_passport_data)

    @validity_report = generate_report
  end

  def num_passports
    validity_report.count
  end

  def num_valid_passports
    validity_report.filter { |item| item.valid? }.count
  end

  def num_invalid_passports
    validity_report.filter { |item| !item.valid? }.count
  end

  private

  attr_reader :validity_scanner, :passports, :validity_report

  def generate_report
    passports.map do |p|
      validity_scanner.scan(passport: p)
    end
  end

  def process_passport_data(raw_passport_data:)
    process_raw_attributes(
      raw_passport_lines: raw_passport_data.split("\n\n").map { |line| line.split(/\s/) }
    ).map do |attrs|
      generate_passport(passport_attributes: attrs)
    end
  end

  def generate_passport(passport_attributes:)
    Passport.new(
      byr: passport_attributes[:byr],
      iyr: passport_attributes[:iyr],
      eyr: passport_attributes[:eyr],
      hgt: passport_attributes[:hgt],
      hcl: passport_attributes[:hcl],
      ecl: passport_attributes[:ecl],
      pid: passport_attributes[:pid],
      cid: passport_attributes[:cid]
    )
  end

  def process_raw_attributes(raw_passport_lines:)
    raw_passport_lines.map do |line|
      line.reduce({
        byr: nil,
        iyr: nil,
        eyr: nil,
        hgt: nil,
        hcl: nil,
        ecl: nil,
        pid: nil,
        cid: nil
      }) do |acc, value|
        split_value = value.split(':')
        acc[split_value[0].to_sym] = split_value[1]
        acc
      end
    end
  end
end


batch_processor = PassportBatchProcessor.new(
  validity_scanner: PassportValidityScanner.new,
  raw_passport_data: File.read('input-data/passport-data.txt'),
)
print "Number of passports processed: " + batch_processor.num_passports.to_s + "\n"
print "Number of valid passports: " + batch_processor.num_valid_passports.to_s + "\n"
print "Number of invalid passports: " + batch_processor.num_invalid_passports.to_s + "\n"
print "\n"
print "And with a slight tweak...\n"
print "\n"

alternative_batch_processor = PassportBatchProcessor.new(
  validity_scanner: AlteredPassportValidityScanner.new,
  raw_passport_data: File.read('input-data/passport-data.txt'),
)
print "Number of \"passports\" processed: " + alternative_batch_processor.num_passports.to_s + "\n"
print "Number of (almost) valid passports: " + alternative_batch_processor.num_valid_passports.to_s + "\n"
print "Number of (definitely) invalid passports: " + alternative_batch_processor.num_invalid_passports.to_s + "\n"

