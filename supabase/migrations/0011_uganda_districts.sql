-- Required reference data for Buyer/Supplier registration and lead-distance matching.
insert into districts(id,name,region,lat,lng) values
 ('kampala','Kampala','Central',0.34760,32.58250),
 ('wakiso','Wakiso','Central',0.40440,32.45940),
 ('mukono','Mukono','Central',0.35330,32.75530),
 ('entebbe','Entebbe','Central',0.05120,32.46330),
 ('jinja','Jinja','Eastern',0.42440,33.20420),
 ('mbale','Mbale','Eastern',1.06440,34.17970),
 ('soroti','Soroti','Eastern',1.71460,33.61110),
 ('tororo','Tororo','Eastern',0.69280,34.18080),
 ('lira','Lira','Northern',2.23500,32.90970),
 ('gulu','Gulu','Northern',2.77460,32.29900),
 ('arua','Arua','Northern',3.02010,30.91100),
 ('hoima','Hoima','Western',1.43510,31.35240),
 ('masaka','Masaka','Central',-0.34100,31.73600),
 ('mbarara','Mbarara','Western',-0.60720,30.65450),
 ('fort-portal','Fort Portal','Western',0.65400,30.27500),
 ('kabale','Kabale','Western',-1.24830,29.98990),
 ('kiryandongo','Kiryandongo','Western',1.87000,32.07000)
on conflict(id) do update set name=excluded.name,region=excluded.region,lat=excluded.lat,lng=excluded.lng;
