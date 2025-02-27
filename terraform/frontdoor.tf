##
# LGD in Azure - Front Door.

# Cache settings.
locals {
  cache = {
    compression_enabled       = true
    content_types_to_compress = [
       "application/eot",
        "application/font",
        "application/font-sfnt",
        "application/javascript",
        "application/json",
        "application/opentype",
        "application/otf",
        "application/pkcs7-mime",
        "application/truetype",
        "application/ttf",
        "application/vnd.ms-fontobject",
        "application/xhtml+xml",
        "application/xml",
        "application/xml+rss",
        "application/x-font-opentype",
        "application/x-font-truetype",
        "application/x-font-ttf",
        "application/x-httpd-cgi",
        "application/x-javascript",
        "application/x-mpegurl",
        "application/x-opentype",
        "application/x-otf",
        "application/x-perl",
        "application/x-ttf",
        "font/eot",
        "font/ttf",
        "font/otf",
        "font/opentype",
        "image/svg+xml",
        "text/css",
        "text/csv",
        "text/html",
        "text/javascript",
        "text/js",
        "text/plain",
        "text/richtext",
        "text/tab-separated-values",
        "text/xml",
      "text/x-script",
      "text/x-component",
      "text/x-java-source",
    ]
    query_string_caching_behavior = "UseQueryString"
    query_strings                 = []
  }
}

# Front Door profile.
resource "azurerm_cdn_frontdoor_profile" "front_door" {
  name                = "fd-${var.resource_group_name}-${var.resource_group_id}"
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = var.front_door_sku
}

# Production endpoint.
resource "azurerm_cdn_frontdoor_endpoint" "prod" {
  name                     = "${var.resource_group_name}${var.resource_group_id}-prod"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.front_door.id
}

# Production origin group.
resource "azurerm_cdn_frontdoor_origin_group" "prod" {
  name                     = "og-prod"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.front_door.id
  session_affinity_enabled = true
  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
  }

  health_probe {
    path                = "/"
    request_type        = "HEAD"
    protocol            = "Https"
    interval_in_seconds = 100
  }
}

# Production origin.
resource "azurerm_cdn_frontdoor_origin" "prod" {
  name                          = "origin-prod"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.prod.id

  enabled                        = true
  host_name                      = azurerm_linux_web_app.app.default_hostname
  http_port                      = 80
  https_port                     = 443
  origin_host_header             = azurerm_linux_web_app.app.default_hostname
  priority                       = 1
  weight                         = 1000
  certificate_name_check_enabled = true
}

# Production route.
resource "azurerm_cdn_frontdoor_route" "prod" {
  name                          = "route-prod"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.prod.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.prod.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.prod.id]

  supported_protocols    = ["Http", "Https"]
  patterns_to_match      = ["/*"]
  forwarding_protocol    = "HttpsOnly"
  link_to_default_domain = true
  https_redirect_enabled = true

  cache {
    compression_enabled = local.cache.compression_enabled
    content_types_to_compress = local.cache.content_types_to_compress
    query_string_caching_behavior = local.cache.query_string_caching_behavior
    query_strings = local.cache.query_strings
  }
}

# Preprod endpoint.
resource "azurerm_cdn_frontdoor_endpoint" "preprod" {
  name                     = "${var.resource_group_name}${var.resource_group_id}-preprod"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.front_door.id
}

# Preprod origin group.
resource "azurerm_cdn_frontdoor_origin_group" "preprod" {
  name                     = "og-preprod"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.front_door.id
  session_affinity_enabled = true
  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
  }

  health_probe {
    path                = "/"
    request_type        = "HEAD"
    protocol            = "Https"
    interval_in_seconds = 100
  }
}

# Preprod origin.
resource "azurerm_cdn_frontdoor_origin" "preprod" {
  name                          = "origin-preprod"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.preprod.id

  enabled                        = true
  host_name                      = azurerm_linux_web_app_slot.preprod.default_hostname
  http_port                      = 80
  https_port                     = 443
  origin_host_header             = azurerm_linux_web_app_slot.preprod.default_hostname
  priority                       = 1
  weight                         = 1000
  certificate_name_check_enabled = true
}

# Preprod route.
resource "azurerm_cdn_frontdoor_route" "preprod" {
  name                          = "route-preprod"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.preprod.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.preprod.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.preprod.id]

  supported_protocols    = ["Http", "Https"]
  patterns_to_match      = ["/*"]
  forwarding_protocol    = "HttpsOnly"
  link_to_default_domain = true
  https_redirect_enabled = true

  cache {
    compression_enabled = local.cache.compression_enabled
    content_types_to_compress = local.cache.content_types_to_compress
    query_string_caching_behavior = local.cache.query_string_caching_behavior
    query_strings = local.cache.query_strings
  }
}

# UAT endpoint.
resource "azurerm_cdn_frontdoor_endpoint" "uat" {
  name                     = "${var.resource_group_name}${var.resource_group_id}-uat"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.front_door.id
}

# UAT origin group.
resource "azurerm_cdn_frontdoor_origin_group" "uat" {
  name                     = "og-uat"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.front_door.id
  session_affinity_enabled = true
  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
  }

  health_probe {
    path                = "/"
    request_type        = "HEAD"
    protocol            = "Https"
    interval_in_seconds = 100
  }
}

# UAT origin.
resource "azurerm_cdn_frontdoor_origin" "uat" {
  name                          = "origin-uat"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.uat.id

  enabled                        = true
  host_name                      = azurerm_linux_web_app_slot.uat.default_hostname
  http_port                      = 80
  https_port                     = 443
  origin_host_header             = azurerm_linux_web_app_slot.uat.default_hostname
  priority                       = 1
  weight                         = 1000
  certificate_name_check_enabled = true
}

# UAT route.
resource "azurerm_cdn_frontdoor_route" "uat" {
  name                          = "route-uat"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.uat.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.uat.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.uat.id]

  supported_protocols    = ["Http", "Https"]
  patterns_to_match      = ["/*"]
  forwarding_protocol    = "HttpsOnly"
  link_to_default_domain = true
  https_redirect_enabled = true

  cache {
    compression_enabled = local.cache.compression_enabled
    content_types_to_compress = local.cache.content_types_to_compress
    query_string_caching_behavior = local.cache.query_string_caching_behavior
    query_strings = local.cache.query_strings
  }
}

# Dev endpoint.
resource "azurerm_cdn_frontdoor_endpoint" "dev" {
  name                     = "${var.resource_group_name}${var.resource_group_id}-dev"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.front_door.id
}

# Dev origin group.
resource "azurerm_cdn_frontdoor_origin_group" "dev" {
  name                     = "og-dev"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.front_door.id
  session_affinity_enabled = true
  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
  }

  health_probe {
    path                = "/"
    request_type        = "HEAD"
    protocol            = "Https"
    interval_in_seconds = 100
  }
}

# Dev origin.
resource "azurerm_cdn_frontdoor_origin" "dev" {
  name                          = "origin-dev"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.dev.id

  enabled                        = true
  host_name                      = azurerm_linux_web_app_slot.dev.default_hostname
  http_port                      = 80
  https_port                     = 443
  origin_host_header             = azurerm_linux_web_app_slot.dev.default_hostname
  priority                       = 1
  weight                         = 1000
  certificate_name_check_enabled = true
}

# Dev route.
resource "azurerm_cdn_frontdoor_route" "dev" {
  name                          = "route-dev"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.dev.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.dev.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.dev.id]

  supported_protocols    = ["Http", "Https"]
  patterns_to_match      = ["/*"]
  forwarding_protocol    = "HttpsOnly"
  link_to_default_domain = true
  https_redirect_enabled = true

  cache {
    compression_enabled = local.cache.compression_enabled
    content_types_to_compress = local.cache.content_types_to_compress
    query_string_caching_behavior = local.cache.query_string_caching_behavior
    query_strings = local.cache.query_strings
  }
}

