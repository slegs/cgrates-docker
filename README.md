# CGRATES for Docker

Stable Version=
Dev Version=

Cgrates is a telco billing, rating and realtime charging system built in the Go language. It is very fast and flexible. See below for more

* [Main website](http://www.cgrates.org/)
* [Wiki](https://cgrates.readthedocs.io/en/latest/)

Cgrates docker image based on mongodb backend for datadb and stordb. Based on Debian stretch using Cgrates prebuilt deb file http://www.cgrates.org/tmp_pkg/cgrates_0.9.1~rc8_amd64.deb

### Tags in Docker Hub

* Latest points to latest stable ( slegs/cgrates-docker:latest )
* Test points to latest dev which could be broken ( slegs/cgrates-docker:test )

### Global Config Environment Variables

* `CGRATES_CFG` with default `RAL`. Options currently `SESSION` and `RAL`. Copies in config relative to purpose.
* `MONGO_HOST` with default `127.0.0.1` though no Mongo DB server in build so wont work unless this value is set correctly. In Kubernetes pass the full cluster replicaset string as `MONGO_HOST` env variable (if using a Mongo DB replicaset).
* `MONGO_DATADB` with default `10`
* `MONGO_STORDB` with default `cgrates`
* `CGRATES_LOG_LEVEL` with default `1`
* `CONTAINER_TZ` with default `Europe/Dublin`

### SESSION Environment Variables

* `CGRATES_KAMAILIO_ENABLED` with default `false`. Used to update config to enable a Cgrates/Kamailio evapi real time rating and control connection.
* `CGRATES_SESSION_ENABLED` with default `false`
* `CGRATES_CONNS` with default `{"address": "127.0.0.1:2012", "transport": "*json"},`

#### SESSION Environment Variables used to construct Kamailio Hostname/Address.

Intent is to allow a 1-1 relationship between a Kamailio statefulset pod and a Cgrates session statefulset pod (should have matching number of replicas). Kamailio address is constructed using the variables below. If not using Kubernetes then just use `KAMAILIO_NAME` (IP/FQDN) and `KAMAILIO_EVAPI_PORT`.

* `CGRATES_NAME` with default `cgrates`. Primarily used in Kubernetes yaml file to pass name of pod being create to get the ordinal number of the statefulset pod for use in identifying the matching Kamailio pod for the session connection.
* `KAMAILIO_NAME` with default `kamailio`. In Kubernetes this should be the Kamailio statefulset clustername otherwise IP/FQDN
* `KAMAILIO_EVAPI_PORT` with default `8448`. Kamailio port listening for evapi from CGRATES
* `KAMAILIO_SUFFIX` with default empty string. Used to tag cluster dns suffix to end of constructed hostname usually in format `.cluster-name`. If empty will have no effect.

e.g. These env entries in your statefulset set deploy yaml file for a SESSION cgrates engine
```
        env:
        - name: CGRATES_CONFIG
          value: "SESSION"                                      # RAL OR SESSION
        - name: MONGO_HOST
          value: "mongo-mongodb-replicaset-0.mongo-mongodb-replicaset,mongo-mongodb-replicaset-1.mongo-mongodb-replicaset,mongo-mongodb-replicaset-2.mongo-mongodb-replicaset"
        - name: MONGO_DATADB
          value: "cgrates-datadb-test"
        - name: MONGO_STORDB
          value: "cgrates-stordb-test"
        - name: CGRATES_KAMAILIO_ENABLED                        # ENABLE EVAPI - default false
          value: "true"
        - name: KAMAILIO_NAME                                   # KAMAILIO SERVER NAME
          value: "kamailio-test"
        - name: KAMAILIO_EVAPI_PORT                             # EVAPI PORT TO LISTEN ON - default 8448
          value: "8448"
        - name: KAMAILIO_SUFFIX                                 # KAMAILIO CLUSTER
          value: ".kamailio-test"
        - name: CGRATES_SESSION_ENABLED                         # ENABLE SESSION - default false
          value: "true"
        - name: CGRATES_CONNS                                   # REMOTE RALS - default local address
          value: '{"address": "cgr-ral-test-0.cgr-ral-test:2012", "transport": "*json"},{"address": "cgr-ral-test-1.cgr-ral-test:2012", "transport": "*json"},{"address": "cgr-ral-test-2.cgr-ral-test:2012", "transport": "*json"},'
        - name: CGRATES_LOGGER                                  #Optional - *stdout
          value: "*stdout"
        - name: CGRATES_LOG_LEVEL                               #Optional - default 1
          value: "7"
        - name: CGRATES_IP
          valueFrom:
            fieldRef:
              fieldPath: status.podIP
        - name: CGRATES_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name

```
would construct a kamailio address of `kamailio-test-3.kamailio-test:8448` if CGRATES_NAME returned `cgr-session-test-3`. This gets updated via sed into the cgrates.json config for the cgrates pod using [start.sh](https://bitbucket.org/slegs/docker-cgrates/src/master/start.sh)
