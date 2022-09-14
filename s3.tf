resource "aws_s3_bucket" "chinni-artifactory" {
  bucket = "sharmila12"

  tags = {
    Name = "chinni-artifactory"

  }
}