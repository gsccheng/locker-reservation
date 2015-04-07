class Locker
  attr_reader :id, :size
  attr_writer :is_reserved

  def initialize(locker_params)
    @id = locker_params[:id]
    @size = locker_params[:size]
    @is_reserved = false
  end
end
