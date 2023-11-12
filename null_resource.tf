resource "null_resource" "exemple" {
  provisioner "local-exec" {
    command = "echo 'Hello, Terraform!'"
  }
}