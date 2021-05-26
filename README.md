# Generate self-signed certificates for HTTPS

The code in `gen.sh` was made from this [YouTube video](https://youtu.be/7YgaZIFn7mY).
`gen.sh` is a bash script that makes certificates for a CA (Certificate
Authority) and signs a certificate for a server. Then you can use the CA's
public key in `ca-cert.pem` to add it to your browser's CA store, and serve an
HTTPS local server for development (for example Live Server from VS Code) with
the server's public and private keys in `server-cert.pem` and `server-key.pem`
respectively.

`server-ext.conf` contains certificate extensions to use for generating the
public key of the server, these are other domain names or IP's for which the
certificate will be valid. For example:

```
subjectAltName=IP:127.0.0.1,DNS:nice.com,IP:192.168.1.104
```

That will also make the certificate valid for IPs `127.0.0.1` and
`192.168.1.104`, and domain name `nice.com`.

The generated files are:

- `ca-cert.pem`: the public key of the CA.
- `ca-key.pem`: the private key of the CA.
- `server-key.pem`: the private key of the server.
- `server-req.pem`: the request of ther server for the CA to sign.
- `server-cert.pem`: the public key of the server.
- `ca-cert.srl`: the serial number of the signed request.

## Usage

```bash
chmod u+x gen.sh # Add the necessary permissions
./gen.sh # Execute
```