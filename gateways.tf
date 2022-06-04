resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.name}-igw"
  }
}

resource "aws_nat_gateway" "main" {
  count         = length(compact(var.availability_zones))
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)

  tags = {
    Name        = "${var.name}-nat-${format("%03d", count.index + 1)}"
  }
}

resource "aws_eip" "nat" {
  count = length(compact(var.availability_zones))
  vpc   = true

  tags = {
    Name        = "${var.name}-eip-${format("%03d", count.index + 1)}"
  }
}
