# frozen_string_literal: true

module AmazonAppstoreSubmission
  # Describes availability for an `Edit`.
  class Availability
    # Describes a date/time and time zone pair, used inside availability information.
    class DatePair
      # @return [Time] The timestamp
      attr_accessor :date_time
      # @return [String] The timezone ID to go along with `#date_time`
      attr_accessor :zone_id

      # @param [Hash] json
      def initialize(json)
        @date_time = json['dateTime']
        @zone_id = json['zoneId']
      end

      # @return [Hash]
      def to_json(*)
        { 'dateTime' => date_time, 'zoneId' => zone_id }
      end

      # @param [DatePair] other
      # @return [Boolean]
      def ==(other)
        date_time == other.date_time && zone_id == other.zone_id
      end

      def to_s
        "<AmazonAppstoreSubmission::Availability::DatePair:#{object_id} " \
          "date_time=>#{date_time} " \
          "zone_id=>\"#{zone_id}\">"
      end
    end

    # @return [DatePair] The date/time when the edit should go live
    attr_accessor :publishing_date

    # @param [Hash] json
    def initialize(json)
      @publishing_date = DatePair.new(json['publishingDate'])
    end

    # @return [Hash]
    def to_json(*)
      { 'publishingDate' => publishing_date.to_json }
    end

    # @param [Availability] other
    # @return [Boolean]
    def ==(other)
      publishing_date == other.publishing_date
    end

    def to_s
      "<AmazonAppstoreSubmission::Availability:#{object_id} " \
        "publishing_date=>#{publishing_date}>"
    end
  end
end
