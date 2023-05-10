# Provision DMZ Network VPC and Subnets
module "network_vpc_dmz" {
  providers = {
    flexibleengine = flexibleengine.network_fe
  }

  source = "../modules/vpc"

  vpc_name = "vpc-dmz"
  vpc_cidr = "192.169.0.0/16"
  vpc_subnets = [{
    subnet_cidr       = "192.169.1.0/24"
    subnet_gateway_ip = "192.169.1.1"
    subnet_name       = "subnet-dmz"
    }
  ]
}

// if you haven't setted yet CCE on this tenant, you should have an agency for CCE service.
// this agency could be created as well, in console automatically the first time you use CCE. if you have already setted up CCE, consider commenting this module deployment.
module "cce_agency" {
  providers = {
    flexibleengine = flexibleengine.home_fe
  }

  source = "../modules/iam/agency"

  name = "cce_admin_trust"
  delegated_service_name = "op_svc_cce"
  tenant_name = var.network_tenant_name
  roles = [ "Tenant Administrator" ]
  domain_roles = [ "OBS OperateAccess" ]
  duration = "FOREVER"
}


// CCE Cluster
module "dmz_cce_cluster" {
  providers = {
    flexibleengine = flexibleengine.network_fe
  }

  source = "../modules/cce"

  cluster_name      = "cluster-dmz"
  cluster_desc      = " Cluster for testing purpose"
  //availability_zone = "eu-west-0a"

  vpc_id          = module.network_vpc_dmz.vpc_id
  network_id      = module.network_vpc_dmz.network_ids[0] 
  cluster_version = "v1.25"
  
  cluster_high_availability = true
  cluster_type = "VirtualMachine"
  cluster_size = "large"
  cluster_container_network_type = "overlay_l2"

  node_os  = "EulerOS 2.9" // Can be "CentOS"
  key_pair = module.keypair.name

  nodes_list = [
    {
      node_index         = "node0"
      node_name          = "cce-node1"
      node_flavor        = "s3.large.2"
      availability_zone  = "eu-west-0a"
      root_volume_type   = "SATA"
      root_volume_size   = 40
      data_volume_type   = "SATA"
      data_volume_size   = 100
      node_labels        = {}
      vm_tags            = {}
      postinstall_script = null
      preinstall_script  = null
      taints             = []
    }
  ]

  depends_on = [
    module.keypair, module.network_vpc_dmz, module.cce_agency
  ]
}




// ELB
module "elb" {
  providers = {
    flexibleengine = flexibleengine.network_fe
  }

  source = "../modules/shared-elb"

  loadbalancer_name = "elb"
  subnet_id = module.network_vpc_dmz.subnet_ids[0]
  vip_address = "192.169.1.149"
  security_group_ids = [module.sg_firewall.id]

  tags =  {
    Environment = "landing-zoneee"
  }

  cert = true
  // making cert=true must either create a new certificate by putting certificate and private key.
  // Or if you have already a certificate put its certificate ID

  domain = "my-domain-name.com"
  cert_name = "my-cert-name"
  private_key = <<EOT
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAj8jVnej6gpeTmCCjAHXmsfBGQwej8RQ5Tl+762iQkE/0q9W0
W9laOl2seelFarXDxPf2/3FfROfwXErB4e8/XpSZRARVbtIhpQJ9Um5gnYP3TnnQ
bkeahQn84bGZiQ141Qot7gUy+fH9aHLzDCOk3dS+fA41ljht8k0r9/gwEOXlvpBv
NQTBt6yP8mb+0wBv2q77NOwWJ4GuknwGUv7VHvc4ZVG/V1poNB9Muxqa+E7kCHJ+
ChhDiX1jEtaMaaY+vIZyXrMKLyFsP75Ol4EnxA1Wb45u/fnJy8fxP3unIikgRc20
X8YZkAyvdKc3L2s7wKIv0T3nOfcL64eTFGXfBwIDAQABAoIBAEQzKSvY/bXiyrW+
SUKnKdEd3F3f6mGny5TCsQJ0mxlwa2f0GjP00SjdFLnQrUXzyFONoEFCl8M51pcY
OIV/s0mb52TNP26syhuYJjRquXYNSckV24jrer3+4k11LZPF6Zn3VZjQK4FFyIJ5
/5Gy+Hjl96IlJULHKlNjSmc4eCgTBVI8GXAou/xkqdL5IBnhdLfnf+DVWVaTPHmQ
XW2ner7YATrmd38VCuRYfhoxe5sKqy4NAhafjBuxi7I59QJEw0uc0sS9d8NmvGyZ
yPz2rEELXMn8/FlV6yawwJKzhQ7ysenO1kkVmRDZ18naQg9j19LklRjTwKyRHMiq
nctozOUCgYEAzvumNVQhxoMkyvY8ac0HgoN+A775J/lAIYvGpZSKy4+8+p4pHWsG
TAt/lp8JObtAnZ0WI3MkeKQ/QxdiicMH9muh3MYoH/1FA/qVF/+wPfN8gHD7ba8A
IzpUOMgPv6YbSX+e1kFXycH7tpISW+kTz3gugHd2VIFDnlf6nFmX520CgYEAsdXG
SRyal2IqUjdPFa8lh2mthzKjubnrM+vd4BQr8zTBiQEqurDJYbDQFQZPNEs7DIGv
bDZUdyb/Hwyltn8oB9JlneeiDELpij4JIsXJ4OkW9U1ml9xEVDSdn71/3EfZG/Fe
AH1gkd+bvJnH1HidcCwaO4/6SERlENcD9Onhk8MCgYEAy3B+0gXKWNKHtFHH2Xnj
Or3Bey8Wt9p91TsMWa0hqqix52bTJI4QF2hp1IKmT68j+IbwvpEqtMVDRM9UU/F0
/xiVdGj0AVUvo5SFPJxc/tc2dQwXpJwQN4/aPiEtkYJTaa9dUFvTTIQ0wyLZlqsF
hLMsiaphjPesnZL9yPUqoBUCgYBY6dhk758/dz5PswWggtyRsr2nLiN8Fb/KSvC5
O3yp8cOd+25gv0lAxcWT7X6mV8LjQufxg8yBcob2AD3OXA8osgJKi+iSltXrX47z
ys5f3Eq1RQi5ftDPBSuWFYobGfUsKmbkectRw+o6xuyJh/C3h+VpyFfL0B5z5/07
c8BsPwKBgAlNSkINF/q1Kk7+NVKAmOFtb8yCfVqekDehpowSw17WFsyziST8J5vn
mndA9D2tyO6XhuHAfh6fZrcp0Xpz/34Eh5/I+dtHRDcEx5ggo6GSFlL3k4jQNxvW
ShPz+DL6zEPDIyZDRma4nCEkOrI+5f6hOj08Uw5DLy00l/NuCuu1
-----END RSA PRIVATE KEY-----
EOT

  certificate = <<EOT
-----BEGIN CERTIFICATE-----
MIIDlTCCAn2gAwIBAgIERui7ZjANBgkqhkiG9w0BAQsFADBbMScwJQYDVQQDDB5SZWdlcnkgU2Vs
Zi1TaWduZWQgQ2VydGlmaWNhdGUxIzAhBgNVBAoMGlJlZ2VyeSwgaHR0cHM6Ly9yZWdlcnkuY29t
MQswCQYDVQQGEwJVQTAgFw0yMzA0MjcwMDAwMDBaGA8yMTIzMDQyNzIxMTU1N1owVzEjMCEGA1UE
AwwadGVzdC5mbGUteGlibGUtZW5nLWluZS5jb20xIzAhBgNVBAoMGlJlZ2VyeSwgaHR0cHM6Ly9y
ZWdlcnkuY29tMQswCQYDVQQGEwJVQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAI/I
1Z3o+oKXk5ggowB15rHwRkMHo/EUOU5fu+tokJBP9KvVtFvZWjpdrHnpRWq1w8T39v9xX0Tn8FxK
weHvP16UmUQEVW7SIaUCfVJuYJ2D90550G5HmoUJ/OGxmYkNeNUKLe4FMvnx/Why8wwjpN3UvnwO
NZY4bfJNK/f4MBDl5b6QbzUEwbesj/Jm/tMAb9qu+zTsFieBrpJ8BlL+1R73OGVRv1daaDQfTLsa
mvhO5AhyfgoYQ4l9YxLWjGmmPryGcl6zCi8hbD++TpeBJ8QNVm+Obv35ycvH8T97pyIpIEXNtF/G
GZAMr3SnNy9rO8CiL9E95zn3C+uHkxRl3wcCAwEAAaNjMGEwDwYDVR0TAQH/BAUwAwEB/zAOBgNV
HQ8BAf8EBAMCAYYwHQYDVR0OBBYEFJ7/3T+1Jk675IvAgb9HJ+D0cOToMB8GA1UdIwQYMBaAFJ7/
3T+1Jk675IvAgb9HJ+D0cOToMA0GCSqGSIb3DQEBCwUAA4IBAQBhIGyZwwr2wCVCKCiyONLeoUJh
x5TyQ1xdGwzxflB0Ue8u06LkYouR5Jo1KBkGj7MSCWabC0l7GZ3XcV5eMQ5JJSzM770evmNQTES3
I2WzxqnvDU0Ag5NNgXILjpHnBHP+s4ctdBWmOVeLFMygcOnnRhheGFKjKXhGwgOX/1Yv1qnzehJG
ZLOkHBLfNvHUN2QmL3J1Ma9dUPtgHgs91qWE7kSqt2zTEeNvuc9tvwludJzCan02BNMVRQhMevSJ
DC6FvpVEs8+tRudRfBXDJlaxw7MfMywsbDuTupthWOXJRseXRqTw7P3kxL+qSAurMQnqMJEbZXXS
RUrGxwdkw13Q
-----END CERTIFICATE-----
EOT
  //certId = "a67adc649b8a44d6ae7b5fb0041ed7d8" 
  //if you have already put certificate and privateID to create a new certificate, this variabla will be not necessary.

  listeners = [
    {
      name     = "testlistener"
      port     = 8080
      protocol = "TERMINATED_HTTPS"
      hasCert  = true  // must be true for HTTPS listener
      description = "test desc"
      
      http2_enable = true
      transparent_client_ip_enable = true
      idle_timeout = 40
      request_timeout = 50
      response_timeout = 60
      tls_ciphers_policy = "tls-1-1"
      
      tags = {
        Environment = "landing-zoneee"
      }
    },
    {
      name     = "httpslistener"
      port     = 80
      protocol = "HTTP"
      hasCert  = false
      description = "fsdffdsfd"
    }
  ]

  pools = [{
    name           = "pool_test"
    protocol       = "HTTP"
    lb_method      = "ROUND_ROBIN"
    listener_index = 0
    },
    {
      name           = "pool_test2"
      protocol       = "HTTP"
      lb_method      = "ROUND_ROBIN"
      listener_index = 1
    }
  ]

  backends = [
    {
      name          = "backend1"
      port          = 5044
      address_index = 0
      pool_index    = 0
      subnet_id     = module.network_vpc_dmz.subnet_ids[0]
      weight = 4
      admin_state_up = true
    },
    {
      name          = "backend2"
      port          = 5044
      address_index = 1
      pool_index    = 0
      subnet_id     = module.network_vpc_dmz.subnet_ids[0]
    }
  ]

  backends_addresses = ["192.169.1.102", "192.169.1.247"]

  monitors = [
    {
      name           = "monitor1"
      pool_index     = 0
      protocol       = "HTTP"
      delay          = 20
      timeout        = 10
      max_retries    = 3
      url_path       = "/check"
      http_method    = "GET"
      expected_codes = "400-404"
    },
    {
      name           = "monitor2"
      pool_index     = 1
      protocol       = "HTTP"
      delay          = 20
      timeout        = 10
      max_retries    = 3
      url_path       = "/check"
      http_method    = "GET"
      expected_codes = "200"
    }
  ]  

  l7policies = [
       {
      name                    = "redirect_to_https"
      action                  = "REDIRECT_TO_LISTENER"
      description             = "l7 policy to redirect http to https"
      position                = 1
      listener_index          = 1
      redirect_pool_index     = null
      redirect_listener_index = 0
    }
  ]

  /*
  l7policies_rules = [
    {
      type           = "PATH"
      compare_type   = "EQUAL_TO"
      value          = "/api"
      l7policy_index = 0
      description = "rulee l7 "
    }
  ]
  */
  
}