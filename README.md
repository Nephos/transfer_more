# transfer_more

[transfer.sh](https://transfer.sh/) clone in Crystal-lang based on kemalcr.

![screenshot_20171026_132102](https://user-images.githubusercontent.com/979584/32050320-a1ea9c9c-ba50-11e7-996b-f4fa60c74ae2.png)

- It's a simple online file sharing.
- Files older than 7 days are destroyed (configurable).
- Recognize shebangs, magic numbers, ...


## Installation [![travis](https://travis-ci.org/Nephos/transfer_more.svg)](https://travis-ci.org/Nephos/transfer_more)

```sh
make        # build the app / deps
make test   # run unit test
make doc    # build the documentation
```


## Usage

### Run the Server

```sh
export TRANSFER_BASE_URL="https://domain.com:80"
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

1. Fork it ( https://github.com/Nephos/transfer_more/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [Nephos](https://github.com/Nephos) Arthur Poulet - creator, maintainer
