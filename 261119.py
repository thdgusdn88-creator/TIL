import psycopg
from psycopg.rows import dict_row

# DSN : Data Source Name
DSN = "host=localhost port=5432 dbname=sportscenter user=postgres password=admin1234"

MONTH = "2026-11"

LIST_SQL = """
SELECT c.course_id, s.sport_name, c.course_name, c.class_days, c.fee
FROM courses c
JOIN sports s ON c.sport_id = s.sport_id
ORDER BY c.course_id
"""


# 수강 신청가능 목록 조회
def list_courses(conn):
    print(f"\n=== {MONTH} 수강 신청 가능 강좌 ===")
    for c in conn.execute(LIST_SQL):
        print(f"{c['course_id']:>3} | {c['sport_name']} | {c['course_name']} | {c['class_days']} | {c['fee']}원")
    print()


# 숫자 입력 받기 (숫자가 아니면 다시 요청)
def input_number(message):
    while True:
        text = input(message).strip()
        if text.isdigit():
            return int(text)
        print("숫자만 입력해 주세요.")



# 수강신청
def enroll(conn, member_id, course_id):
    # 회원 존재 확인
    member = conn.execute(
        "SELECT name FROM members WHERE member_id = %s",
        (member_id,)
    ).fetchone()
    if member is None:
        print("존재하지 않는 회원입니다.")
        return

    # 신청한 강좌의 수강료 추출
    course = conn.execute(
        "SELECT course_name, fee FROM courses WHERE course_id = %s",
        (course_id,)
    ).fetchone()
    if course is None:
        print("존재하지 않는 강좌입니다.")
        return
    fee = course['fee']

    # 중복 신청 확인 (취소한 기록은 제외)
    dup = conn.execute(
        "SELECT 1 FROM enrollments "
        "WHERE member_id = %s AND course_id = %s AND enroll_month = %s AND status <> '취소'",
        (member_id, course_id, MONTH)
    ).fetchone()
    if dup:
        print("이미 신청한 강좌입니다.")
        return


    # 신청 내용 저장
    conn.execute(
        "INSERT INTO enrollments (member_id, course_id, enroll_month, status, pay_amount) "
        "VALUES (%s, %s, %s, '수강중', %s)",
        (member_id, course_id, MONTH, fee)
    )

    print("\n수강신청 완료되었습니다.")
    print(f"  회원   : {member['name']} (번호 {member_id})")
    print(f"  강좌   : {course['course_name']} (번호 {course_id})")
    print(f"  수강월 : {MONTH}")
    print(f"  결제액 : {fee}원")


def main():
    with psycopg.connect(DSN, row_factory=dict_row, autocommit=True) as conn:
        # 수강목록
        list_courses(conn)

        # 입력 로직
        member_id = input_number("회원번호를 입력하세요: ")
        course_id = input_number("신청할 강좌번호를 입력하세요: ")

        # 수강신청
        enroll(conn, member_id, course_id)


if __name__ == "__main__":
    main()