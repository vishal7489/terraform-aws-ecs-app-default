data aws_route53_zone "selected" {
  count = var.alb_only && var.hostname_create ? 1 : 0
  name  = var.hosted_zone
}

resource aws_route53_record "hostname" {
  count   = var.alb_only && var.hostname_create && var.hostname != "" ? 1 : 0
  zone_id = data.aws_route53_zone.selected[0].zone_id
  name    = var.hostname
  type    = "CNAME"
  ttl     = 300
  records = list(var.alb_dns_name)
}

resource aws_route53_record "hostnames" {
  count   = var.alb_only && var.hostname_create && length(var.hostnames) != 0 ? length(var.hostnames) : 0
  zone_id = data.aws_route53_zone.selected[0].zone_id
  name    = var.hostnames[count.index]
  type    = "CNAME"
  ttl     = 300
  records = list(var.alb_dns_name)
}