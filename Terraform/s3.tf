# Création du bucket S3
resource "aws_s3_bucket" "my_bucket" {
  bucket = "mariam-bucket" 

  tags = {
    Name = "MariamBucket"
  }
}
