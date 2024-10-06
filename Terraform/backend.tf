#terraform {
#  backend "s3" {
#    bucket         = "mariam-bucket"  # Remplace par un nom unique pour ton bucket S3
#    key            = "terraform/state"          # Chemin dans le bucket
#    region         = "eu-north-1"                # La même région que ton fournisseur
#  }
#}
