resource "aws_ecs_task_definition" "task1" {

    family = "task1"
    requires_compatibilities = ["FARGATE"]
    container_definitions = file("container_config.json")
    network_mode = "awsvpc"
    cpu = 256
    memory = 1024
      


}