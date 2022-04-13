# SMS/TSM Datastream to metadata linker proposal

## ZID/TSM Basic STA Model

### Model

![ZID Basic STA Model](docs/BASIC-STA-Model.png)

We use the `THING` as equivalent for a datasource. It may also be called *data logger*. 

### Examples

#### Thing


|             |                                                                                                                                                                                                   |
|-------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| id          | `1`                                                                                                                                                                                               |
| name        | `CRNS 01`                                                                                                                                                                                         |
| uuid        | `b3b16570-5e55-11ec-902c-54e1ad7c5c19`                                                                                                                                                            |
| description | `NULL`                                                                                                                                                                                            |
| properties  | `{"parsers": [{"type": "CsvParser", "settings": {"header": 3, "delimiter": ",","skipfooter": 1, "timestamp_column": 1, "timestamp_format": "%Y/%m/%d %H:%M:%S"}}],"default_parser": "CsvParser"}` |
  


#### Datastream

|             |                                                |
|-------------|------------------------------------------------|
| id          | `7`                                            |
| name        | `CRNS 01/7`                                    |
| description | `NULL`                                         |
| properties  | `{"created_at": "2021-12-16 12:42:35.207198"}` |
| position    | `7`                                            |
| thing_id    | `1`                                            |


#### Observation

|                       |                                                                                                                                                                                                                                                                                                                                                                                                                         |
|-----------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| id                    | `7`                                                                                                                                                                                                                                                                                                                                                                                                                     |
| phenomenon_time_start | `NULL`                                                                                                                                                                                                                                                                                                                                                                                                                  |
| phenomenon_time_end   | `NULL`                                                                                                                                                                                                                                                                                                                                                                                                                  |
| result_time           | `2014-08-27 12:10:26.000000 +00:00`                                                                                                                                                                                                                                                                                                                                                                                     |
| result_type           | `1`                                                                                                                                                                                                                                                                                                                                                                                                                     |
| result_number         | `19.4`                                                                                                                                                                                                                                                                                                                                                                                                                  |
| result_string         | `NULL`                                                                                                                                                                                                                                                                                                                                                                                                                  |
| result_json           | `null`                                                                                                                                                                                                                                                                                                                                                                                                                  |
| result_boolean        | `NULL`                                                                                                                                                                                                                                                                                                                                                                                                                  |
| result_latitude       | `NULL`                                                                                                                                                                                                                                                                                                                                                                                                                  |
| result_longitude      | `NULL`                                                                                                                                                                                                                                                                                                                                                                                                                  |
| result_altitude       | `NULL`                                                                                                                                                                                                                                                                                                                                                                                                                  |
| result_quality        | `null`                                                                                                                                                                                                                                                                                                                                                                                                                  |
| valid_time_start      | `NULL`                                                                                                                                                                                                                                                                                                                                                                                                                  |
| valid_time_end        | `NULL`                                                                                                                                                                                                                                                                                                                                                                                                                  |
| parameters            | `{"origin": "https://tsm.intranet.ufz.de/crns01-b3b16570-5e55-11ec-902c-54e1ad7c5c19/CRS01_Data1408271210.566_000001.txt?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=minioadmin%2F20211216%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20211216T124234Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=ebbcd27e14daa571559a1a52341ddc7c63d50054d1130b7c6ab1969386b9b403", "column_header": "T3_C"}` |
| datastream_id         | `7`                                                                                                                                                                                                                                                                                                                                                                                                                     |
 
## Unique Datastream id

To identify a data stream we can make use of the things global unique id and the datastream id. 
To allow linking both ways we also need to use the instance identifier.

|               |                                        |
|---------------|----------------------------------------|
| thing.uuid    | `b3b16570-5e55-11ec-902c-54e1ad7c5c19` |
| datastream.id | `7`                                    |
| instance      | `tsm.intranet.ufz.de`                  |

A possible one string (persistent?) id would be `<instance>/<thing.uuid>/<datastream.id>` (i.g.
`tsm.intranet.ufz.de/b3b16570-5e55-11ec-902c-54e1ad7c5c19/7`) 

## SMS: Unique Measured quantity id 

`<sms-instance><configuration.id><device_property.id>`

- maybe device URN can be part of the identifier?

TBC.

## SMS TSM Linker

### Model

![SMS/TSM Linker Model](docs/sms-tsm-linker.ddl.png)

See [sms-tsm-linker.ddl.sql](sms-tsm-linker.ddl.sql) for details and further constraints. Start 
and end date can be `null` as it is possible that a linkage never ends or starts with the 
beginning of time. ;) 

### Example

|                        |                                        |
|------------------------|----------------------------------------|
| id                     | `1`                                    |
| tsm_instance           | `tsm.intranet.ufz.de`                  |
| tsm_thing              | `b3b16570-5e55-11ec-902c-54e1ad7c5c19` |
| tsm_datastream_id      | `7`                                    |
| sms_instance           | `webapp-stage.intranet.ufz.de/sms/`    |
| sms_configuration_id   | `23`                                   |
| sms_device_property_id | `42`                                   |
| start_date             | `2010-01-01 12:00:00.000000 +00:00`    |
| end_date               | `2020-01-01 12:00:00.000000 +00:00`    |

The start and end date could be derived from the device events `mount` and `unmount`.

## Proposal for a (basic) frontend

![Basic frontend proposal](docs/user-interface-proposal.png)

## Assistance for prefilling the SMS/TSM Linker

The TSM is able to extract some basic metadata from the rawdata. This can be column headings and 
filenames of csv file based sources or topic names, descriptions and additional data from MQTT 
sources. It is conceivable to use this data to support users with obvious suggestions.

## Why data sources are not stable in time

### Ideal world vs. reality

We all like stability in time. But in reality changes and errors cannot be excluded. They exist.

- legacy data loggers do not know which or what kind of sensor they're attached to, and they 
  don't detect changes to this 
- changing the sensor on the input doesn't automatically result in a new datastream channel id 
  (or another/new column when thinking in csv)

### Intentional and unintentional use cases when sensor changes but the stream id does not

- logger has limited number of inputs and sensors change from season to season
- sensor breaks and gets replaced by a new one (e.g. with a new serial number or from another 
  manufacturer)
- spatial position of a fixed sensor changes
- datalogger is used in different projects but configuration of it never changes
- sensor and inputs get changed unintentionally when someone is doing maintenance or if 
  someone stumbles over it while doing vacuum cleaning

### Automatic detection of sensor changes

- is possible with "higher integrated" sensors when loggers do support them and the sensors 
  transmit reliable metadata, e.g. serial numbers
- is not possible to reliable retrieve from data, analytics like jumps in the magnitudes could 
  only be clues and
  - can not detect all real world use cases
  - are part of the quality control/quality assurance
- is impossible, to be honest

### Manual detection and identification

- is the only way for reliable handling of the mentioned real world use cases
- happens after the appearance of the sensor or input change event in most cases
- leads to the fact, that we'll have datastream ids with temporal periods

**As we have to provide a frontend to mark this temporal periods we can use that to link to the 
meta data from the SMS.**