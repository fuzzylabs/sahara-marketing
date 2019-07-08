resource "google_bigquery_dataset" "default" {
  project    = var.project
  location   = var.location
  dataset_id = var.dataset_id
}

resource "google_bigquery_table" "default" {
  count       = "${length(var.tables)}"
  dataset_id  = "${google_bigquery_dataset.default.dataset_id}"
  project     = var.project
  table_id    = "${lookup(var.tables[count.index], "table_id")}"
  description = "${lookup(var.tables[count.index], "description")}"

  # Loading data into the table isn't native to Terraform right now
  # working around with local-exec to call out to bq
  # https://github.com/terraform-providers/terraform-provider-google/issues/3868
  provisioner "local-exec" {
    command = <<EOT
      bq --location=${var.location} load --autodetect --source_format=CSV \
      ${var.project}:${google_bigquery_dataset.default.dataset_id}.${lookup(var.tables[count.index], "table_id")} \
      ${lookup(var.tables[count.index], "data")}
    EOT
  }
}

resource "null_resource" "default" {
  # Recreate the views and models whenever the size (num_bytes) of any table changes.
  triggers = {
    table_sizes = "${join(",", google_bigquery_table.default.*.num_bytes)}"
  }
  provisioner "local-exec" {
    command = "scripts/create-views-models.sh ${var.location} ${var.project} ${var.dataset_id}"
  }
}
