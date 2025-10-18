resource "aws_eks_cluster" "techno_eks" {
  name     = "techno-eks-malang-hida"
  role_arn = "arn:aws:iam::641191776011:role/LabRole"
  version  = "1.30"

  vpc_config {
    subnet_ids = [
      aws_subnet.techno_private_subnet_a.id,
      aws_subnet.techno_private_subnet_b.id,
      aws_subnet.techno_public_subnet_a.id,
      aws_subnet.techno_public_subnet_b.id
    ]
  }


  tags = {
    Name = "techno-eks-malang-hida"
  }
}

resource "aws_eks_node_group" "techno_eks_nodes" {
  cluster_name    = aws_eks_cluster.techno_eks.name
  node_group_name = "techno-eks-malang-hida-node-group"
  node_role_arn   = "arn:aws:iam::641191776011:role/LabRole"

  subnet_ids = [
    aws_subnet.techno_public_subnet_a.id,
    aws_subnet.techno_public_subnet_b.id
  ]

  instance_types = ["t3.large"]

  remote_access {
    ec2_ssh_key = "vockey"
    source_security_group_ids = [aws_security_group.techno_sg_apps.id]
  }

  scaling_config {
    desired_size = 2
    min_size     = 2
    max_size     = 2
  }

  tags = {
    Name = "techno-eks-malang-hida-node-group"
  }
}

