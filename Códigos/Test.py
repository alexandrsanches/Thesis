# Variables

pacient_name = "John Smith"
age = 20
new_pacient = True

print(f"Pacient name: {pacient_name}")
print(f"You are {age} years old")

if new_pacient:
    print("You are a new paciente")
else:
    print("You are NOT a new pacient")

# Arithmetics
# + addition
# - subtraction
# * multiplication
# * division
# // integer of a division
# % remainder of a division

friends = 5

friends = friends + 1

friends += 1
friends -= 1
friends *= 2
friends /= 4

print(f"{friends}")

# Typecasting

str()
int()
float()
bool()

name = "Alexandre"
age = 25
gpa = 4.5
is_student = True

gpa = int(gpa)
age = str(age)

print(type(age))
print(age)

age += "1"

# User input

name = input("Enter your name: ")
age = int(input("Enter you age: ")) + 1

print(f"Welcome {name}")
print(f"You're {age} years old.")


# If statements
# if, elif and else

age = int(input("Enter your age: "))
has_ticket = True
price = 10.0

if age >= 65:
    print("You are a senior citizen")
    print(f"The price for a senior is ${price * 0.75}")
elif age >= 18:
    print("You are an adult")
    print(f"The price for an adult is ${price}")
else:
    print("You are a child")
    print(f"The price for a child is ${price * 0.5}")

# Logical operators
# or = at least one condition is true
# and = both conditions must be true
# not = inverters the condition (not False, not True)

temp = 36
is_raining = False

if temp > 35 or temp < 0 or is_raining:
    print("The outdoor event is canceled")
else:
    print("The outdoor event is still scheduled")
