
# Setup CA:
Generate new CA:
```bash
$ ./setup_CA.sh
```

Create verification cert, and upload to AWS:
```bash
$ ./register-verificationCert.sh
```

Clean-up locally generated files.  You will still need to delete from AWS
```bash
$ ./cleanup.sh
```

Scripts may depend on a file called `AWS_IOT_ENVARS`, containing:
```bash
JITP_ROLEARN='arn:aws:iam::999999999999:role/myJITProle'
```
