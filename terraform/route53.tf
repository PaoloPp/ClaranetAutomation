resource "aws_route53_zone" "zoneA" {
  name = "www.webapp.com"

}

resource "aws_route53_record" "cname_route53_record" {
  zone_id = aws_route53_zone.zoneA.zone_id
  name    = "www.webapp.com"
  type    = "CNAME"
  ttl     = "60"
  records = ["www.webapp.com"]
}