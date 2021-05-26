rm *.pem

# 1. Generate CA's private key (ca-key.pem) and self-signed certificate
#    (ca-cert.pem).
openssl req -x509 -newkey rsa:4096 -days 365 -nodes -keyout ca-key.pem -out ca-cert.pem

# Show CA's self-signed certificate
echo "CA's self-signed certificate"
openssl x509 -in ca-cert.pem -noout -text

# 2. Generate web server's private key (server-key.pem) and certificate signing
#    request (CSR) (server-req.pem).
openssl req -newkey rsa:4096 -nodes -keyout server-key.pem -out server-req.pem

# 3. Use CA's private key to sign web server's CSR and get back the signed
#    certificate (server-cert.pem).
openssl x509 -req -in server-req.pem -days 60 -CA ca-cert.pem -CAkey ca-key.pem -CAcreateserial -out server-cert.pem -extfile server-ext.conf

# Show web server's signed certificate
echo "Server's signed certificate"
openssl x509 -in server-cert.pem -noout -text

echo "Server public and privete keys:"
echo $(pwd)/server-{key,cert}.pem | sed 's/\s/\n/g'

# Here are some extracts from the openssl manpages (OpenSSL 1.1.1f  31 Mar
# 2020) to help understand what the above commands do.

# ============================================================================

# req
# The req command primarily creates and processes certificate requests in
# PKCS#10 format. It can additionally create self signed certificates for use as
# root CAs for example.

# -x509 
#     This option outputs a self signed certificate instead of a certificate
#     request. This is typically used to generate a test certificate or a self
#     signed root CA. The extensions added to the certificate (if any) are specified
#     in the configuration file. Unless specified using the set_serial option, a
#     large random number will be used for the serial number.

#     If existing request is specified with the -in option, it is converted to the
#     self signed certificate otherwise new request is created.

# -newkey arg
#     This option creates a new certificate request and a new private key. The
#     argument takes one of several forms. rsa:nbits, where nbits is the number
#     of bits, generates an RSA key nbits in size. If nbits is omitted, i.e.
#     -newkey rsa specified, the default key size, specified in the
#     configuration file is used.

#     All other algorithms support the -newkey alg:file form, where file may be
#     an algorithm parameter file, created by the genpkey -genparam command or
#     and X.509 certificate for a key with appropriate algorithm.

#     param:file generates a key using the parameter file or certificate file,
#     the algorithm is determined by the parameters. algname:file use algorithm
#     algname and parameter file file: the two algorithms must match or an error
#     occurs. algname just uses algorithm algname, and parameters, if necessary
#     should be specified via -pkeyopt parameter.

#     dsa:filename generates a DSA key using the parameters in the file
#     filename. ec:filename generates EC key (usable both with ECDSA or ECDH
#     algorithms), gost2001:filename generates GOST R 34.10-2001 key (requires
#     ccgost engine configured in the configuration file). If just gost2001 is
#     specified a parameter set should be specified by -pkeyopt paramset:X

# -days n
#     When the -x509 option is being used this specifies the number of days to
#     certify the certificate for, otherwise it is ignored. n should be a
#     positive integer. The default is 30 days.

# -nodes
#     If this option is specified then if a private key is created it will not
#     be encrypted.

# -keyout filename
#     This gives the filename to write the newly created private key to.  If
#     this option is not specified then the filename present in the
#     configuration file is used.

# -out filename
#     This specifies the output filename to write to or standard output by
#     default.

# ============================================================================

# x509
# The x509 command is a multi purpose certificate utility. It can be used to
# display certificate information, convert certificates to various forms, sign
# certificate requests like a "mini CA" or edit certificate trust settings.

# -in filename
#     This specifies the input filename to read a certificate from or standard
#     input if this option is not specified.

# -noout
#     This option prevents output of the encoded version of the certificate.

# -text
#     Prints out the certificate in text form. Full details are output including
#     the public key, signature algorithms, issuer and subject names, serial
#     number any extensions present and any trust settings.
    
# -req
#     By default a certificate is expected on input. With this option a
#     certificate request is expected instead.

# -days arg
#     Specifies the number of days to make a certificate valid for. The default
#     is 30 days. Cannot be used with the -preserve_dates option.

# -CA filename
#     Specifies the CA certificate to be used for signing. When this option is
#     present x509 behaves like a "mini CA". The input file is signed by this CA
#     using this option: that is its issuer name is set to the subject name of
#     the CA and it is digitally signed using the CAs private key.

#     This option is normally combined with the -req option. Without the -req
#     option the input is a certificate which must be self signed.

# -CAkey filename
#     Sets the CA private key to sign a certificate with. If this option is not
#     specified then it is assumed that the CA private key is present in the CA
#     certificate file.

# -CAserial filename
#     Sets the CA serial number file to use.

#     When the -CA option is used to sign a certificate it uses a serial number
#     specified in a file. This file consists of one line containing an even
#     number of hex digits with the serial number to use. After each use the
#     serial number is incremented and written out to the file again.

#     The default filename consists of the CA certificate file base name with
#     ".srl" appended. For example if the CA certificate file is called
#     "mycacert.pem" it expects to find a serial number file called
#     "mycacert.srl".

# -CAcreateserial
#     With this option the CA serial number file is created if it does not
#     exist: it will contain the serial number "02" and the certificate being
#     signed will have the 1 as its serial number. If the -CA option is
#     specified and the serial number file does not exist a random number is
#     generated; this is the recommended practice.

# -out filename
#     This specifies the output filename to write to or standard output by
#     default.

# -extfile filename
#     File containing certificate extensions to use. If not specified then no
#     extensions are added to the certificate.
