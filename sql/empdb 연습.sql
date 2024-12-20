/*	
1. mysql 데이터타입
	
    정수
		int
		tinyint(=byte 1)
        smallint(=short 2)
        bigint(=long 8)
        decimal(10,0)
        
	실수
		float (4)
        double (8)
        decimal(10,1)
        
	문자열 
		char(글자개수)
        varchar(글자개수)
        text(65536까지)
        
	날짜시간
		date
        time
        timestamp


select version(); -- mysql db 버전

	
3. 테이블 수정 및 삭제 

	#만약 기존 테이블에 컬럼을 수정해야 한다면....
		-- 방법1   drop table member; 후 새로 만든다(비추). 그러나 데이터가 저장된 상태라면 데이터 같이 삭제됨, 복구 안됨  
		-- 방법2   alter table 테이블명 [명령키워드] 컬럼명 변경사항;

	alter table 테이블명 add 컬럼명 타입(길이); -- 컬럼 타입수정(만약 이미 데이터가 들어있는 경우 더 짧은 길이 수정 안됨 - truncate 에러발생)
	alter table 테이블명 modify address varchar(50); -- 컬럼 길이수정
	alter table 테이블명 change address addr varchar(50);-- 기존 컬럼 길이, 이름까지 수정 
	alter table 테이블명 drop addr;-- 기존 컬럼 삭제(만약 이미 데이터가 들어있는 경우 같이 삭제됨)
	alter table 테이블명 rename column 변경전컬럼 to 변경후컬럼;
	drop table member; -- 테이블 삭제
	drop table if exists member; -- 권장

4. 데이터 무결성(입력하는 데이터는 현실에서 사용하는 데이터와 똑같이 결점이 없어야 한다) 보장 
	-> 데이터 규칙 설정 -> 데이터 제약조건 constraint
    -> 제약조건 정의는 DDL 에서
    -> 제약조건 효력은 DML 실행시에
	
    1) 현재 컬럼값은 Null이 될 수 없다. - not null
    2) 현재 컬럼값은 다른 레코드의 컬럼값과 중복될 수없다. - unique
    3) not null + unique -> primary key
    4) 현재 컬럼값은 다른 테이블의 컬럼 존재하는 값만 가능하다. - foregin key
    5) 사용자정의 제약조건 설정 - check (컬럼명 제약조건)
		-- check 로 설정한 제약조건은 desc 테이블 명령어로 볼 수 없다.
        
		1. root 계정으로 information_schema DB 사용
		2. table_constraints 테이블 조회
			select  *from table_constraints where table_name = 'c_member';       
        
    6) default , auto_increment
		auto_increment 지정시 반드시 primary key 를 같이 적용해야 한다.
    
    
현재 테이블에 설정한 제약조건을 확인하는 방법 - check () 포함
	1. root 계정으로 information_schema DB 사용
    2. table_constraints 테이블 조회
		select * from table_constraints where table_name = 'c_member';
        
	3. 계정 안바꾸고 바로 조회하는 방법
		select * from information_schema.table_constraints where table_name = 'c_member';
   
	4. 일반 제약조건 삭제
		alter table c_memo drop constraint 제약조건명;  
        
	5. 외래키 지정
		alter table 테이블명 add constraint [외래키명] foreign key (컬럼명) references 참조할테이블명(컬럼명);

	6. 외래키 삭제
		alter table 테이블명 drop foreign key 외래키제약조건명;    
        
	7. 외래키로 참조하고 있는 컬럼의 데이터 삭제나 업데이트시 자동으로 관련 레코드를 함께 삭제 또는 업데이트
		alter table 테이블명 add constraint [외래키명] foreign key (컬럼명) references 참조할테이블명(컬럼명) 
		on delete cascade on update cascade;        
*/


/* member 테이블 생성
	아이디 varchar(20)
	이름 varchar(10) 
	암호 int
	폰번호 char(13)
	이메일 varchar(30)
	가입일 datetime
    
위의 스키마를 가진 테이블을 설계하시오. */


#생성한 member 테이블의 구조를 확인하시오.


/* member 테이블에 아래의 데이터를 삽입후 조회하시오.
	'ID1','홍길동',1111,'010-1234-5678','HONG@mul.com','2023-03-29 14:06:10'
	'ID2','박길동',2222,'010-5678-1234','park@mul.com',현재날짜시각
	'ID3','우재남',3333,'010-8888-1234','wook@camp.com',현재날짜
*/


select * from member;


#현재의 자동커밋설정 상태를 확인하시오. 결과가 1이면 자동 DML commit,rollback 취소불가능


#자동커밋설정 상태를 0으로 지정하여 start transaction 할 수 있도록 수동설정 하시오.


#폰번호가 1234인 회원의 이름, 암호, 폰번호를 조회하시오.



#member 테이블에서 varchar(10)인 address 컬럼을 추가하시오.


#member 테이블에 아래의 데이터를 삽입후 조회하시오.
#'ID4','강남길',5555,'010-5555-1234','kang@camp.com',현재날짜, '서울시 강남구'



#member 테이블에서 address 컬럼의 타입을 varchar(50)으로 변경하시오.


#member 테이블에서 address 컬럼의 이름과 타입의 길이를 addr varchar(50)으로 변경하시오.


#member 테이블에서 addr 컬럼을 삭제후 조회하시오.(만약 이미 데이터가 들어있는 경우 같이 삭제)


#member 테이블을 완전히 삭제후 테이블 목록을 조회하시오.


/*
아래의 제약조건을 가진 c_member 회원정보 테이블을 생성후 구조를 확인하시오.
	memberid varchar(20) 널허용X 유일 comment '아이디',
	name varchar(10) 널허용X comment '이름',
	pw int comment '암호',
	phone char(13) 유일 comment '폰번호',
	email varchar(30) ',,@,,,,형식' comment  '이메일',
	regtime datetime 기본값으로 현재시각 comment '가입일' 
*/


/* c_member 테이블에 아래의 데이터를 삽입후 조회하시오.
	'ID1','홍길동',1111,'010-1234-5678','hong@mul.com',현재날짜시각
	'ID1','박길동',2222,'010-4321-5678','park/mul.com',기본값
	'ID2','박길동',2222,'010-4321-5678','park@mul.com',기본값
	'ID3','우재남',3333,'010-5678-1111','woo@mul.com',기본값
	'ID4','남궁성',4444,'010-4321-2222','nam@mul.com',현재날짜
*/



/*
아래의 제약조건을 가진 memo 메모장 테이블을 생성후 구조를 확인하시오.(기존에 테이블이 있을경우 삭제하시오)
	memoid int 주키 자동증가 comment '메모코드',
    title	varchar(50) 널허용X comment '제목',
    contents  텍스트 또는 가변길이4000 comment '내용',
    writingtime datetime 기본값으로현재날짜시간 comment '메모작성시간',
    writer varchar(20) comment, '작성자' 테이블에 존재하는 아이디만 허용
    멤버테이블의 memberid를 기준으로 외래키 fk_memo_cmember 설정
*/


#c_memo 테이블에 설정되어 있는 외래키를 삭제후 확인하시오.


-- 외래키 삭제 확인 : 설정된 제약조건(명) 확인


#c_memo 테이블에서 memberid 컬럼이 c_member테이블의 memberid를 참조하도록 외래키 fk_cmemo_cmember를 설정후 확인하시오.


/* c_memo 테이블에 아래의 데이터를 삽입후 조회하시오.
		null, '1번글제목', '1번글 내용입니다.', default, 'ID1'
		'1번글제목', 'ID1'
		null, '3번글제목', '3번글 내용입니다.', default, 'ID5' -- fk 제약조건 위배
		null, '3번글제목', '3번글 내용입니다.', default, 'ID2'
*/


#ID2 회원이 탈퇴하려고 했지만 c_memo에서 참조하는 레코드 때문에 삭제 안되는데 이때 해결방법 3가지를 제시하시오.
		
        
#c_memo의 데이터 삭제전


#위 참조레코드 설정후 c_member 테이블에서 ID2 레코드를 삭제후 c_memo의 데이터까지 확인하시오.


#c_memo의 데이터 삭제후















