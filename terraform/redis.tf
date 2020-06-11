resource "aws_security_group" "default" {
  name_prefix = var.namespace
  vpc_id      = aws_vpc.default.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elasticache_subnet_group" "default" {
  name       = "${var.namespace}-cache-subnet"
  subnet_ids = "${aws_subnet.default.*.id}"

}

resource "aws_elasticache_replication_group" "redis" {
  automatic_failover_enabled    = false
  replication_group_id          = "tf-rep-group-1"
  replication_group_description = "test description"
  node_type                     = "cache.t2.micro"
  number_cache_clusters         = 1
  parameter_group_name          = "default.redis5.0"
  port                          = 6379
  security_group_ids            = [aws_security_group.default.id]
  subnet_group_name = aws_elasticache_subnet_group.default.name
}