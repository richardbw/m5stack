
# Setup CA:
Generate new CA certs and register, with provision template, in AWS:
```bash
$ ./create_register_CA.sh
```

# Create certs for things:
```bash
$ ./create_device_cert.sh
```


---

Copy key/cert to device:
```bash
$ ./copy_certs_to_device.sh
```

Clean-up locally generated files.  You will still need to delete from AWS
```bash
$ ./cleanup.sh
```

Scripts may depend on a file called `AWS_IOT_ENVARS`, containing:
```bash
JITP_ROLEARN='arn:aws:iam::999999999999:role/myJITProle'
```
