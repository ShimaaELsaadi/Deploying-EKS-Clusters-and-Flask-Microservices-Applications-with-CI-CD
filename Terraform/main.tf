provider "aws" {
  region = "eu-west-2"
}

resource "aws_vpc" "microservicesapp_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "microservicesapp-vpc"
  }
}

resource "aws_subnet" "microservicesapp_subnet" {
  count = 2
  vpc_id                  = aws_vpc.microservicesapp_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.microservicesapp_vpc.cidr_block, 8, count.index)
  availability_zone       = element(["eu-west-2a", "eu-west-2c"], count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "microservicesapp-subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "microservicesapp_igw" {
  vpc_id = aws_vpc.microservicesapp_vpc.id

  tags = {
    Name = "microservicesapp-igw"
  }
}

resource "aws_route_table" "microservicesapp_route_table" {
  vpc_id = aws_vpc.microservicesapp_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.microservicesapp_igw.id
  }

  tags = {
    Name = "microservicesapp-route-table"
  }
}

resource "aws_route_table_association" "a" {
  count          = 2
  subnet_id      = aws_subnet.microservicesapp_subnet[count.index].id
  route_table_id = aws_route_table.microservicesapp_route_table.id
}

resource "aws_security_group" "microservicesapp_cluster_sg" {
  vpc_id = aws_vpc.microservicesapp_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "microservicesapp-cluster-sg"
  }
}

resource "aws_security_group" "microservicesapp_node_sg" {
  vpc_id = aws_vpc.microservicesapp_vpc.id

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

  tags = {
    Name = "microservicesapp-node-sg"
  }
}

resource "aws_eks_cluster" "microservicesapp" {
  name     = "microservicesapp-cluster"
  role_arn = aws_iam_role.microservicesapp_cluster_role.arn

  vpc_config {
    subnet_ids         = aws_subnet.microservicesapp_subnet[*].id
    security_group_ids = [aws_security_group.microservicesapp_cluster_sg.id]
  }
}

resource "aws_eks_node_group" "microservicesapp" {
  cluster_name    = aws_eks_cluster.microservicesapp.name
  node_group_name = "microservicesapp-node-group"
  node_role_arn   = aws_iam_role.microservicesapp_node_group_role.arn
  subnet_ids      = aws_subnet.microservicesapp_subnet[*].id

  scaling_config {
    desired_size = 3
    max_size     = 3
    min_size     = 3
  }

  instance_types = ["t2.large"]

  remote_access {
    ec2_ssh_key = var.ssh_key_name
    source_security_group_ids = [aws_security_group.microservicesapp_node_sg.id]
  }
}

resource "aws_iam_role" "microservicesapp_cluster_role" {
  name = "microservicesapp-cluster-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "microservicesapp_cluster_role_policy" {
  role       = aws_iam_role.microservicesapp_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role" "microservicesapp_node_group_role" {
  name = "microservicesapp-node-group-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "microservicesapp_node_group_role_policy" {
  role       = aws_iam_role.microservicesapp_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "microservicesapp_node_group_cni_policy" {
  role       = aws_iam_role.microservicesapp_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "microservicesapp_node_group_registry_policy" {
  role       = aws_iam_role.microservicesapp_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
# Get the EKS Cluster Information
data "aws_eks_cluster" "microservicesapp" {
  name = aws_eks_cluster.microservicesapp.name
}

data "aws_eks_cluster_auth" "microservicesapp" {
  name = aws_eks_cluster.microservicesapp.name
}

# Configure Kubernetes Provider
provider "kubernetes" {
  host                   = data.aws_eks_cluster.microservicesapp.endpoint
  token                  = data.aws_eks_cluster_auth.microservicesapp.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.microservicesapp.certificate_authority[0].data)
}