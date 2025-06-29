/* resource "aws_key_pair" "openvpn" {
  key_name   = "openvpn"
  public_key = file("C:\\devops\\daws-84s\\openvpn.pub") # for mac use /
}
*/

resource "aws_instance" "vpn" {
  ami           = local.ami_id
  instance_type = "t2.micro"
  vpc_security_group_ids = [local.vpn_sg_id]
  subnet_id = local.public_subnet_id
  key_name =  "daws84" #Make sure this key exist in AWS   #aws_key_pair.openvpn.key_name
  user_data = file("openvpn.sh")
  tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-vpn"
    }
  )
}