# transfer_more

transfer.sh clone in Crystal-lang

# Multi-part is not supported yet (so big files may not pass)

## Installation

```sh
make        # build the app
make test   # run unit test
make doc    # build the documentation
```



## Usage

### Server
```sh
export TRANSFER_BASE_URL="https://domain.com:80"
export TRANSFER_BASE_STORAGE="/tmp"
./transfer_more
```

Files older than 7 days are destroyed.

```text
./transfer_more --help
    -b HOST, --bind HOST             Host to bind (defaults to 0.0.0.0)
    -p PORT, --port PORT             Port to listen for connections (defaults to 3000)
    -e ENV, --environment ENV        Environment [development, production] (defaults to development). Set `production` to boost performance
    -s, --ssl                        Enables SSL
    --ssl-key-file FILE              SSL key file
    --ssl-cert-file FILE             SSL certificate file
    -h, --help                       Shows this help
```

### Client
```sh
curl --progress-bar --upload-file file.mp4  http://domain/name.mp4
```


## Development

TODO: Write development instructions here

## Contributing

1. Fork it ( https://github.com/Nephos/transfer_more/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [Nephos](https://github.com/Nephos) Arthur Poulet - creator, maintainer
