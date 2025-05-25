resource "aws_key_pair" "ssh_key" {
  key_name   = "${var.project_name}-key"
  public_key = file("${path.module}/ssh_key.pub")
  tags = var.tags
} 