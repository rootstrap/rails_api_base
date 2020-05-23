# Presenters are used to wrap records giving them functionalities
# related to how their data is presented. A common use case is full name:
#
#   def full_name
#     "#{user.first_name} #{user.last_name}"
#   end
#
# Adding these kind of methods to a presenter we can declutter our
# model from presentation logic that just doesn't belong there. It's also
# pretty common to add `delegate_missing_to :original_record` to use the
# presenter as a proxy and not have to write every attribute by hand.
#
# Lastly, presenters also allow to present a record differently according to
# the context. This can be achieved by having different presenter classes for
# each context (i.e. FormalUser ChillUser) with their corresponding method
# implementations:
#
#   class FormalUser < BasePresenter
#     # ...
#     def full_name
#       "#{user.title} #{user.first_name} #{user.last_name}"
#     end
#   end
#
class BasePresenter
  # Wraps each record in the collection in
  # a presenter
  #
  # @param [Enumerable] collection
  def self.wrap_collection(collection)
    collection.map { |record| new(record) }
  end
end
