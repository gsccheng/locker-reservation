#### Foreword

I am writing the program in Ruby as it is the language I am most comfortable in. I am also writing it solely in Ruby to keep the program lean and simple. With the program being so bare bones, I think talking about scalability at this point would be irrelevant. Finally, keeping it simple-- and would likely not be a good business decision due to the low ROI-- I have omitted any automated testing. However, if I were to implement it, I would probably use rspec and a gem like Highline to simulate user input from the command line.

#### Program Overview

This is a generic locker reservation program. The program does not have knowledge of the sizes and quantities of the lockers to be managed, and relies on the user to pass this information to it.

The purpose of this program is to demonstrate my current coding proficiency, particularly my understanding of writing OO and MVC code.

#### Instructions

To run the program, make sure you have Ruby 1.9.3 or higher installed.

Then, in your command line type 'ruby runner.rb'.

#### Planning the Architecture

From the program requirements, the user stories appears to be:

1. Concierge can assign a bag to the smallest available locker.
2. Concierge can see a desired ticket displayed so that it can be printed.
3. Concierge can unassign a bag from its locker so that the program accurately reflects the state of the lockers when a bag is retrieved.

Note that the customer themself is not interacting directly with the program, but instead directly with the interface that is the concierge. This concierge will interact with this program by sending it input, and receiving its output.

MVC
locker.rb: Locker model object
locker-reservation-view.rb: Locker Reservation view class
locker-reservation-controller.rb:  Locker Reservation controller class

Miscellaneous
runner.rb: Runner file to initiate the program

I decided that it wouldn't be appropriate to model the ticket as an object since it doesn't hold any unique and useful characteristics. It really is just a visual representation of a locker, which should be the responsibility of the view.

#### Pseudocode / Logic

runner.rb
require_relative 'locker-reservation-controller'
Runner: LockerReservationController.new.determine_user_action
  - Runner creates a locker reservation controller instance
  - Explicitly calling the method to prompt to set up the locker is more direct and idiomatic than calling it from the initialize method of the locker controller.

locker.rb
Class: Locker
attr_reader: id, size
attr_writer: is_reserved
Attributes:
  id
  size
  is_reserved
    - This attribute is not needed to write the functional program (reserved lockers can be kept track by the controller), but I include it because it captures the state of the locker which may be useful if new features are added or for debugging.
Methods:
  initialize(locker_params)
    @locker_id = locker_params[:id]
      - This is the unique locker number across all locker sizes
    @size = locker_params[:size]
    @reserved? = false

locker_reservation_controller.rb
require_relative 'locker-reservation-view'
require_relative 'locker'
Class: LockerReservationController
Attributes:
  vacant_lockers
    - This is a hash of arrays
    - We can then implement FIFO for reserving a locker
      - I assume there are lockers that the concierge will prefer to store a bag (lockers that are closer).
    - Removing and adding elements to the ends of an array is efficient.
  reserved_lockers
    - A hash instead of an array is used for more efficient lookup space and times. Order of reserved lockers is not needed.
  locker_sizes_smallest_first
  available_user_actions
Methods:
  initialize
    @reserved_lockers = {}
    @vacant_lockers = {}
    @locker_sizes_smallest_first = []
    @available_user_actions = ['reserve','return','exit']
    @highest_id_assigned_to_locker = 0
    set_up_lockers
  set_up_lockers
    - Prompts the concierge for size and number of lockers
    - From the problem statement, I interpret the responsibility of the program to reserve lockers for a variable number of lockers and sizes. Hence, it does not inherently know the sizes and quantities of lockers. This information will be sent as input from the user (concierge).
  set_vacant_lockers_and_sizes!(locker_config_arr)
    - While in the loop that goes through each locker size-qty pair, set up the instance variables of the vacant lockers and order of lockers by size
    - Use the helper method populate_vacant_lockers!(locker_info_hash)
  populate_vacant_lockers!(locker_info_hash)
    - Create locker objects and set them to the vacant_lockers instance variable
  determine_user_action
    - Asks the view to retrieve the user input for what action she wants to do next.
    - Uses the user input to direct to the corresponding method
  reserve_locker
    - Reserves a locker
    - Uses helper methods get_smallest_vacant_locker(locker_size_to_reserve), then reserve_locker!(locker_size_to_reserve) if there is a vacant locker of the right size
    - If there are no vacant lockers of the right size, have the view give a 'no vacancy' error.
    - Finally, loop back to the helper determine_user_action to determine the next action
  get_smallest_vacant_locker(locker_size)
    - Uses a loop to find the smallest vacant locker_size based on user requirements. It does this by checking if the array that holds the locker objects of the corresponding size are empty or not.
  reserve_locker!(size)
    - Descructive method to actually reserve the locker by removing a locker from the end of the array in @vacant_lockers and adds it to the @reserved_lockers hash
    - Updates the is_reserved attribute of the locker object to show as reserved
  return_locker!
    - Basically the opposite of the reserve_locker! method
    - Destructive method to remove the locker from the @reserved_lockers hash and append it back to the @vacant_lockers array in the appropriate hash for its size.
    - Updates the is_reserved attribute of the locker object to show as not reserved

locker_reservation_view.rb
Class: LockerReservationView
Methods:
  initialize
  self.get_locker_config
    - Prompts user for locker setup info and returns it
  self.get_user_action_from(available_actions)
    - Prompts user for an action from the list of available actions and returns it
  self.get_smallest_size_for_reservation
    - Prompts user for smallest locker the bag will fit in and returns it
  self.get_locker_id_for_return
    - Prompts user for the id of the locker they are trying to return, and returns it
  self.print_locker_ticket(locker)
    - Displays the graphic of the locker ticket that includes the locker id number
  self.display_no_vacancy_error
    - Displays the error message when there are no available lockers
