require 'csv'
require "net/http"
require "resolv-replace.rb" #for better socket errors"




def testUser(user_row, user_type, row_num)
  # id_col = 0


  testColArr =[]
  testEmailColArr = []

  if user_type == 'council'
    testColArr = [18, 19, 22, 23 ]
    testEmailColArr = [20,21]
    fullName_col = 3
  elsif user_type == 'tdsb'
    fullName_col = 4
    testColArr = [13, 14, 15 ]
    testEmailColArr = [5,6]
  else
    return 0
  end
  errorArr = []

#  testColArr.each do  |column_value|
  testColArr.map do  |column_value|
    unless user_row[column_value] == nil
#      puts "#{user_row[fullName_col]} ERROR #{isUserColumnValueURLError?(user_row,column_value)} for #{user_row[column_value]}"
      errorArr.push(user_row[column_value]) if isUserColumnValueURLError?(user_row,column_value)
    end
  end

  print "\n #{errorArr.length} Error(s) found for #{user_row[fullName_col]} on file row #{row_num} >>" if  errorArr.length > 0
  errorArr.each do |error|
     print "\t#{error}"
  end
  print "\n" if  errorArr.length > 0

  return errorArr.length


end

def isUserColumnValueURLError?(user_row, col_num)
  get_value_to_test = user_row[col_num]

  return false if get_value_to_test == nil #nothing to test
  get_value_to_test = get_value_to_test.strip #trim leading and trail spaces
  return true if get_value_to_test.match(' ') #if there  are spaces inside the url its bad

  return !fetch(get_value_to_test.gsub(/\s+/, "")) unless get_value_to_test == nil

end





def fetch(uri_str, limit = 10)


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
    puts "#{uri_str} is OK #{response.code}" if debug
    return true
    #response
  when Net::HTTPRedirection then
    location = response['location']
    warn "redirected to #{location}" if debug
    return fetch(location, limit - 1)
  else

    puts "#{uri_str} ERROR is #{response.code} :: #{response.message}" if debug
    return false
  end
end

def validateCsvHeader(headerRow, user_type)

  validHeaders = []

  if user_type == 'council'
      validHeaders = ["candidate_id", "name_first", "name_last", "name_full", "ward", "postalcode", "incumbent", "ran_2010", "ran_2006", "contribute_2010", "contribute_2006", "lobbyist_registry", "phone_old", "phone", "campaign_office", "phone_cell", "phone_home", "address", "facebook", "twitter", "email", "email_alt", "website", "linkedin", "nomination_date", "slug", "sorby"]
  elsif user_type == 'tdsb'
      validHeaders = ["candidate_id", "school_ward", "name_last", "name_first", "name_full", "incumbent", "email", "email_alt", "phone", "phone_campaign_office", "phone_cell", "phone_home", "address", "web", "facebook", "twitter", "misc", "nomination_date", "nomination_date_nice", "sortby", "slug"]
  else
      return false
  end
  x = 0
  headerRow.each do |column|
#    puts "column= #{column}  and expecting #{validHeaders[x]} "
    if  column != validHeaders[x]
      return false
    end
    x += 1
  end

  return true

end



user_type = ARGV[0]
#puts  user_type
user_type = user_type.downcase unless user_type.nil?

filename = ""
if user_type == 'council'
    filename = '_data/toronto_council.csv'
elsif user_type == 'tdsb'
  filename = '_data/toronto_school_board.csv'
else
    puts 'Usage: ruby _scripts/validate_domains.rb [switches]'
    puts '  council      load and vaildiate toronto council file.'
    puts '  tdsb                 load and vaildiate toronto toronto district school board file.'
    puts '  help                 show this message.'
    exit
end




row_num  = 0
err_count = 0

puts  "Testing #{user_type} file #{filename}"

csv = CSV.read(filename)

if validateCsvHeader(csv[0], user_type)
  puts  "the header columns for file #{filename} look okay\n"
else
  puts  "ERROR, the header columns for file #{filename} DON'T look right!\n"
  exit
end

csv.each do |row|
  #  puts "#{row_num} #{row[3]}  #{row[22]} " unless row_num == 0
  print "="
  err_count += testUser(row, user_type, row_num) unless row_num == 0
  #testUser(row, user_type, row_num) if  row_num == 180
  row_num += 1

 # break if row_num >   1000

end
print "\nDONE : #{row_num} examined; #{err_count} ERRORS Found in #{user_type} file #{filename}\n"


#ARGV.map {|url| fetch(url)}
