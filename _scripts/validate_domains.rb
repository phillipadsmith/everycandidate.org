require 'csv'
require "net/http"
require "resolv-replace.rb" #for better socket errors"
require 'optparse'

CSV_ROW_OFFSET = 2 #the first row of users is the 2 row in the csv file, but the  [0] part of the array

## preload with known good and common email domains
VAILD_EMAIL_DOMAINS = ['gmail.com', 'yahoo.ca', 'yahoo.com', 'hotmail.com', 'aol.com',
 'sympatico.ca', 'rogers.com','rogers.ca', 'outlook.com','live.ca','live.com','bell.net',
 'msn.com']


def testUser(user_row, data_type, row_num, verbose)

  testColArr =[]
  testEmailColArr = []

  if data_type == 'council'
    testColArr = ["facebook", "twitter", "email", "email_alt", "website", "linkedin"]
    testEmailColArr = [ "email", "email_alt"]
    fullName_col = 'name_full'
  elsif data_type == 'tdsb'
    fullName_col = 'name_full'
    testColArr = [  "website", "facebook", "twitter"]
    testEmailColArr = ["email", "email_alt"]
  else
    return 0
  end
  errorArr = []






  testColArr.map do  |column_value|
    unless user_row[column_value] == nil
#      puts "#{user_row[fullName_col]}  #{isUserColumnValueURLError?(user_row,column_value, verbose)} for #{user_row[column_value]}" if verbose

      errorArr.push(user_row[column_value]) if isUserColumnValueURLError?(user_row, column_value, verbose)

      if verbose && errorArr.include?(user_row[column_value])
        print "\nLooks BAD : #{user_row[fullName_col]} for #{user_row[column_value]}"
      elsif verbose
        print "\nLooks GOOD : #{user_row[fullName_col]} for #{user_row[column_value]}"
      end

    end
  end






  testEmailColArr.map do |column_value|

    unless user_row[column_value] == nil
      puts "\nTESTING email of #{user_row[fullName_col]}  for #{user_row[column_value]}" if verbose

      if isVaildEmailStructure?(user_row[column_value])
        # check the domain of the email is good
        emailDomain = user_row[column_value].split('@')[1]
        #puts "emailDomain=#{emailDomain}"

        errorArr.push(user_row[column_value]) unless isVailsEmailDomain?(emailDomain, verbose)



      else
        errorArr.push(user_row[column_value])
      end

      if verbose && errorArr.include?(user_row[column_value])
        print "\nemail Looks BAD : #{user_row[fullName_col]} for #{user_row[column_value]}"
      elsif verbose
        print "\nemail Looks GOOD : #{user_row[fullName_col]} for #{user_row[column_value]}"
      end

    end
  end





  print "\n #{errorArr.length} Error(s) found for #{user_row[fullName_col]} on file row #{row_num + CSV_ROW_OFFSET} >>" if  errorArr.length > 0
  errorArr.each do |error|
     print "\t#{error}"
  end
  print "\n" if  errorArr.length > 0

  print "\nAll Good for #{user_row[fullName_col]} on file row #{row_num + CSV_ROW_OFFSET} >>\n"  if verbose && errorArr.length == 0



  return errorArr.length


end

def isVailsEmailDomain?(emailDomain, verbose)

  emailDomain.downcase!

  return true if VAILD_EMAIL_DOMAINS.include?( emailDomain )

  puts "testing new email Domain=#{emailDomain}" if verbose

  if !fetch(emailDomain.gsub(/\s+/, ""), verbose)
    return false
  else
    VAILD_EMAIL_DOMAINS.push(emailDomain)
    return true
  end


end

def isUserColumnValueURLError?(user_row, col_num, verbose )

  get_value_to_test = user_row[col_num]

  return false if get_value_to_test == nil #nothing to test
  get_value_to_test = get_value_to_test.strip #trim leading and trail spaces
  return true if get_value_to_test.match(' ') #if there  are spaces inside the url its bad

  return !fetch(get_value_to_test.gsub(/\s+/, ""), verbose) unless get_value_to_test == nil

end





def fetch(uri_str, limit = 10, verbose)

  debug = false # or true to see various extra noise

  begin
    uri = URI uri_str
    scheme = uri.scheme
    puts scheme if debug
    uri_str = "http://"+uri_str unless scheme

  rescue => e
    puts "ERROR for #{uri_str} is #{e}"
    return  false
  end



  raise ArgumentError, 'too many HTTP redirects' if limit == 0


  begin

  response = Net::HTTP.get_response(URI(uri_str))
  rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
         Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
   puts "Error for #{uri_str} is #{e}"
 rescue Net::HTTPServerException => e
    puts "Error(Net::HTTPServerException) for #{uri_str} is #{e.response}"
  rescue Net::HTTPExceptions => e
    puts "Error(Net::HTTPExceptions) for #{uri_str} is #{e.response}"
    rescue Errno::ENOENT
   puts "ERROR for #{uri_str}  >> can't find the server"
 rescue Net::HTTPClientError => e
    puts "ERROR TIMEOUT for #{uri_str} is #{e}"
  rescue Timeout::Error => e
    puts "ERROR TIMEOUT for #{uri_str} is #{e}"
  rescue StandardError => e

     puts "#{uri_str} ERROR is #{e}" if debug
     return false
  #  puts e.inspect
    # return false
  rescue => e
#    puts "ERROR for #{uri_str} is #{e.code}" if e.code
    puts "ERROR for #{uri_str} is #{e}"
    return  false
  end

  case response
  when Net::HTTPSuccess then
    #puts "\n#{uri_str} is OK #{response.code}" if verbose
    return true
    #response
  when Net::HTTPRedirection then
    location = response['location']
    puts "\n#{uri_str} redirected to #{location}" if verbose
#    puts "fetch>redirected verbose=#{verbose}"
    return fetch(location, limit - 1, verbose)
  else

    puts "\n#{uri_str} ERROR is #{response.code} :: #{response.message}" if verbose
    return false
  end
end

def validateCsvHeader(headerRow, file_type)

  validHeaders = []

  if file_type == 'council'
      validHeaders = ["candidate_id", "name_first", "name_last", "name_full", "ward", "postalcode", "incumbent", "ran_2010", "ran_2006", "contribute_2010", "contribute_2006", "lobbyist_registry", "phone_old", "phone", "campaign_office", "phone_cell", "phone_home", "address", "facebook", "twitter", "email", "email_alt", "website", "linkedin", "nomination_date", "slug", "sorby"]
  elsif file_type == 'tdsb'
      validHeaders = ["candidate_id", "school_ward", "name_last", "name_first", "name_full", "incumbent", "email", "email_alt", "phone", "phone_campaign_office", "phone_cell", "phone_home", "address", "web", "facebook", "twitter", "misc", "nomination_date", "nomination_date_nice", "sortby", "slug"]
  else
      return false
  end
  x = 0
  validHeaders.each do |column|
#    puts "column= #{column}  and expecting #{validHeaders[x]} "
    if  column != validHeaders[x]
      return false
    end
    x += 1
  end

  if headerRow.length > validHeaders.length
    puts  "Hmm ... the header columns for the #{file_type} is LONGER than expected\n"
  end

  return true

end

# is the email address a string of vaild strtucture
def isVaildEmailStructure?(emailStr)
  #a simple regexp that requires only string@string.string
  email_regexp = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
  return (emailStr =~ email_regexp )
end


def runOnRow?(rowIndex, listArr, skipArr )

  if ! (listArr || skipArr) #neither list or skip or set then do run row
    return true
  elsif skipArr && skipArr.include?(rowIndex) #if its in the skip  arrary then do not run row
    return false
  elsif listArr && listArr.include?(rowIndex) #if it in the list array then do run row
      return true
  elsif listArr && !listArr.include?(rowIndex) #if doing lists and not in the list array then do not run row
    return false
  else
      return true
  end

end


##>> Main starts here>>

start = Time.now

options = {}

ARGV.push('-h') if ARGV.empty?
ARGV.push('-h') if ARGV[0].empty?

typeErrorMsg = ' where <type> is council or tdsb'

OptionParser.new do |opts|
  opts.banner = "Usage: example.rb <type> [options], \n   "+typeErrorMsg


  opts.on("-v", "--verbose", "Run verbosely") do |v|
    options[:verbose] = v
  end

  opts.on("-l", "--list 3,17,123", Array, "Run ony the list of row numbers") do |l|
    options[:list] =  l
  end

  opts.on("-s", "--skip 3,17,123", Array, "skip row numbers listed (known to be trouble or blownup-y)") do |l|
    options[:skip] =  l
  end

  # This displays the help screen, all programs are assumed to have this option.
  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    exit
  end

end.parse!

# puts "list = #{options[:list]}"
# puts "skip = #{options[:skip]}"

data_type = ARGV.pop

unless data_type
  puts "Need to specify a <type> to process, "+typeErrorMsg
  exit
end

#covert strings to integer and then sort, drop the row number down 2
options[:list].map!(&:to_i).sort!.map!{|i| i - CSV_ROW_OFFSET} if options[:list]
options[:skip].map!(&:to_i).sort!.map!{|i| i - CSV_ROW_OFFSET} if options[:skip]
#remove skip from list, just in case
options[:list] = options[:list] - options[:skip] if options[:skip] &&  options[:list]

# puts "list = #{options[:list]}"
# puts "skip = #{options[:skip]}"

# p options
# p ARGV


#user_type = ARGV[0]
#puts  user_type
data_type = data_type.downcase unless data_type.nil?

filename = ""
if data_type == 'council'
    filename = '_data/toronto_council.csv'
elsif data_type == 'tdsb'
  filename = '_data/toronto_school_board.csv'
else
    puts "Need to specify a <type> to process, "+typeErrorMsg
    exit
end




row_num  = 0
err_count = 0

puts  "Testing #{data_type} file #{filename}"

csv = CSV.read(filename, headers:true)

# if validateCsvHeader(csv[0], user_type)
#   puts  "the header columns for file #{filename} look okay\n"
# else
#   puts  "ERROR, the header columns for file #{filename} DON'T look right!\n"
#   exit
# end

csv.each_with_index do |row, index |
  #puts "#{index} #{row['name_full']}  #{row[22]} "

  runOnRow = runOnRow?(index, options[:list], options[:skip])
  puts "Skipping row #{index + CSV_ROW_OFFSET} for #{row['name_full']} " if ((!runOnRow) && options[:verbose] && !options[:list]  )

  print "=" if runOnRow
#  err_count += testUser(row, data_type, index, options[:verbose]) if !options[:list] || options[:list].include?(index)
  err_count += testUser(row, data_type, index, options[:verbose]) if runOnRow



  row_num += 1

#  break if index >   10

end
row_num = options[:list].length if options[:list]
row_num -= options[:skip].length if options[:skip]

print "\nDONE : #{row_num} file users examined; #{err_count} ERRORS Found in #{data_type} file #{filename}\n"
puts "Duration: #{Time.now - start} seconds"

puts  "#{VAILD_EMAIL_DOMAINS}"

