-- 회원 테이블 생성
CREATE TABLE member(
	memIdx INT,
	memID VARCHAR(20) NOT NULL,
	memPassword VARCHAR(68) NOT NULL,
	memName VARCHAR(20) NOT NULL,
	memAge INT,
	memGender VARCHAR(20),
	memEmail VARCHAR(150),
	memProfile VARCHAR(50), -- photo가 아니라 경로 저장용. 
	PRIMARY KEY(memID) --  기본키
);

-- DROP TABLE member;
SELECT * FROM member;

-- admin 계정 추가
INSERT INTO member(memID, memPassword, memName, memAge, memGender, memEmail, memProfile)
VALUES('admin', '1234', '관리자', 20, '여자', 'admin@admin.com', '');

DELETE FROM member;

-- 게시판 테이블 생성
CREATE TABLE board(
	idx INT NOT NULL AUTO_INCREMENT,
	memID VARCHAR(20) NOT NULL,
	title VARCHAR(100) NOT NULL,
	content VARCHAR(2000) NOT NULL,
	writer VARCHAR(50) NOT NULL,
	indate DATETIME DEFAULT NOW(),
	count INT DEFAULT 0,
	PRIMARY KEY(idx)
);

-- DROP TABLE board;

INSERT INTO BOARD (title, content, writer)
VALUES('제목으로 뭐하지','팝콘은 어니언과 달콤 반반으로 할 것', '메가박스');

INSERT INTO BOARD (title, content, writer)
VALUES('오늘 영화 뭐 볼까','가디언즈 오브 갤럭시 3', '가오갤');

INSERT INTO BOARD (title, content, writer)
VALUES('그 다음에 뭐 보지','영화 추천 좀', '뭐보냐');

INSERT INTO BOARD (title, content, writer)
VALUES('공지사항','중요합니다 확인해주세요', '관리자');

INSERT INTO BOARD (title, content, writer)
VALUES('영화 드림, 바비, 킬링로맨스 셋 중 뭐보지','제곧내 뭐 볼지 추천좀', '추천ㄱ');

INSERT INTO BOARD (title, content, writer)
VALUES('당근을 흔들어주세요','제곧내 살려줘', '당근');

SELECT * FROM board;

-- DELETE FROM board;