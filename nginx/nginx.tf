terraform {
  required_providers {
    nginx = {
      source  = "getstackhead/nginx"
      version = "1.3.2"
    }
  }
}

provider "nginx" {
  # Configuration options
  #directory_available = "/etc/nginx/conf.d"  # if not set, defaults to /etc/nginx/sites-available
  #enable_symlinks     = false # all resources are created in the path defined at directory_available. directory_enabled is ignored.
}

# This will create file /etc/nginx/sites-available/test.conf and symlink /etc/nginx/sites-enabled/test.conf
resource "nginx_server_block" "my-server" {
  filename = "test.conf"
  enable = true
  content = <<EOF
# content of file here
EOF
}
