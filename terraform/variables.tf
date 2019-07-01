variable "project" {
  description = "The GCP Project in which resources are created"
  type        = string
  default     = "fuzzylabs"
}

variable "location" {
  description = "The GCP Location in which resources are created"
  type        = string
  default     = "europe-west2"
}

variable "dataset_id" {
  description = "The name of the bigquery dataset"
  type        = string
  default     = "sahara_marketing"
}

variable "tables" {
  description = "A list of maps containing table attributes"
  type        = list
  default = [
    {
      "table_id" : "ga360",
      "description" : "Google Analytics Sample Data",
      "data" : "../data/ga360.csv"
    },
    {
      "table_id" : "users",
      "description" : "CRM User Data",
      "data" : "../data/crm_user.csv"
    },
    {
      "table_id" : "accounts",
      "description" : "CRM Account",
      "data" : "../data/crm_account.csv"
    },
    {
      "table_id" : "users_signup_dates",
      "description" : "CRM User Signup Dates",
      "data" : "../data/users_signup_dates.csv"
    }
  ]
}
