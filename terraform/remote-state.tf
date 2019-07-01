terraform {
  backend "remote" {
    organization = "fuzzylabs"

    workspaces {
      name = "sahara-marketing"
    }
  }
}
