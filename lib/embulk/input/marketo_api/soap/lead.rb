require "embulk/input/marketo_api/soap/base"

module Embulk
  module Input
    module MarketoApi
      module Soap
        class Lead < Base
          def metadata
            # http://developers.marketo.com/documentation/soap/describemobject/
            response = savon_call(:describe_m_object, message: {object_name: "LeadRecord"})
            response.body[:success_describe_m_object][:result][:metadata][:field_list][:field]
          end

          def each(since_at = nil, until_at = nil, &block)
            since_at ||= get_oldest_data
            until_at ||= Time.now

            generate_time_range(since_at, until_at).each do |range|
              request = {
                lead_selector: {
                  oldest_updated_at: range[:from].iso8601,
                  latest_updated_at: range[:to].iso8601,
                },
                attributes!: {
                  lead_selector: {"xsi:type" => "ns1:LastUpdateAtSelector"}
                },
                batch_size: 250,
              }
              Embulk.logger.info "fetching '#{range[:from]}' to '#{range[:to]}'"

              stream_position = fetch(request, &block)

              while stream_position
                stream_position = fetch(request.merge(stream_position: stream_position), &block)
              end
            end
          end

          private

          def get_oldest_data
            Time.parse("2010-01-01") # NOTE: return fixed date currently, see below NOTE

            # NOTE: below code will timeout (over 300 seconds)
            #       if we want to detect oldest lead from API, we should find other way
            #
            # request = {
            #   lead_selector: {
            #     oldest_updated_at: Time.parse("2010-01-01").iso8601,
            #   },
            #   attributes!: {
            #     lead_selector: {"xsi:type" => "ns1:LastUpdateAtSelector"}
            #   },
            #   batch_size: 1,
            # }
            # fetch(request) do |lead|
            #   p lead
            # end
          end

          def fetch(request = {}, &block)
            start = Time.now
            response = savon_call(:get_multiple_leads, message: request)
            Embulk.logger.info "fetched in #{Time.now - start} seconds"

            remaining = response.xpath('//remainingCount').text.to_i
            Embulk.logger.info "Remaining records: #{remaining}"
            response.xpath('//leadRecordList/leadRecord').each do |lead|
              record = {
                "id" => {type: :integer, value: lead.xpath('Id').text.to_i},
                "email" => {type: :string, value: lead.xpath('Email').text}
              }
              lead.xpath('leadAttributeList/attribute').each do |attr|
                name = attr.xpath('attrName').text
                type = attr.xpath('attrType').text
                value = attr.xpath('attrValue').text
                record = record.merge(
                  name => {
                    type: type,
                    value: value
                  }
                )
              end

              block.call(record)
            end

            if remaining > 0
              response.xpath('//newStreamPosition').text
            else
              nil
            end
          end
        end
      end
    end
  end
end
