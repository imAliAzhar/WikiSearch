create table Lexicon(
	WordID mediumint unsigned auto_increment,
    Word varchar(50),
    
    constraint primary key pk (WordID)
    );
    
create table Indexes(
	PageID mediumint unsigned,
    WordID mediumint unsigned,
    Position mediumint unsigned,
    Priority tinyint unsigned,
    
    constraint pk primary key (pageID, WordID, Position)
    );
    
create table Pages(
	PageID mediumint unsigned auto_increment,
    URL varchar(500),
    
    constraint pk primary key (pageID)
    );
    
create table Citations(
	PageID mediumint unsigned,
    CitationID mediumint unsigned,
    
    constraint pk primary key (pageID, CitationID)
    );
    
alter table indexes
	add constraint fk foreign key (pageID) references Pages(PageID);
alter table indexes
	add constraint fk2 foreign key (WordID) references Lexicon(WordID);
alter table citations
	add constraint fk3 foreign key (pageID) references Pages(PageID);
alter table citations
	add constraint fk4 foreign key (CitationID) references Pages(PageID);