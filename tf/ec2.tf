resource "aws_instance" "backend" {
  ami                    = var.ami_id
  instance_type          = var.backend_instance_type
  key_name               = aws_key_pair.ssh_key.key_name
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  user_data              = templatefile("scripts/backend_user_data.sh", { 
    timestamp = timestamp(),
    bucket_name = aws_s3_bucket.code_bucket.bucket,
    project_name = var.project_name,
    environment = var.environment,
    dd_api_key = var.datadog_api_key,
    dd_site = var.datadog_site
  })
  vpc_security_group_ids = [aws_security_group.backend_sg.id]
  tags = merge(var.tags, {
    Name = "${var.project_name}-backend"
  })
}

resource "aws_instance" "frontend" {
  ami                    = var.ami_id
  instance_type          = var.frontend_instance_type
  key_name               = aws_key_pair.ssh_key.key_name
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  user_data              = templatefile("scripts/frontend_user_data.sh", { 
    timestamp = timestamp(),
    bucket_name = aws_s3_bucket.code_bucket.bucket,
    project_name = var.project_name,
    environment = var.environment,
    dd_api_key = var.datadog_api_key,
    dd_site = var.datadog_site
  })
  vpc_security_group_ids = [aws_security_group.frontend_sg.id]
  tags = merge(var.tags, {
    Name = "${var.project_name}-frontend"
  })
}
