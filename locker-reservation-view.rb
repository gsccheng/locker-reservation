class LockerReservationView
  def initialize
  end

  def self.get_locker_config
    puts "Please enter locker information in the order of smallest to largest, followed by the quantity available for each locker. Type in the format of: size,quantity. Separate out each locker configuration with a space. For example: 'small,1000 medium,1000 large,1000'."
    gets.chomp
  end

  def self.get_user_action_from(available_actions)
    puts "Please choose an action for a locker by typing it out:"
    available_actions.each {|action| puts action}
    gets.chomp
  end

  def self.get_smallest_size_for_reservation
    puts "For your reservation, enter the smallest locker size that the contents will fit in."
    gets.chomp
  end

  def self.get_locker_id_for_return
    puts "Enter the id of the locker you would like to return:"
    input = gets.chomp
    input.to_i
  end

  def self.print_locker_ticket(locker)
    puts "\n"*2
    puts '+---------- LOCKER TICKET -----------+'
    puts '|                                    |'
    puts '|    You have reserved locker #:     |'
    printf("|               %4s                 |\n", locker.id)
    puts '|                                    |'
    puts '| Give this ticket to the concierge  |'
    puts '| to retrieve your bag               |'
    puts '+------------------------------------+'
    puts "\n"*2
  end

  def self.display_no_vacancy_error
    puts "Sorry, there are no available locker sizes for your size at this time."
  end
end
