# Création du bucket S3
resource "aws_s3_bucket" "my_bucket" {
  bucket = "hiba-bucket" 

  tags = {
    Name = "HibaBucket"
  }
}
