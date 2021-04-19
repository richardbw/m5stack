
# Setup CA:
Generate new CA:
```bash
$ ./setup_CA.sh
```

Create verification cert, and upload to AWS:
```bash
$ ./create-and-register-verificationCert.sh
```

Clean-up locally generated files.  You will still need to delete from AWS
```bash
$ ./cleanup.sh
```
