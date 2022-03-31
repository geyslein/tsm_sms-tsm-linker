create table link
(
    id                     numeric      not null primary key,
    tsm_instance           varchar(200) not null,
    tsm_thing              uuid         not null,
    tsm_datasource_id      numeric      not null,
    sms_instance           varchar(200) not null,
    sms_configuration_id   numeric      not null,
    sms_device_property_id numeric      not null,
    start_date             timestamp,
    end_date               timestamp,
--     created_by             varchar(200) not null,
--     updated_by             varchar(200) not null,
    unique (
            tsm_instance,
            tsm_thing,
            tsm_datasource_id,
            sms_instance,
            sms_configuration_id,
            sms_device_property_id,
            start_date,
            end_date
        )
)