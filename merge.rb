require 'csv'
csv_options = {headers: true, header_converters: :symbol}

bibs_to_times = CSV.read("timing.csv", csv_options).each_with_object({}) do |x, obj|
  obj[x[:name]] = x[:time]
end

# puts "bibs to times", bibs_to_times.inspect

bibs_to_reg = CSV.read("registrations.csv", csv_options).each_with_object({}) do |r, obj|
  # puts r
  obj[r[:bibno]] = r
end

racers = bibs_to_times.keys.each_with_object([])  do |bib, arr|
  time = bibs_to_times[bib]
  ob = bibs_to_reg[bib]
  ob[:time] = time
  arr.push(ob)
end

racers = racers.group_by{|x| x[:ticket_type]}

def result(racer)
  "#{racer[:first_name]}  #{racer[:last_name]} **#{racer[:time]}**"
end

def thanks
  """
Thanks Everyone for coming out. If there are any errors in the results,
please just create a github issue and I'll take care of it.

Special Thanks to the RubyConf Organizational team and sposors for making this conference possible!

The Mode Set Team.
  """
end

open("Readme.markdown", "wb") do |file|
  file.write("RubyConf 2012 5k/10k Results\n")
  file.write("============================\n\n")
  file.write(thanks)
  racers.keys.each do |key|
    file.write("#{key}\n")
    file.write("#{ '-' * key.length}\n")
    racers[key].each_with_index{|racer, index| file.write("#{index + 1}. #{result(racer)}\n")}
    file.write("\n")
  end
end


