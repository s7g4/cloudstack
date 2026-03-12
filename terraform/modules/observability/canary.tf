data "archive_file" "canary_zip" {
  type        = "zip"
  source_file = "${path.module}/canary/heartbeat.js"
  output_path = "${path.module}/canary/heartbeat.zip"
}

resource "aws_s3_bucket" "canary_results" {
  bucket        = "${var.project_name}-canary-results-${var.db_instance_id}" # Using DB ID for uniqueness
  force_destroy = true
}

resource "aws_iam_role" "canary_role" {
  name = "${var.project_name}-canary-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "canary_policy" {
  name = "${var.project_name}-canary-policy"
  role = aws_iam_role.canary_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetBucketLocation"
      ],
      "Resource": [
        "${aws_s3_bucket.canary_results.arn}",
        "${aws_s3_bucket.canary_results.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:PutMetricData"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "cloudwatch:namespace": "CloudWatchSynthetics"
        }
      }
    }
  ]
}
EOF
}

resource "aws_synthetics_canary" "web_check" {
  name                 = "${var.project_name}-check"
  artifact_s3_location = "s3://${aws_s3_bucket.canary_results.bucket}/"
  execution_role_arn   = aws_iam_role.canary_role.arn
  handler              = "heartbeat.handler"
  zip_file            = data.archive_file.canary_zip.output_path
  runtime_version      = "syn-nodejs-puppeteer-3.9"

  schedule {
    expression = "rate(5 minutes)"
  }

  run_config {
    timeout_in_seconds = 60
  }

  tags = {
    Name = "${var.project_name}-canary"
  }
}
