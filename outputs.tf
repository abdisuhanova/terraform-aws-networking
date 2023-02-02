output "sg_id" {
  value = aws_security_group.sg.id
}

output "sub_ids" {
  value = aws_subnet.main.*.id
}

output vpc_id {
  value = aws_vpc.main.id
}