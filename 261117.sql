-- 주석은 -- 데이터베이스 생성 (Data Definition Lauguage) 
-- 이름은 정확히 docker-compose.yaml 파일 이름으로 만들어서 아래와 같은 형식으로 만들어야 함

-- services:                                                 # 실행할 컨테이너(서비스) 목록 — 필수
--   db:                                                     # 예: db, web (직접 정하는 이름)
--     image: postgres:18                                    # 사용할 이미지
--     container_name: kant-pg                               # 컨테이너 이름 (생략 시 자동 생성)
--     environment:                                          # 환경 변수 (-e)
--       POSTGRES_PASSWORD: admin1234
--     ports:                                                # 포트 연결 (-p) — 문자열로 감싸는 것을 권장
--       - "5433:5432"
--     volumes:                                              # 볼륨 연결 (-v)
--       - pgdata:/var/lib/postgresql

-- volumes:                                                  # 사용할 볼륨 선언 (최상위)
--   pgdata:
--     external: truef


CREATE DATABASE sportscenter;

--회원 테이블 tbs_테이블명, viw_뷰명(DDL)



CREATE TABLE members
(
    member_id   SERIAL      PRIMARY KEY,
    name        VARCHAR(30) NOT NULL,
    gender      CHAR(1)     NOT NULL,
    birth_year  SMALLINT    NOT NULL,
    phone       VARCHAR(20),
    email       VARCHAR(50),
    region      VARCHAR(10),
    join_date   DATE        NOT NULL
);

-- 회원 등록
-- INSERT INTO members (컬럼1, 컬럼2, 컬럼3) VALUES (컬럼1값, 컬럼2값, 컬럼3값);
-- INSERT INTO members VALUES (모든 컬럼, , , , ,);
-- INSERT INTO members SELECT * FROM WHERE ~~~~~

-- INSERT INTO members (컬럼1, 컬럼2, 컬럼3)
-- VALUES 
-- (컬럼1값, 컬럼2값, 컬럼3값),
-- (컬럼1값, 컬럼2값, 컬럼3값),
-- (컬럼1값, 컬럼2값, 컬럼3값)

-- Data Manipulate Lauguage (DML)
INSERT INTO members
(
    name,
    gender,
    birth_year,
    phone,
    email,
    region,
    join_date
)
VALUES
(
    '김하늘',
    'F',
    1995,
    '010-1234-5678',
    'haneul@example.com',
    '마포구',
    '2026-09-01'
);

-- 종목 개설강좌 목록
CREATE TABLE sports
(
    sport_id   SERIAL      PRIMARY KEY,
    sport_name VARCHAR(20)  NOT NULL
);

INSERT INTO sports (sport_name) VALUES ('수영');
INSERT INTO sports (sport_name) VALUES ('헬스');

-- 개설 강좌
CREATE TABLE courses
(
    course_id       SERIAL      PRIMARY KEY,
    sport_id       INT         NOT NULL REFERENCES sports (sport_id), -- 외래 키 (Foregn Key)
    course_name     VARCHAR(30) NOT NULL,
    level           VARCHAR(10) NOT NULL,
    class_days      VARCHAR(10) NOT NULL,
    start_time      TIME        NOT NULL,
    capacity        SMALLINT    NOT NULL,
    fee             INT         NOT NULL
);

INSERT INTO courses (sport_id, course_name, level, class_days, start_time, capacity, fee)
VALUES (1, '수영 초급 새벽반', '초급', '월수금', '06:00', 20, 70000);
INSERT INTO courses (sport_id, course_name, level, class_days, start_time, capacity, fee)
VALUES (2, '헬스 자유이용', '자유', '매일', '06:00', 50, 50000);
INSERT INTO courses (sport_id, course_name, level, class_days, start_time, capacity, fee)
VALUES (30, '헬스 자유이용', '자유', '매일', '06:00', 50, 50000);

-- 1:1 사물함 테이블 생성
CREATE TABLE lockers
(
    locker_no   INT     PRIMARY KEY,
    member_id   INT     NOT NULL UNIQUE REFERENCES members (member_id) ON DELETE CASCADE,
    asign_date  DATE    NOT NULL
);

INSERT INTO lockers VALUES (101, 1, '2026-11-01');
INSERT INTO lockers VALUES (102, 3, '2026-11-01');      -- 임시회원


-- 수강 신청 테이블
CREATE TABLE enrollments
(
    member_id       INT             NOT NULL REFERENCES members (member_id),
    course_id       INT             NOT NULL REFERENCES courses (course_id),
    enroll_month    CHAR(7)         NOT NULL,
    status          VARCHAR(10)     NOT NULL,
    pay_amount      NUMERIC(10,2)    NOT NULL CHECK (pay_amount >=0),
    PRIMARY KEY (member_id, course_id, enroll_month)
);

INSERT INTO enrollments 
VALUES (1, 1, '2026-11', '수료', 50000);
INSERT INTO enrollments 
VALUES (2, 2, '2026-10', '수료', 70000);
INSERT INTO enrollments 
VALUES (2, 2, '2026-10', '수료', 60000);


-- 강사 테이블 작성
CREATE TABLE instructors
(
    instructor_id       SERIAL          PRIMARY KEY,
    name                VARCHAR(20)     NOT NULL,
    sport_id           INT             NOT NULL REFERENCES sports (sport_id),
    phone               VARCHAR(20),
    hire_date           DATE            NOT NULL         
);

INSERT INTO instructors (name, sport_id, phone, hire_date)
VALUES
('홍길동', 1, '010-1234-1234', '2025-01-01'),
('손흥민', 1, '010-1234-0000', '2025-01-11');


-- 테이블 수정 ALTER TABLE

ALTER TABLE courses
ADD COLUMN  instructor_id INT REFERENCES instructors (instructor_id);

SELECT DISTINCT region FROM members;

SELECT DISTINCT sport_id level FROM courses;

SELECT * FROM members WHERE member_id <=7;

SELECT * FROM members WHERE region = '마포구';

SELECT COUNT(*) AS"E-mail 미기재" FROM members WHERE email IS NULL;

SELECT * FROM members WHERE birth_year BETWEEN 1995 AND 2000;

SELECT * FROM courses WHERE course_id IN (1, 5, 10);

SELECT * FROM members WHERE name LIKE '김%';