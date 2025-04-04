resource "aws_ecr_repository" "repo" {
  name                 = "hello_repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}