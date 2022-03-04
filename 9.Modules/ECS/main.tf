resource "aws_ecs_task_definition" "task1" {

    family = "task1"
    requires_compatibilities = ["FARGATE"]
    container_definitions = file("container_config.json")
    network_mode = "awsvpc"
    cpu = 256
    memory = 1024
      


}



####### ECS Cluster Code ########

resource "aws_ecs_cluster" "example" {
  name = "Piyush-Test"

  capacity_providers = ["FARGATE_SPOT", "FARGATE"]
  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
  }

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}
