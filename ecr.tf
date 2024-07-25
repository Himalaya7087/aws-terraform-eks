resource "aws_ecr_repository" "repo" {
  name                 = "himalaya7087"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}