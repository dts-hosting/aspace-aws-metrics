# aspace-aws-metrics

Send metric data to AWS DynamoDB/CloudWatch (latter TODO).

## Config

```ruby
AppConfig[:metrics] = {
  table: ENV.fetch('ASPACE_AWS_METRICS_TABLE'),
  id_key: ENV.fetch('ASPACE_AWS_METRICS_ID_KEY'),
  id_val: ENV.fetch('ASPACE_AWS_METRICS_ID_VAL'),
  schedule: ENV.fetch('ASPACE_AWS_METRICS_SCHEDULE', '* * * * *'), # every min for testing
  collect: [
    {
      namespace: 'ArchivesSpace/ResourceTotal',
      record_type: 'Resource',
      record_method: :count,
      cloudwatch: ENV.fetch('ASPACE_AWS_METRICS_CLOUDWATCH', false),
    },
    {
      namespace: 'ArchivesSpace/DigitalObjectTotal',
      record_type: 'DigitalObject',
      record_method: :count,
      cloudwatch: ENV.fetch('ASPACE_AWS_METRICS_CLOUDWATCH', false),
    },
    {
      namespace: 'ArchivesSpace/UserLastLogin',
      record_type: 'User',
      record_method: :last_login,
      cloudwatch: ENV.fetch('ASPACE_AWS_METRICS_CLOUDWATCH', false),
    },
  ]
}
```

## Testing

Run DynamoDB locally with `env`:

```
export AWS_ACCESS_KEY_ID=dummy AWS_SECRET_ACCESS_KEY=dummy AWS_REGION=us-west-2 ASPACE_ENV=development
```
