Create table netflix(
	show_id	varchar(25),
	type varchar(25),
	title varchar(255),	
	director varchar(255),
	casts varchar(1000),
	country	varchar(1000),
	date_added	varchar(50),
	release_year int,	
	rating varchar(50),
	duration	varchar(50),
	listed_in	varchar(255),
	description varchar(500)
);

select * from netflix