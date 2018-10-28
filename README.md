# transfer_more

Fast and lite file upload server ([transfer.sh](https://transfer.sh/) clone).

![screenshot](https://screenshots.firefoxusercontent.com/images/191ebbd9-a5ea-4fe9-ab8c-d896f59ea08c.png)

- It's a simple online file sharing.
- Files older than 7 days are destroyed (configurable).
- Recognize shebangs, magic numbers, ...

## Installation [![travis](https://travis-ci.org/Nephos/transfer_more.svg)](https://travis-ci.org/Nephos/transfer_more)

Compatible crystal 0.26.1

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
export TRANSFER_STORRAGE_DAYS=7     # how much time the files are kept
export TRANSFER_TIME_FORMAT="%y%m%d%H"
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

## Development

TODO: Write development instructions here

## Contributing

1. Fork it ( <https://github.com/Nephos/transfer_more/fork> )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [Nephos](https://github.com/Nephos) Arthur Poulet - creator, maintainer
