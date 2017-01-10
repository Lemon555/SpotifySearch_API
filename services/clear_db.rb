# frozen_string_literal: true

# Clear Database when worker calls
class ClearDB
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  def self.call
    Dry.Transaction(container: self) do
      step :clear_DB
    end.call
  end

  register :clear_DB, lambda { |_|
    if Song.all.length >= 9500
      Search.each_with_index do |_, i|
        Search.where(:id => i+1).delete
        Song.where(:search_id => i+1).delete
      end
      Right('Clear Database success!')
    else
      Left('Fail to delete Database')
    end
  }
end
