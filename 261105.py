    # 클래스 정의 또는 선언 -> 쉽게 말해서 붕어빵 틀을 만든거임
class User:
    def __init__ (self, name): # 생성자 : 클래스가 처음 생성될 때 자동으로 호출 -> 클래스로 만들어진 자기자신을 가르키는 self 인스턴스 self는 자동 할당 됨
        self.name = name       # 변수를 초기화 -> 인스턴스 변수

    def show(self): # 메서드 클래스 안에 쓰여진 함수들은 메서드라 함
        return f"회원 이름: {self.name}"

# 인스턴스 생성 -> 붕어빵 만들기
user_a = User("손흥민")
user_b = User("이강인")

# User 클래스로 생성한 인스턴스 (메모리에 생성)

#클래스의 인스턴스 변수
print(user_a.name)
print(user_b.name)

#클래스의 매서드 접근
print(user_a.show())
print(user_b.show())


print(type(user_a)) # __main__.User
print(user_a is user_b)
print(id(user_a)) #
print(id(user_b)) # 서로 다른 주소 사용

# ========================================

class Monitor:
    def display_info(self):
        # 인스턴스 변수
        self.resolution = "1920X1080"
        self.size = "27인치"
        print(f"모니터 정보\n해상도: {self.resolution}\n크기: {self.size}\n객채 ID: {id(self)}")

monitor = Monitor() # 인스턴스 생성 = 모니터 객체 생성
print(id(monitor)) # 모니터 인스턴스의 ID 출력

monitor.display_info()

#==================================
class SmartPhone: 
    def __init__(self, model):    # __init__ 는 특수 메서드
        self.model = model # 속성 (Attribute)
        self.battery = 50 # 속성 (Attribute)

    def charge(self, amount):
        self.battery += amount  # 여기서 배터리 변수는 같은거임
        if self.battery > 100:
            self.battery = 100
            print(f"배터리 충전 완료 : {self.battery}%")
        else:
            print(f"배터리 충전 중 : {self.battery}%")

phone_a = SmartPhone("아이폰")
print(phone_a.model)
phone_a.charge(30)
phone_a.charge(30)

phone_b = SmartPhone("갤럭시")
print(phone_b.model)
phone_b.charge(10)
phone_b.charge(10)

# 은행 계좌 클래스

class BankAccount:
    def __init__(self, owner, balance):
        self.owner = owner              # 계좌 예금주
        self.balance = balance          # 잔액

    def __str__(self):
        return f"예금주 : {self.owner}, 잔액: {self.balance:,}"

    def __repr__(self):
        return f"예금주 : {self.owner}, 잔액: {self.balance:,}"


    # 입금 처리 메서드
    def deposit(self, amount):
        self.balance += amount #입금처리
        print(f"{amount:,} 입금완료 / 잔액  : {self.balance:,}원")

    # 출금 메서드
    # 잔액 확인 => 잔액 부족 메세지 출력

    def withdraw(self, amount):
        # psudo Code  -> 내가 구현할 로직을 글로 써두기
        # 잔액 확인
        if self.balance < amount:
            print(f"잔액이 부족합니다")
            return 0    # -> 잔액이 부족하면 나가짐

        self.balance -= amount
        print(f"{amount:,} 출금 처리")
        return self.balance # 출금 후 잔액 리턴

account_a = BankAccount("송현우", 100_000)
print(account_a)
account_a.deposit(500_000)

account_a.withdraw(1_000_000)

print(f"잔액: {account_a.withdraw(200_000):,}")

print(f"잔액: {account_a.withdraw(300_000):,}")

account_c = BankAccount("홍길동", 200_000)
print([account_a, account_c])


# shopping cart 클래스 선언
# 상품 목록 저장 기능

# 메서드
# - 장바구니 담기
# - 장바구니 빼기
# - 상품 목록 조회
class Shoppingcart:
    # 저장공간
    def __init__(self):
        self.bucket = []
    # 장바구니 담기
    def add_item(self, item):
        self.bucket.append(item)
    # 장바구니 빼기
    def remove_item(self, item):
        self.bucket.remove(item)
    # 상품 목록 조회
    def show_items(self):
        return self.bucket
# 상품 클래스
# 속성 = 변수 = 인스턴스 변수
# - 제품명, 가격
class Item:
    def __init__(self, name, price):
        self.name = name
        self.price = price
# 쇼핑 카트 생성
cart = Shoppingcart()
#상품 3개 생성
item_a = Item("초코파이",2000)
item_b = Item("새우깡",3000)
item_c = Item("빅파이",1000)
# 상품 1개 장바구니 담기
cart.add_item(item_a)
# 상품 1개 장바구니 담기
cart.add_item(item_b)
# 상품 1개 장바구니 담기
cart.add_item(item_c)
# 상품 1개 장바구니에서 뺴기
cart.remove_item(item_b)
# 장바구니에 담긴 상품 목록 조회
for item in cart.show_items():
    print(item.name, item.price)