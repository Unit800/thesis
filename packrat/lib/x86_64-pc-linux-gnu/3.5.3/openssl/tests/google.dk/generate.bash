#!/bin/bash
# Copyright (c) 2012 The libmumble Developers
# The use of this source code is goverened by a BSD-style
# license that can be found in the LICENSE-file.

shopt -s expand_aliases

# Generate test fixtures from the source file, '*.google.dk-chain.pem'.
# This file was generated by visting www.google.dk in Google Chrome on Linux
# on 29-12-2012. The file was exported as 'Base64-encoded ASCII, certificate chain'.

# Generate PKCS12 file for testing X509Certificate::FromPKCS12
echo "" | openssl pkcs12 -export -nodes -nokeys -password stdin -out wildcard-google.dk-chain.p12 -in wildcard-google.dk-chain.pem

# Generate PKCS12 file with password 'password' for testing X509Certificate::FromPKCS12
echo "password" | openssl pkcs12 -export -nodes -nokeys -password stdin -out wildcard-google.dk-chain-password.p12 -in wildcard-google.dk-chain.pem

# Generate DER for leaf cert to test regular import, as well as other per-cert methods.
openssl x509 -in wildcard-google.dk-chain.pem -inform PEM -out wildcard-google.dk-leaf.crt -outform DER

# Generate SHA1 and SHA256 digests for leaf
cat wildcard-google.dk-leaf.crt | openssl sha -sha1 -binary > wildcard-google.dk-leaf.sha1
cat wildcard-google.dk-leaf.crt | openssl sha -sha256 -binary > wildcard-google.dk-leaf.sha256

# Extract notBefore and notAfter dates
alias mumble_tconv="python -c \"import sys; import time; import calendar; sys.stdout.write(str(int(calendar.timegm(time.strptime(sys.stdin.read()[:-1], '%b %d %H:%M:%S %Y %Z')))))\""
openssl x509 -in wildcard-google.dk-leaf.crt -inform DER -noout -startdate | sed 's,notBefore=,,' | mumble_tconv > wildcard-google.dk-leaf.notBefore
openssl x509 -in wildcard-google.dk-leaf.crt -inform DER -noout -enddate | sed 's,notAfter=,,' | mumble_tconv > wildcard-google.dk-leaf.notAfter