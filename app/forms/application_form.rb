# Form objects is a design pattern that will help you build models and
# keep business validations and callbacks away from the models.
# To learn more about form objects check out https://github.com/rootstrap/yaaf#links
#
# You should inherit from ApplicationForm in order to use form objects,
# to learn more about using the gem check out https://github.com/rootstrap/yaaf

class ApplicationForm < YAAF::Form
end
