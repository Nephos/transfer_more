**Upstream on <https://git.sceptique.eu/Sceptique/transfer_more>**

# transfer_more

Fast and lite file upload server ([transfer.sh](https://transfer.sh/) clone).

![screenshot](https://raw.githubusercontent.com/Nephos/transfer_more/master/sample.png)

- It's a simple online file sharing.
- Files older than 7 days are destroyed (configurable).
- Recognize shebangs, magic numbers, ...

## Installation [![Build Status](https://drone.sceptique.eu/api/badges/Sceptique/transfer_more/status.svg)](https://drone.sceptique.eu/Sceptique/transfer_more)

Compatible crystal v1.4.1

### From source

```sh
make        # build the app / deps
make test   # run unit test
make doc    # build the documentation
```

### From AUR with yaourt

```sh
yaourt -S transfer-more
```

## Usage

### Run the Server

```sh
export TRANSFER_SSL_ENABLED=true    # true if the ssl is enabled, any other string is false
export TRANSFER_BASE_STORAGE="/tmp" # where the files will be kept
export TRANSFER_SECURE_SIZE=4       # how much characters to identify a file
export TRANSFER_STORAGE_DAYS=7      # how much time the files are kept
export TRANSFER_TIME_FORMAT="%y%m%d%H"
export TRANSFER_HOST_PORT="localhost:3000" # in pinciple it is auto solved using the http headers, optional
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

### Inside a docker

If you are using docker-compose:

```sh
docker-compose build && docker-compose up
```

Else, you can do:

```sh
docker build -t transfer_more . && docker run transfer_more
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
