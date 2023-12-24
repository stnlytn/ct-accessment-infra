
resource "aws_dynamodb_table" "url_shortener" {
  name           = "url_shortener"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "short_url"

  attribute {
    name = "short_url"
    type = "S"
  }

  attribute {
    name = "long_url"
    type = "S"
  }

  global_secondary_index {
    name            = "LongUrlIndex"
    hash_key        = "long_url"
    projection_type = "ALL"
    read_capacity   = 20
    write_capacity  = 5
  }
}

resource "aws_appautoscaling_target" "read_target" {
  service_namespace  = "dynamodb"
  resource_id        = "table/${aws_dynamodb_table.url_shortener.name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  min_capacity       = 5
  max_capacity       = 1000
}

resource "aws_appautoscaling_policy" "read_policy" {
  name               = "dynamodb-read-capacity"
  service_namespace  = aws_appautoscaling_target.read_target.service_namespace
  scalable_dimension = aws_appautoscaling_target.read_target.scalable_dimension
  resource_id        = aws_appautoscaling_target.read_target.resource_id
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    target_value       = 70
    scale_out_cooldown = 180
    scale_in_cooldown  = 180
  }
}
