resource "aws_route53_record" "cname_route53_record" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.webapp.com"
  type    = "CNAME"
  ttl     = "60"
  records = aws_lb.web_alb.dns_name
}