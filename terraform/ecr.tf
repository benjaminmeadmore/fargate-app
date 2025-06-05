
# Import existing ECR repository
resource "aws_ecr_repository" "app" {
  name = "flaskdemo"

  lifecycle {
    prevent_destroy = true
  }
}

# # ECR lifecycle policy to manage image retention
# resource "aws_ecr_lifecycle_policy" "app_policy" {
#   repository = aws_ecr_repository.app.name

#   policy = jsonencode({
#     rules = [
#       {
#         rulePriority = 1
#         description  = "Keep last 10 images"
#         selection = {
#           tagStatus     = "tagged"
#           tagPrefixList = ["v"]
#           countType     = "imageCountMoreThan"
#           countNumber   = 10
#         }
#         action = {
#           type = "expire"
#         }
#       }
#     ]
#   })
# }