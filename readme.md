### Foreword

I am writing the program in Ruby as it is the language I am most comfortable in. I am also writing it solely in Ruby to keep the program lean and simple. With the program being so bare bones, I think talking about scalability at this point would be irrelevant. Finally, keeping it simple-- and would likely not be a good business decision due to the low ROI-- I have omitted any automated testing. However, if I were to implement it, I would probably use rspec and a gem like Highline to simulate user input from the command line.

### Program Overview

This is a generic locker reservation program. The program does not have knowledge of the sizes and quantities of the lockers to be managed, and relies on the user to pass this information to it.

The purpose of this program is to demonstrate my current coding proficiency, particularly my understanding of writing OO and MVC code.

### Instructions

To run the program, make sure you have Ruby 1.9.3 or higher installed.

Then, in your command line type 'ruby runner.rb'.

### Planning the Architecture

From the program requirements, the user stories appears to be:

1. Concierge can assign a bag to the smallest available locker.
2. Concierge can see a desired ticket displayed so that it can be printed.
3. Concierge can unassign a bag from its locker so that the program accurately reflects the state of the lockers when a bag is retrieved.

Note that the customer themself is not interacting directly with the program, but instead directly with the interface that is the concierge. This concierge will interact with this program by sending it input, and receiving its output.

###### MVC
- *locker.rb*: Locker model object

- *locker-reservation-view.rb*: Locker Reservation view class
- *locker-reservation-controller.rb*:  Locker Reservation controller class

###### Miscellaneous
- *runner.rb*: Runner file to initiate the program

I decided that it wouldn't be appropriate to model the ticket as an object since it doesn't hold any unique and useful characteristics. It really is just a visual representation of a locker, which should be the responsibility of the view.
