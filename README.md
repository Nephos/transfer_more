**Upstream on <https://git.sceptique.eu/Sceptique/transfer_more>**

# transfer_more

Fast and lite file upload server ([transfer.sh](https://transfer.sh/) clone).

![screenshot](https://raw.githubusercontent.com/Nephos/transfer_more/master/sample.png)

- It's a simple online file sharing.
- Files older than 7 days are destroyed (configurable).
- Recognize shebangs, magic numbers, ...

## Installation [![Build Status](https://drone.sceptique.eu/api/badges/Sceptique/transfer_more/status.svg)](https://drone.sceptique.eu/Sceptique/transfer_more)

Compatible crystal v1.9.2

### From source

```sh
make        # build the app / deps
make test   # run unit test
make doc    # build the documentation
```

### From AUR with yay (or yaourt etc.)

```sh
yay -S transfer-more
```

### As a systemd service

    [Unit]
    Description=Tranfer more file sharing
    Documentation=https://wiki.archlinux.org/index.php/Transfer-more

    [Service]
    ExecStart=/usr/share/transfer-more/transfer-more --port 10003 --bind 127.0.0.1
    Restart=on-failure
    RestartSec=5
    Environment="TRANSFER_SSL_ENABLED=true"
    WorkingDirectory=/usr/share/transfer-more/

    # Hardening
    MemoryDenyWriteExecute=true
    SystemCallArchitectures=native
    CapabilityBoundingSet=
    NoNewPrivileges=true
    RemoveIPC=true
    LockPersonality=true

    ProtectControlGroups=true
    ProtectKernelTunables=true
    ProtectKernelModules=true
    ProtectKernelLogs=true
    ProtectClock=true
    ProtectHostname=true
    ProtectProc=noaccess

    RestrictRealtime=true
    RestrictSUIDSGID=true
    RestrictNamespaces=true
    RestrictAddressFamilies=AF_UNIX AF_INET AF_INET6

    ProtectSystem=full
    ProtectHome=true
    PrivateDevices=true
    PrivateTmp=true

    [Install]
    WantedBy=default.target

### Behind a nginx proxy

You should configure your nginx with `/etc/nginx/servers-enabled/transfer-more.conf`:

    server {
      listen 443 ssl;
      server_name your.sub.domain;
      client_max_body_size 1G;
      proxy_set_header Host              $host;
      proxy_set_header X-Real-IP         $remote_addr;
      proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
      location / {
          proxy_pass http://localhost:3000;
      }
    }

## Usage

### Run the Server

```sh
export TRANSFER_SSL_ENABLED=true    # true if the ssl is enabled, any other string is false
export TRANSFER_BASE_STORAGE="/tmp" # where the files will be kept
export TRANSFER_SECURE_SIZE=4       # how much characters to identify a file
export TRANSFER_STORAGE_DAYS=7      # how much time the files are kept
export TRANSFER_TIME_FORMAT="%y%m%d%H"
export TRANSFER_HOST_PORT="localhost:3000" # in pinciple it is auto solved using the http headers, optional
export TRANSFER_MORE_FOOTER="Something <strong>important</strong> on the bottom" # replace the default footer
export TRANSFER_MORE_TITLE="MyName upload"                                       # replace the default title
./transfer_more
```

```text
./transfer_more --help
    -b HOST, --bind HOST             Host to bind (defaults to 0.0.0.0)
    -p PORT, --port PORT             Port to listen for connections (defaults to 3000)
```

### Command line client

```sh
curl --progress-bar --upload-file file.mp4  http://domain/name.mp4
```

### Inside a Docker container

```sh
docker build -t transfer_more . && docker run -p 3000:3000 transfer_more
```

Or with docker-compose:

```sh
docker-compose build && docker-compose up
```

### [ShareX](https://github.com/ShareX) template

```json
{
  "Name": "Sceptique",
  "DestinationType": "ImageUploader, TextUploader, FileUploader, URLShortener",
  "RequestURL": "https://up.sceptique.eu/",
  "FileFormName": "file",
  "Headers": {
    "User-Agent": "curl"
  }
}
```

## Development

For now I don't have much plan expanding the feature of it, as it fulfills all my needs.

I will keep updating with each crystal new release.

## Contributing

Feel free to propose new feature anyway, we can just put them behind feature flag if it's overkill.

Review your own coding style as possible.

Do not try to include external CI in the upstream, I don't want big centralized service of the GAFAM as possible.

You can either propose a patch in an issue or open a merge request on <https://git.sceptique.eu/Sceptique/transfer_more/fork>.

You can propose it on github if you want, but git.sceptique.eu accept github OAuth so it's very quick to setup and it's my prefered way.

## Contributors

- [Sceptique](https://git.sceptique.eu/Sceptique) Arthur Poulet - creator, maintainer
