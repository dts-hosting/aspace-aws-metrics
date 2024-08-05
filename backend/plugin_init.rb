# frozen_string_literal: true

require "aws-sdk-dynamodb"

unless AppConfig.has_key? :metrics
  AppConfig[:metrics] = {}
end

ArchivesSpaceService.loaded_hook do
  metrics_cfg = AppConfig[:metrics]
  metrics_schedule = metrics_cfg[:schedule]
  metrics_label = "aspace.aws.metrics"

  if metrics_schedule.nil?
    puts "Skipping metrics collection as schedule is undefined"
    return
  end

  ArchivesSpaceService.settings.scheduler.cron(
    metrics_schedule,
    allow_overlapping: false, # TODO: [newer versions] overlap: false
    mutex: metrics_label,
    tags: metrics_label
  ) do
    dynamodb = (ENV["ASPACE_ENV"] == "development") ? Aws::DynamoDB::Client.new(endpoint: "http://host.docker.internal:8000") : Aws::DynamoDB::Client.new

    metrics_table = metrics_cfg[:table]
    metrics_id_key = metrics_cfg[:id_key]
    metrics_id_val = metrics_cfg[:id_val]

    metrics_cfg[:collect].each do |c|
      metric_name = c[:name]
      metric_value = c[:value].call
      puts "Evaluated metric [#{metrics_id_key}] [#{metrics_id_val}]: [#{metric_name}] [#{metric_value}]"

      dynamodb.update_item({
        table_name: metrics_table,
        key: {
          metrics_id_key => metrics_id_val
        },
        update_expression: "SET #{metric_name} = :value",
        expression_attribute_values: {
          ":value" => metric_value
        }
      })
    end
  end
end
