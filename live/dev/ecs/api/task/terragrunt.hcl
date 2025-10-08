include "env" {
  path = find_in_parent_folders("env.hcl")
  expose = true
}

include "api" {
  path = find_in_parent_folders("api.hcl")
}

terraform {
  source = "${get_path_to_repo_root()}/modules/aws/deploy/task"
}

inputs = {
  name = "api"
  aws_region = include.env.locals.region
  cpu    = 256
  memory = 512
  # requires_compatibilities = ["EC2"]
  log_group_name = "api"

  containers = [
    {
      name               = "api"
      image              = "448049813494.dkr.ecr.us-east-1.amazonaws.com/api-ecr-dev:86baf11c5451f2fccc52f0b703161ebd1e215213"
      cpu                = 256
      memory             = 512
      essential          = true
      port_mappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "PORT"
          value = 80
        },
        {
          name  = "COOKIE_SECRET"
          value = "24724855664f60b9c1c2d127b4560a1f71b34c588d289ebdfb0ce63362efb259"
        },
        {
          name  = "PUBLIC_REFRESH_TOKEN_KEY"
          value = <<EOF
          -----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvSPkFz2oJgerCgyJUTwy
TlpEYU0wgqVzSkxIVZl35gLCRkm1vWUDBs1/i5aqHqyYrbTmQFBpBwavP+EhmT3R
1dwuEHD81cJCdm77lzroAeE1nE49OAGNpJ8RDxjWE2vpFotkRgC5MgpCkdDZNcTK
exJQzVKFGQH/qTe7gEj4rhXmo+zBfYpLPJlunivmL5TKTmLXz9VBGWDOcFbWYMCa
LPMf3tUKphbGaFWN0YVPf/Y1u1U97xVQaYmK0tOr69Xr/iowN7Kh44MFxP1kwhN5
10BLDNS1LiCxlbAjshqsZBptWWZVd4SX4un0PL20umXZmE+cSAvEzQ3q9pPZLtyl
sQIDAQAB
-----END PUBLIC KEY-----
EOF
        },
        {
          name  = "PRIVATE_REFRESH_TOKEN_KEY"
          value = <<EOF
          -----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC9I+QXPagmB6sK
DIlRPDJOWkRhTTCCpXNKTEhVmXfmAsJGSbW9ZQMGzX+LlqoerJittOZAUGkHBq8/
4SGZPdHV3C4QcPzVwkJ2bvuXOugB4TWcTj04AY2knxEPGNYTa+kWi2RGALkyCkKR
0Nk1xMp7ElDNUoUZAf+pN7uASPiuFeaj7MF9iks8mW6eK+YvlMpOYtfP1UEZYM5w
VtZgwJos8x/e1QqmFsZoVY3RhU9/9jW7VT3vFVBpiYrS06vr1ev+KjA3sqHjgwXE
/WTCE3nXQEsM1LUuILGVsCOyGqxkGm1ZZlV3hJfi6fQ8vbS6ZdmYT5xIC8TNDer2
k9ku3KWxAgMBAAECggEADtcAEGrABKvZWaJ+K6eDcu5WKyQ5SCbfEtdFXaH67EsP
HyCtZ7zDLgd1mGgr1NhJ6mclIaqtcuWtXl+1mSZmjlcGLjgPPl5NhKlUiBsRFQSs
hiUFXJ2SlXX9iqeyNDflQ+WP6oYoAasYagRu5m8YS+u190YgN0QW4RoEVh5jlJT0
beHuwZVkaaL90vpk9jqO1bzz6zLXdcjqIt2MwSHqEIHGk1iVCiZYG/puAQ4qWeTo
7Utchde11fpUJH5RhBhl/lzo4GOA0qp4m4HaBtFtUh80M8c/8o3N3L2RY9iftD7H
aDH5Ih5T2ue4AzpoOZqVM/amhYm+QaGaytub3fnTGQKBgQD+MnGFe4XHkVXcheh9
wXe87AdXMtd2v96Vji/dKxMknsh5lRTJ+KLtcmE7PU4jAjXNRkQVtFd2KwS3o1aa
rAuvVNhQMxGT15eQc9vehRbdPpQlf3lZavZnSh00wg2Pw7Ymv0lcy+BD/lY8f0aa
GL/lqNKlzK40IxtHF6OoqoecVwKBgQC+e1ItywviAx3CloKKJ3DwS13owhgLcErD
sqwFUtGk1MVuLFHO1IP3HXUreQYdQPMmIc9y2T+16njFTdXJI2qLL5kB6FTr4ohr
j1c3ivqdBGImAEpYYv2pQoqQExmUqtKeech30c4MvKt4Q/dhU74b1jRAQWa8aDyz
YY6Snb0JNwKBgALuqgiUKDLpJkho8wmgVbVEM8F5wKqKBBNNlJfEi2/8tOtSIO9D
gv2iOCTqzB/zQpOfn+FwNyIR1PgZVkJqgagAHo6uSCGgdwsfiwXCG0VqF2NnWQsD
BNykKjoVkvp5k3xW8I21fFzMbko8XaAhcPVBQUzQU6IeVY44Y5bqgK35AoGAQPxj
2hm28SHtClE9MhMoteKQpHNrrqNd7oxLoflSavDodqEKPA1HBIz5R56flmVtTyoj
02QJF3BqSa43bMr3c4sGoZ75Mgz0S/X4ZIu22tD/B0X8F1GWhyObkHHjvVPWTZjw
6ugaa0AHJB3UDVF7v5WB+BYYDdlmNDDpal4Ee1sCgYEAs6cf0OoFXY2X2dEKSdAI
by0FKEvbZTPIl/A3fREBE3ydJTmq6O360IWaUb16TzrmRs9gpeQaWq5eJDTaVZqG
tkfaEJYVp1Lq9faWcJ0n8JMdUB4WHiaYU+kvl+O64/Y5vU52RSBLYxyJWV5DZOau
dGqsGi7qU/v6kR5/TSx6yxo=
-----END PRIVATE KEY-----
EOF
        },
        {
          name  = "PUBLIC_ACCESS_TOKEN_KEY"
          value = <<EOF
          -----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAshtBJaHBWdQ5Ul8OCLHy
WFGTH8jUvYXH7Si1rAefB0UybLSPK+84BogCG3juiUkIOsDLLHGVHnQ7UwakuHOD
s5BHkCytFx49jbmy7V/611j9sI4zHOWnNmCK8ozbQ1wSb8FgaJ1O2AohbyUeG6YD
u5KYYUzbv86iWCxM3c2oR5IepV09t6XyCNksnU7/2HbYcMCZoqvvMnHdwL3Q0I+Y
SWVOUPP++KvPmZhkVCYehUfPxw9jdrZh6Xc/K5PeoJkrvdfJt5YhQGpCblHwL5ao
f6v/Z3YYBrnScC4GZVk+el+CyYhqW0lpN3fs2l8QO+/fXcx6CPftKnVUvc8Px2sO
GwIDAQAB
-----END PUBLIC KEY-----
EOF
        },
        {
          name  = "PRIVATE_ACCESS_TOKEN_KEY"
          value = <<EOF
          -----BEGIN PRIVATE KEY-----
MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCyG0ElocFZ1DlS
Xw4IsfJYUZMfyNS9hcftKLWsB58HRTJstI8r7zgGiAIbeO6JSQg6wMsscZUedDtT
BqS4c4OzkEeQLK0XHj2NubLtX/rXWP2wjjMc5ac2YIryjNtDXBJvwWBonU7YCiFv
JR4bpgO7kphhTNu/zqJYLEzdzahHkh6lXT23pfII2SydTv/YdthwwJmiq+8ycd3A
vdDQj5hJZU5Q8/74q8+ZmGRUJh6FR8/HD2N2tmHpdz8rk96gmSu918m3liFAakJu
UfAvlqh/q/9ndhgGudJwLgZlWT56X4LJiGpbSWk3d+zaXxA7799dzHoI9+0qdVS9
zw/Haw4bAgMBAAECggEAJeA35XnVtXW1TvgZ8u1svS1z3TGHVFqL3rpmkBP61L/5
bjajr9MqlfD8ib0Y9ScL0frH+kaZUKWlLA3gn70pB9mp7lYh5SWwL2CLVYGwxXUO
ViqXYhDQk3bKdbRQuK1u2kdEalrxtm3JGGrLUVPnvU76is6eeNbHnXqmShD/NWDZ
w1r9VUqkvJ1P1VDoiewCTeZcomhQKP+h9jCYBYMjiBgiCRylTaR6xUlfntD1sFvV
oIAiHFEsqgq3050a5o7JCGUuJ3dliksDgXGR4778fjMaNYx2DdHTnYvA7FObTI2b
5+mueP1SUu67qfudL+sxnPqjm7vD+G8OksYk9nRIeQKBgQDWy/vxXAG8rfeECxKR
TxQleGJgPedrbKR6GJbOlM2ms/tmeizSY93FcZarBDv8OLB82Z5ZpYBqd95sc/45
jjAIVhkG7JugevDKG2ofdNMhG0T0Pjr/SMWOo1SWI8Oizn8a6ptRyxsvfUI9xdBh
d5Hj54gMbjMfyt8L8J9hCe45XwKBgQDURYTrlpYCV19KOEEQMyeDFeRlNNhzzgj+
0VeppAzeEnjDZEHP6FRu91ilDGG9UohouYANbXJqz78IIFJ/vDa0zlQfVtfztT67
Tg4NW5TG6BfCGRwGUDlETsMYDL9K9TRuv9YJXDhgoH4w9+EUf+tosg09H6OBfW9l
/fDsNUgYxQKBgQC1cse30iNdghAvKTNcMNMx/AoOhvyxUKt4wMDUbftzsWLT5K1s
ZRR4sEW43fDWVgUw0pzj2d0rE2t/blT5xdVplWG66bFl1bUG5jW1sPiRZPnQ4ajw
8kaBAhR4aGnhZFMXJ8xhQhQK/+MvT6WCUIGbZoEVDxp85uGYsoHQdZUaPQKBgEEt
c2nPHBJt94FXkorB2kECyNVWi5vLSLHNX6hkCdtqOpBsSVToVnyYECzlh2FVZTMa
ujnlQDuRvGtnWU2FYhrUO7o/tSFMpo1moyPw2dbVTu43PYamvV6+/GJ3D4mZjtbu
qm7HVTw+K2Eny4G64XKNMUlyXIcXF8xuU7qDhbatAoGBAISNqyE5o2klWUOXz1N2
VLAoUQUtFE7swHzd2Syz4WoDDktboWGPZT4X61FYeyRa47YjZvzHfJPImS470p53
o1LderI4grJD57weByjVM/HTnp+SDrc/LGgeqQgSVM7kW7fM5LCjN4Gje3l4vk4n
NhyoVL4LplbOZHLD35P9w271
-----END PRIVATE KEY-----
EOF
        },
        {
          name  = "MONGO_HOST"
          value = "activatree-db-dev.cpo28yiia8r9.us-east-1.docdb.amazonaws.com"
        },
        {
          name  = "MONGO_INITDB_ROOT_USERNAME"
          value = "poweruser"
        },
        {
          name  = "MONGO_INITDB_ROOT_PASSWORD"
          value = "SuperSecret123!"
        },
        {
          name  = "MONGO_PORT"
          value = "27017"
        },
         {
          name  = "MONGO_INITDB_DATABASE"
          value = "auth_service"
        },
      ],
      # secrets = [
      #   {
      #     name       = "DB_PASSWORD"
      #     value_from = "arn:aws:ssm:us-east-1:123456789012:parameter/db-password"
      #   }
      # ]
    }
  ]
}







