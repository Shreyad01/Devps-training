# Create S3 bucket
resource "aws_s3_bucket" "shreya_s3_bucket" {
  bucket = "${var.bucket_name}"
  tags = {
    Name = "${var.bucket_name}"
  }
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.shreya_s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "shreya_s3_bucket_public_access" {
  bucket = aws_s3_bucket.shreya_s3_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


# create Bucket policy
# resource "aws_s3_bucket_policy" "s3_bucket_policy" {
#   bucket = aws_s3_bucket.shreya_s3_bucket.id

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           # AWS = var.ec2_iam_role_arn
#           AWS = "arn:aws:iam::326151034032:user/lab_user"
#         }
#         Action = [
#           "s3:DeleteObject",
#           "s3:GetObject",
#           "s3:PutObject"
#         ]
#         Resource = [
#           aws_s3_bucket.shreya_s3_bucket.arn,
#           "${aws_s3_bucket.shreya_s3_bucket.arn}/*"
#         ]
#       },
#       {
#         Effect = "Allow"
#         Principal = "*"
#         Action = [
#           "s3:GetObject"
#         ]
#         Resource = [
#           aws_s3_bucket.shreya_s3_bucket.arn,
#           "${aws_s3_bucket.shreya_s3_bucket.arn}/*"
#         ]
#       }
#     ]
#   })
# }