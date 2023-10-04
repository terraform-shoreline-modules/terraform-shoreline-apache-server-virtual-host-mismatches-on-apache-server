resource "shoreline_notebook" "virtual_host_mismatches_on_apache_server" {
  name       = "virtual_host_mismatches_on_apache_server"
  data       = file("${path.module}/data/virtual_host_mismatches_on_apache_server.json")
  depends_on = [shoreline_action.invoke_apache_config_reload_script]
}

resource "shoreline_file" "apache_config_reload_script" {
  name             = "apache_config_reload_script"
  input_file       = "${path.module}/data/apache_config_reload_script.sh"
  md5              = filemd5("${path.module}/data/apache_config_reload_script.sh")
  description      = "Verify the Apache configuration files to ensure all the virtual host configurations are correct and consistent."
  destination_path = "/agent/scripts/apache_config_reload_script.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_apache_config_reload_script" {
  name        = "invoke_apache_config_reload_script"
  description = "Verify the Apache configuration files to ensure all the virtual host configurations are correct and consistent."
  command     = "`chmod +x /agent/scripts/apache_config_reload_script.sh && /agent/scripts/apache_config_reload_script.sh`"
  params      = ["PATH_TO_APACHE_CONFIG_FILES"]
  file_deps   = ["apache_config_reload_script"]
  enabled     = true
  depends_on  = [shoreline_file.apache_config_reload_script]
}

