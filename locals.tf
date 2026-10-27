locals {
  custom_subdomain_name = coalesce(var.custom_subdomain_name, var.name)
}