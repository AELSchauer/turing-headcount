module Exceptions
  class UnknownDataError < Exception; end
  class UnknownRaceError < Exception; end
  class InsufficientInformationError < Exception; end
  class ConflictingArgumentsError < Exception; end
end