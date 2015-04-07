require_relative 'locker-reservation-view'
require_relative 'locker'

class LockerReservationController
  def initialize
    # Although not all instance variables need to be initialized in this method, I place them here so that the developer can see all the instance variables that are used for this controller.
    @reserved_lockers = {}
    @vacant_lockers = {}
    @locker_sizes_smallest_first = []
    @available_user_actions = ['reserve','return','exit']

    # Locker ids will be assigned incrementally starting from 1
    @highest_id_assigned_to_locker = 0

    set_up_lockers
  end

  def set_up_lockers
    # locker_config_from_user consists of all locker sizes and their quantities
    locker_config_from_user = LockerReservationView.get_locker_config
    locker_config_arr = locker_config_from_user.split
    set_vacant_lockers_and_sizes!(locker_config_arr)
  end

  def set_vacant_lockers_and_sizes!(locker_config_arr)
    # As instructed to the user in the view, locker_config_arr information is delimited by commas
    locker_config_arr.each do |locker_type|
      locker_info = locker_type.split(',')
      locker_size = locker_info[0]
      locker_size_qty = locker_info[1].to_i

      # locker_config_arr argument lists lockers already sorted from smallest to largest in size
      @locker_sizes_smallest_first.push(locker_size)

      populate_vacant_lockers!({locker_size: locker_size, locker_size_qty: locker_size_qty})
    end
  end

  def populate_vacant_lockers!(locker_info_hash)
    arr_of_lockers =
    Array((@highest_id_assigned_to_locker+1)..(@highest_id_assigned_to_locker+locker_info_hash[:locker_size_qty])).map do |id|
      Locker.new({
        id: id,
        size: locker_info_hash[:locker_size]
        })
    end
    @vacant_lockers[locker_info_hash[:locker_size]] = arr_of_lockers
    @highest_id_assigned_to_locker += locker_info_hash[:locker_size_qty]
  end

  def determine_user_action
    user_action = LockerReservationView.get_user_action_from(@available_user_actions)
    case user_action
    when 'reserve'
      reserve_locker
    when 'return'
      return_locker!
    when 'exit'
    end
  end

  def reserve_locker
    locker_size_to_reserve = LockerReservationView.get_smallest_size_for_reservation
    locker_size_to_reserve = get_smallest_vacant_locker(locker_size_to_reserve)
    if locker_size_to_reserve
      reserve_locker!(locker_size_to_reserve)
    else
      LockerReservationView.display_no_vacancy_error
    end
    determine_user_action
  end

  def get_smallest_vacant_locker(locker_size)
    size_array_index = @locker_sizes_smallest_first.index(locker_size)
    @locker_sizes_smallest_first[size_array_index...@locker_sizes_smallest_first.length].find do |size|
      @vacant_lockers[size].any?
    end
  end

  def reserve_locker!(size)
    locker_to_reserve = @vacant_lockers[size].pop
    locker_to_reserve.is_reserved = true
    @reserved_lockers[locker_to_reserve.id] = locker_to_reserve
    LockerReservationView.print_locker_ticket(locker_to_reserve)
  end

  def return_locker!
    locker_id_to_return = LockerReservationView.get_locker_id_for_return
    locker_to_return = @reserved_lockers.delete(locker_id_to_return)
    locker_to_return.is_reserved = false
    @vacant_lockers[locker_to_return.size].push(locker_to_return)
    determine_user_action
  end
end
