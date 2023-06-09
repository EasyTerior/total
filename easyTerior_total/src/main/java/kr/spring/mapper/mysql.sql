-- 회원 테이블 생성
CREATE TABLE member(
	memIdx INT,
	memID VARCHAR(50) NOT NULL,
	memPassword VARCHAR(150) NOT NULL,
	memName VARCHAR(50) NOT NULL,
	memNickname VARCHAR(50),
	memPhone VARCHAR(50),
	memEmail VARCHAR(150),
	memAddress VARCHAR(150),
	memProfile VARCHAR(150), -- photo가 아니라 경로 저장용. 
	PRIMARY KEY(memID) --  기본키
);

DROP TABLE member;
SELECT * FROM member;

-- admin 계정 추가?
SET @nextIdx = (SELECT IFNULL(MAX(memIdx) + 1, 1) FROM member);  -- 자동으로 idx 추가하면서 생성.
INSERT INTO member(memIdx, memID, memPassword, memName, memNickname, memPhone, memEmail, memAddress, memProfile)
VALUES (@nextIdx, 'admin', '1234', '관리자', 'admin관리자', '010-0000-0000', 'admin@admin.com', '주소', '');
-- memID가 key니까 중복 아니면 생성됨.
INSERT INTO member(memIdx, memID, memPassword, memName, memNickname, memPhone, memEmail, memAddress, memProfile)
VALUES (@nextIdx, 'admin1', '1234', '관리자', 'admin관리자', '010-0000-0000', 'admin@admin.com', '주소', '');
-- memID가 key니까 중복 아니면 생성됨.

DELETE FROM member;

-- 스타일 저장
CREATE TABLE savestyle(
	styleIdx INT AUTO_INCREMENT,
	resultClass1 VARCHAR(1000) NOT NULL,
	resultClass2 VARCHAR(1000) NOT NULL,
	resultClass1_probability VARCHAR(1000) NOT NULL,
	resultClass2_probability VARCHAR(1000) NOT NULL,
	memID VARCHAR(50),
	PRIMARY KEY(styleIdx)
);

SELECT * FROM testsavestyle;

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

-- INSERT INTO BOARD (title, content, writer)
-- VALUES('제목으로 뭐하지','팝콘은 어니언과 달콤 반반으로 할 것', '메가박스');

SELECT * FROM board;

-- DELETE FROM board;