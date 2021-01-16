
## Daemons
Put all services in `/etc/systemd/system/MY_SERVICE_NAME.service`

```
$ systemctl start MY_SERVICE_NAME.service  # Start it
$ systemctl enable MY_SERVICE_NAME.service # Start at boot
```

