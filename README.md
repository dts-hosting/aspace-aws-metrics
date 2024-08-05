# aspace-aws-metrics

Send metric data to AWS DynamoDB.

## Config

```ruby
AppConfig[:metrics] = {
  table: ENV.fetch("ASPACE_AWS_METRICS_TABLE"),
  id_key: ENV.fetch("ASPACE_AWS_METRICS_ID_KEY"),
  id_val: ENV.fetch("ASPACE_AWS_METRICS_ID_VAL"),
  schedule: ENV.fetch("ASPACE_AWS_METRICS_SCHEDULE", "* * * * *"), # every min for testing
  collect: [
    {
      name: "RepoTotal",
      value: -> { Repository.where(hidden: 0).count },
    },
    {
      name: "ResourceTotal",
      value: -> { Resource.count },
    },
    {
      name: "UserLastLogin",
      value: -> {
        User.where(is_system_user: 0).order(Sequel.desc(:user_mtime)).first[:user_mtime].to_s rescue ""
      },
    },
    {
      name: "DigitalObjectTotal",
      value: -> { DigitalObject.count },
    },
  ]
}
```

## Testing

Run DynamoDB locally with `env`:

```
export AWS_ACCESS_KEY_ID=dummy AWS_SECRET_ACCESS_KEY=dummy AWS_REGION=us-west-2 ASPACE_ENV=development
```
