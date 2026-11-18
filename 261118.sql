-- 1번
SELECT
    member_id           AS 회원번호,
    name                AS 이름,
    birth_year          AS 출생연도,
    region              AS 거주지역,
    phone               AS 전화번호,
    email               AS email작성요망
FROM members
WHERE birth_year  BETWEEN 1970 AND 1989 AND email IS NULL
ORDER BY birth_year, member_id
LIMIT 3;


-- 2번
SELECT
    region                          AS 거주지역     ,
    CASE gender
        WHEN 'M' THEN '남'
        WHEN 'F' THEN '여'
    END                             AS 성별         ,
    COUNT(*)                        AS 회원수       ,
    ROUND(AVG(birth_year))          AS 평균출생연도 
FROM members
GROUP BY region, gender
HAVING COUNT(*) >= 5
ORDER BY region COLLATE "ko-x-icu", gender DESC


-- 3번
SELECT
    m.name      AS 회원명,
    m.phone     AS 전화번호,
    c.course_name AS 강좌명,
    e.enroll_month AS 수강월
FROM enrollments e
JOIN members m ON e.member_id = m.member_id
JOIN courses c ON e.course_id = c.course_id
WHERE e.enroll_month = '2026-10' AND e.status = '취소'
ORDER BY m.name;


-- 4번
SELECT
    s.sport_name              AS 종목,
    e.enroll_month      AS 수강월,
    COUNT(*)            AS 수강인원,
    SUM(c.fee)          AS 매출
FROM enrollments e
JOIN courses c ON e.course_id = c.course_id
JOIN sports  s ON c.sport_id  = s.sport_id
WHERE e.status <> '취소'
GROUP BY s.sport_name, e.enroll_month
HAVING SUM(c.fee) >= 1000000
ORDER BY s.sport_name COLLATE "ko-x-icu", e.enroll_month;

-- 5번
SELECT
    i.name                          AS 강사명,
    s.sport_name                          AS 종목,
    COUNT(DISTINCT c.course_id)     AS 담당강좌수,
    COUNT(e.enroll_month)          AS 이번달신청
FROM instructors i
LEFT JOIN sports s      ON i.sport_id = s.sport_id
LEFT JOIN courses c     ON c.instructor_id = i.instructor_id
LEFT JOIN enrollments e ON e.course_id = c.course_id
                       AND e.enroll_month = '2026-11'
GROUP BY i.instructor_id, i.name, s.sport_name
ORDER BY 이번달신청 DESC, i.name COLLATE "ko-x-icu";