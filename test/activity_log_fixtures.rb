module ActivityLogFixtures
  private

  def activity_logs_response
    activity_logs(response)
  end

  def next_stream_activity_logs_response
    activity_logs(next_stream_response)
  end

  def activity_logs(body)
    Struct.new(:body).new({
      success_get_lead_changes: {
        result: body
      }
    })
  end

  def response
    {
      return_count: "2",
      remaining_count: "1",
      new_start_position: {
        latest_created_at: true,
        oldest_created_at: DateTime.parse("2015-07-14T00:13:13+00:00"),
        activity_created_at: true,
        offset: offset,
      },
      lead_change_record_list: {
        lead_change_record: [
          {
            id: "1",
            activity_date_time: DateTime.parse("2015-07-14T00:00:09+00:00"),
            activity_type: "at1",
            mktg_asset_name: "score1",
            activity_attributes: {
              attribute: [
                {
                  attrName: "Attribute Name",
                  attrType: nil,
                  attrValue: "Attribute1",
                },
                {
                  attr_name: "Old Value",
                  attr_type: nil,
                  attr_value: "402",
                },
              ],
              campaign: "Everyleaf campaign",
              mkt_person_id: "100",
            },
          },
          {
            id: "2",
            activity_date_time: DateTime.parse("2015-07-14T00:00:10+00:00"),
            activity_type: "at2",
            mktg_asset_name: "score2",
            activity_attributes: {
              attribute: [
                {
                  attrName: "Attribute Name",
                  attrType: nil,
                  attrValue: "Attribute2",
                },
                {
                  attr_name: "Old Value",
                  attr_type: nil,
                  attr_value: "403",
                },
              ],
              campaign: "manyo",
              mkt_person_id: "90",
            },
          },
        ]
      }
    }
  end

  def offset
    "offset"
  end

  def next_stream_response
    {
      return_count: 1,
      remaining_count: 0,
      new_start_position: {
      },
      lead_change_record_list: {
        lead_change_record: [
          {
            id: "3",
            activity_date_time: DateTime.parse("2015-07-14T00:00:11+00:00"),
            activity_type: "at3",
            mktg_asset_name: "score3",
            activity_attributes: {
              attribute: [
                {
                  attrName: "Attribute Name",
                  attrType: nil,
                  attrValue: "Attribute3",
                },
                {
                  attr_name: "Old Value",
                  attr_type: nil,
                  attr_value: "404",
                },
              ],
              campaign: "Everyleaf campaign",
              mkt_person_id: "100",
            },
          },
        ]
      }
    }
  end
end
