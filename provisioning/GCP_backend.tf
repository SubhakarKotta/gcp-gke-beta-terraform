terraform {
  backend "gcs" {
    bucket = "subhakar-state-bucket"
    prefix    = "terraform/your.tfstate"
  }
}
