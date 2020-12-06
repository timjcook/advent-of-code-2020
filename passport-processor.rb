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

class PassportRequirementScanner
  attr_reader :passport

  def scan(passport:)
    @passport = passport
    required_fields_present?
  end

  private

  def required_fields_present?
    [
      passport.byr[:value],
      passport.iyr[:value],
      passport.eyr[:value],
      passport.hgt[:value],
      passport.hcl[:value],
      passport.ecl[:value],
      passport.pid[:value],
      passport.cid[:value]
    ].reduce(true) { |acc, attr| acc && !attr.nil? }
  end
end

class AlteredPassportRequirementScanner
  attr_reader :passport

  def scan(passport:)
    @passport = passport
    required_fields_present?
  end

  private

  def required_fields_present?
    [
      passport.byr[:value],
      passport.iyr[:value],
      passport.eyr[:value],
      passport.hgt[:value],
      passport.hcl[:value],
      passport.ecl[:value],
      passport.pid[:value]
    ].reduce(true) { |acc, attr| acc && !attr.nil? }
  end
end

class PassportValidityScanner
  attr_reader :passport

  def scan(passport:)
    @passport = passport
    fields_valid?
  end

  private

  def fields_valid?
    [
      byr_valid?,
      iyr_valid?,
      eyr_valid?,
      hgt_valid?,
      hcl_valid?,
      ecl_valid?,
      pid_valid?,
      cid_valid?
    ].reduce(:&)
  end

  def byr_valid?
    byr = passport.byr[:value]
    !byr.nil? && byr.between?(1920, 2002)
  end

  def iyr_valid?
    iyr = passport.iyr[:value]
    !iyr.nil? && iyr.between?(2010, 2020)
  end

  def eyr_valid?
    eyr = passport.eyr[:value]
    !eyr.nil? && eyr.between?(2020, 2030)
  end

  def hgt_valid?
    hgt = passport.hgt[:value]
    return false if hgt.nil? || passport.hgt[:unit].nil?
    return hgt.between?(150, 193) if passport.hgt[:unit] == :cm
    return hgt.between?(59, 76) if passport.hgt[:unit] == :inches

    false
  end

  def hcl_valid?
    /^#[0-9a-f]{6}$/.match?(passport.hcl[:value])
  end

  def ecl_valid?
    %w(amb blu brn gry grn hzl oth).include?(passport.ecl[:value])
  end

  def pid_valid?
    /^\d{9}$/.match?(passport.pid[:value])
  end

  def cid_valid?
    true
  end
end

class PassportBatchProcessor
  def initialize(requirement_scanner:, validity_scanner:, raw_passport_data:)
    @requirement_scanner = requirement_scanner
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

  attr_reader :requirement_scanner, :validity_scanner, :passports, :validity_report

  def generate_report
    passports.map do |p|
      PassportReport.new(
        passport: p,
        valid: requirement_scanner.scan(passport: p) && validity_scanner.scan(passport: p)
      )
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
      byr: generate_byr(byr: passport_attributes[:byr]),
      iyr: generate_iyr(iyr: passport_attributes[:iyr]),
      eyr: generate_eyr(eyr: passport_attributes[:eyr]),
      hgt: generate_hgt(hgt: passport_attributes[:hgt]),
      hcl: generate_hcl(hcl: passport_attributes[:hcl]),
      ecl: generate_ecl(ecl: passport_attributes[:ecl]),
      pid: generate_pid(pid: passport_attributes[:pid]),
      cid: generate_cid(cid: passport_attributes[:cid])
    )
  end

  def generate_byr(byr:)
    {
      value: !byr.nil? ? byr.to_i : nil,
      type: :year
    }
  end

  def generate_iyr(iyr:)
    {
      value: !iyr.nil? ? iyr.to_i : nil,
      type: :year
    }
  end

  def generate_eyr(eyr:)
    {
      value: !eyr.nil? ? eyr.to_i : nil,
      type: :year
    }
  end

  def generate_hgt(hgt:)
    hgtUnit = nil
    hgtUnit = :cm if /cm$/.match?(hgt)
    hgtUnit = :inches if /in$/.match?(hgt)

    {
      value: (!hgt.nil?) ? hgt.sub(/cm|in/, '').to_i : nil,
      unit: hgtUnit,
      type: :measurement
    }
  end

  def generate_hcl(hcl:)
    {
      value: !hcl.nil? ? hcl : nil,
      type: :hex_color
    }
  end

  def generate_ecl(ecl:)
    {
      value: !ecl.nil? ? ecl : nil,
      type: :color
    }
  end

  def generate_pid(pid:)
    {
      value: !pid.nil? ? pid : nil,
      type: :id_number
    }
  end

  def generate_cid(cid:)
    {
      value: !cid.nil? ? cid : nil,
      type: :id_number
    }
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
  requirement_scanner: PassportRequirementScanner.new,
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
  requirement_scanner: AlteredPassportRequirementScanner.new,
  validity_scanner: PassportValidityScanner.new,
  raw_passport_data: File.read('input-data/passport-data.txt')
)
print "Number of \"passports\" processed: " + alternative_batch_processor.num_passports.to_s + "\n"
print "Number of (almost) valid passports: " + alternative_batch_processor.num_valid_passports.to_s + "\n"
print "Number of (definitely) invalid passports: " + alternative_batch_processor.num_invalid_passports.to_s + "\n"

